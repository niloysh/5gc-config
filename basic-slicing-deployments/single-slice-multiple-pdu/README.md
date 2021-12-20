# Single network slice with two PDU sessions (2 UPFs)

In this scenario, we have one network slice (1 S-NSSAI), 2 UEs and 2 UPFs. Each UE establishes a separate PDU session with an UPF.

![multi upf](../images/multi_upf_deployment.png)



**Table of Contents**

- [Setting up the VMs](#setting-up-the-vms)
- [Configuration](#configuration)
- [Running the NFs](#running-the-nfs)
- [Packet captures](#packet-captures)


## Setting up the VMs
Same as Single network slice with a single PDU session. See [instructions](../single-slice-single-pdu/README.md#setting-up-the-vms). 

In addition, we have a second VM for UPF2 (192.168.1.22) which is just a clone of UPF1.

## Configuration
Very similar to Single network slice with a single PDU session. See [instructions](../single-slice-single-pdu/README.md#configuration). 

Some of the changes involved are as follows:
- Now there are two upf configuration files, [upfcfg1](config/upfcfg1.yaml) and [upfcfg2](config/upfcfg2.yaml).
- There are now two DNNs, `network1` and `network2` which are added to the [amfcfg](config/amfcfg.yaml) file.
- The [smfcfg](config/smfcfg.yaml) file has been modified to include both UPFs.

## Running the NFs
Similar to Single network slice with single PDU session. See [instructions](../single-slice-single-pdu/README.md#running-the-nfs)

## Packet captures
Packet captures from the VMs are in the `pcaps` directory. These may be useful in debugging connectivity issues and to see the messages exchanged among the VMs.


