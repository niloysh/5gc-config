
# Extract avg. throughput per slice

- [Extract avg. throughput per slice](#extract-avg-throughput-per-slice)
  - [Calculating avg. throughput per slice](#calculating-avg-throughput-per-slice)
    - [Steps](#steps)
  - [PFCP session establishment](#pfcp-session-establishment)
    - [Forwarding data between UP and CP](#forwarding-data-between-up-and-cp)
    - [Packet detection rule (PDR)](#packet-detection-rule-pdr)
  - [Tracing the free5GC SMF](#tracing-the-free5gc-smf)
  - [Tracing the free5GC UPF](#tracing-the-free5gc-upf)
  - [Extracting PDR statistics from the gtp5g kernel module](#extracting-pdr-statistics-from-the-gtp5g-kernel-module)
    - [PDR statistics using gtp5gnl scripts](#pdr-statistics-using-gtp5gnl-scripts)
    - [Tracing `gtp5g.c`](#tracing-gtp5gc)


## Calculating avg. throughput per slice

To calculate the average throughput per slice, we need to extract performance metrics from the UPF NF. Specifically, From [3GPP TS 28.552](https://www.etsi.org/deliver/etsi_ts/128500_128599/128552/16.09.00_60/ts_128552v160900p.pdf), Sec 5.4.1.3, we need:

*Octets of GTP data packets on N3  interface, from RAN to UPF (GTP.InDataOctN3UPF.SNSSAI)*

A slice identifier, i.e., S-NSSAI may have one or more PDU sessions associated with it.
Thus, we need to calculate the number of GTP-U packets for a PDU session.

The UPF is managed by the SMF using PFCP. The SMF establishes PFCP sessions on the UPF per PDU session basis. The SM context stores SEID, PDU session id, and S-NSSAI. Refer to [context/sm_context.go#L51](https://github.com/free5gc/smf/blob/main/context/sm_context.go#L51)

### Steps
- Find mapping between S-NSSAI and PDU session (A S-NSSAI may have more than one PDU session).
- Identify PDU session using PDU session ID.
- Find mapping between PDU session and PFCP session.
- Identify PFCP session using F-SEID.
- Identify PDRs per PFCP session using PDR ID
- Use PDR ID at UPF gtp5g kernel module to dump UL/DL stats per PDR


**Note**: A good reference on [5g userplane analysis](https://datatracker.ietf.org/doc/html/draft-ietf-dmm-5g-uplane-analysis)


## PFCP session establishment
- A PFCP session is uniquely identified by *fully-qualified SEID (F-SEID)* which contains both *session endpoint identifier (SEID)* and *IP address*. 
- From [3GPP TS 29.244](https://www.etsi.org/deliver/etsi_ts/129200_129299/129244/16.05.00_60/ts_129244v160500p.pdf):
> The PFCP session related messages shall share the same F-SEID for the PFCP session

### Forwarding data between UP and CP

From [3GPP TS 29.244](https://www.etsi.org/deliver/etsi_ts/129200_129299/129244/16.05.00_60/ts_129244v160500p.pdf) (Section 5.3):

**From UP to CP**
> For forwarding data from the UP function to the CP function, the CP function shall provision PDR(s) per PFCP session context, with the PDI identifying the user plane traffic to forward to the CP function and with a FAR set with the Destination Interface "CP function side" and set to perform GTP-U encapsulation and to forward the packets to a GTP-u F-TEID uniquely assigned in the CP function per PFCP session and PDR.

**From CP to UP**
> For forwarding data from the CP function to the UP function, the CP function shall provision one or more PDR(s) per PFCP session context, with the PDI set with the Source Interface "CP function side" and identifying the GTP-u F-TEID uniquely assigned in the UP function per PDR, and with a FAR set to perform GTP-U decapsulation and to forward the packets to the intended destination.

- Fully qualified tunnel endpoint identifier (F-TEID)

### Packet detection rule (PDR)
From [3GPP TS 29.244](https://www.etsi.org/deliver/etsi_ts/129200_129299/129244/16.05.00_60/ts_129244v160500p.pdf) (Section 5.3):

> On receipt of a user plane packet, the UP function shall perform a lookup of the provisioned PDRs and:
> - identify first the PFCP session to which the packet corresponds; and
> - find the first PDR matching the incoming packet, among all the PDRs provisioned for this PFCP session, starting
with the PDRs with the highest precedence and continuing then with PDRs in decreasing order of precedence.

> Only the highest precedence PDR matching the packet shall be selected, i.e. the UP function shall stop the PDRs lookup once a matching PDR is found.


A packet detection rule (PDR) has the following information.
- in port
- IP address
- DNN
- PDR ID: This IE shall uniquely identify the Packet Detection Rule among all the PDRs configured for that PFCP session.

A PDR is also associated with a PDI and FAR.
- PDI contains information such as IP address and port information and is used to detect specific packets.
- FAR i.e., forwarding action rule, states what to do with the packet, such as forward packet, create GTP-U/UDP/IPv4 encapsulation, etc.


## Tracing the free5GC SMF

From the SMF, the following information is needed - S-NSSAI, PDU session IDs, SEIDs corresponding to the PDU sessions, and PDR IDs for each SEID.

- SEID for a UP node is allocated in [context/sm_context.go#L299](https://github.com/free5gc/smf/blob/3437241a3c03bbad1e88b47236fcd98b6f67333e/context/sm_context.go#L299)
  
- Activate uplink tunnel and put PDR to PFCP session in [context/datapath.go#L120](https://github.com/free5gc/smf/blob/3437241a3c03bbad1e88b47236fcd98b6f67333e/context/datapath.go#L120)
  
- PDU session ID and UE IP address allocation in [producer/pdu_session.go#L96](https://github.com/free5gc/smf/blob/3437241a3c03bbad1e88b47236fcd98b6f67333e/producer/pdu_session.go#L96)
  
- SM context stores SEID, PDU session id, and S-NSSAI in [context/sm_context.go#L51](https://github.com/free5gc/smf/blob/main/context/sm_context.go#L51)
  
- The PFCPSessionContext struct contains SEID, IP as well as PDR IDs. It is defined in [context/pfcp_session_context.go#L18](https://github.com/free5gc/smf/blob/3437241a3c03bbad1e88b47236fcd98b6f67333e/context/pfcp_session_context.go#L18)

- The PDI inside the PDR struct stores F-TEID information. This is defined in [context/pfcp_rules.go#L33](https://github.com/free5gc/smf/blob/3437241a3c03bbad1e88b47236fcd98b6f67333e/context/pfcp_rules.go#L33)

- Here is the information extracted from SMF context

  ![smcontext-info](images/smcontext-info-02.jpg)

  The combination of fields (PDRID + UEIPAddress + F-TEID) can be used to F-SEID and S-NSSAI.


## Tracing the free5GC UPF

From the UPF, we need to find Tx and Rx packets on the UL/DL per PDR.

- Build the UPF after changes to src
  ```bash
  cd ~/free5gc
  make upf
  ```

- To log debug messages, use the logging utililies in `lib/utlt/include/utlt_debug.c`  
  ```bash
  UTLT_Info("[NILOY] Test UPF log ...");
  ```
- GTP-U packets are handled in [src/up/up_match.go#L73](https://github.com/free5gc/upf/blob/main/src/up/up_match.h#L73)


## Extracting PDR statistics from the gtp5g kernel module

PDRs are handled by the [gtp5g](https://github.com/free5gc/gtp5g) kernel module.

The gtp5g module does not seem to store F-SEID. It only stores F-TEID. 

### PDR statistics using gtp5gnl scripts

- First run the 5G network from the UPF and the UE and establish a PDU session.
- You should see a gtp5g interface in `/proc`. If you don't, probably need to uninstall and reinstall the gtp5g kernel module. Once you have a PDU session established, you can use the gtp5gnl scripts to check the list of PDRs.

  ![pdr-list](images/upf-pdr-list.png)

- Then you can echo the upfgtp interface to `/proc/gtp5g/pdr` and see the following.

  ![pdr-details](images/upf-pdr-details.png)

**Todo**
 - Packet Tx and Rx count is not implemented. Need to change `gtp5g.c`
 - Some method to automatically log to file at specific intervals.

### Tracing `gtp5g.c`

**Note**: A reference on [reading and writing `/proc` file](https://devarea.com/linux-kernel-development-creating-a-proc-file-and-interfacing-with-user-space/)

- The PDR interface is created in the `/proc` filesystem in [gtp5g.c#L4075](https://github.com/free5gc/gtp5g/blob/master/gtp5g.c#L4075)
- PDR drop counters are maintained in `proc_gtp5g_pdr` struct in [gtp5g.c#L266](https://github.com/free5gc/gtp5g/blob/master/gtp5g.c#L266). Need similar counters for Tx and Rx packets.

- Read and write handlers for the `pdr` interface is set in [gtp5g.c#L3986](https://github.com/free5gc/gtp5g/blob/master/gtp5g.c#L3986)

- PDR details are printed in `gtp5g_pdr_read` in [gtp5g.c#L3719](https://github.com/free5gc/gtp5g/blob/master/gtp5g.c#L3719)

- `proc_pdr_read` https://github.com/free5gc/gtp5g/blob/master/gtp5g.c#L3943













