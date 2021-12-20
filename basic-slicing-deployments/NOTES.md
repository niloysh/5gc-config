# General notes on 5GC

Some notes in no particular order.

- PFCP uses UDP, port 8805

- The NGAP protocol stack is as follows:  `IP - SCTP - NGAP`
- SCTP - stream control transmission protocol - transport layer protocol - message oriented like UDP but with reliability. NGAP is found on the N2 reference point between the gNB and the AMF (Core Access and Mobility and Management Function) in order to support both UE and non UE associated services. This includes operations such as configuration updates, UE context transfer, PDU Session resource management and also support for mobility procedures. NGAP is also used to convey downlink and uplink NAS (Non Access Stratum) messages as a payload, as well as support CM Idle and CM Connected operations such as Paging and UE Context release.
- GTP-U works on top of UDP

## Identify network slices

The key to this is a parameter from the NG Application Protocol (NGAP) called the Single Network Slice Selection Assistance Information (S-NSSAI). When configuring virtual network functions in NG RAN there are lists of S-NSSAI exchanged, e.g. between gNB-CU CP and AMF during NGAP Setup procedure, to negotiate which network slices have to be supported in general. 

When it comes to connection establishment starting with NGAP Initial Context Setup for each PDU session that is established its individual S-NSSAI is signaled. 


