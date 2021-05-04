# 5GC Setup: Slicing 01

- [5GC Setup: Slicing 01](#5gc-setup-slicing-01)
  - [Deployment scenario](#deployment-scenario)
  - [VM placement](#vm-placement)

## Deployment scenario

- In this scenario, we have 2 S-NSSAI representing two network slices (each consisting of 1 SMF and 1 UPF). 
- UE1 and UE2 each connect to separate slices with 1 PDU session each.

![slicing 01](../images/slice_deployment_01.png)

The configuration files for this deployment are in the [config](config) directory.

## VM placement

The VM placement is the same as the [multi_upf](../multi_upf) scenario. Please see the [README](../multi_upf/README.md) there.