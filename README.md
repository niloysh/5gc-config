# 5gc-config
This repo contains configuration files for the deployment of 5G core, using
the [free5gc](https://github.com/free5gc/free5gc) project and UE and gNB
simulation using the [UERANSIM](https://github.com/aligungr/UERANSIM) project.

## Single UPF
This is the simplest scenario, with 1 S-NSSAI, 1 UE, and 1 UPF. The UE establishes a single PDU session with the UPF.

![single UPF](images/single_upf_deployment.png)

The configuration files and scripts are in the `single_upf` folder.





## Multiple UPFs
In this scenario, we have 1 S-NSSAI, 2 UEs and 2 UPFs. Each UE establishes a separate PDU session with an UPF.

![multi upf](images/multi_upf_deployment.png)

The configuration files and scripts are in the `multi_upf` folder.
