# 5GC setup with single UPF

- [5GC setup with single UPF](#5gc-setup-with-single-upf)
  - [Deployment scenario](#deployment-scenario)
  - [OpenStack Commands](#openstack-commands)
    - [Create upf instance on 5gc-net on cn201](#create-upf-instance-on-5gc-net-on-cn201)
    - [Create cirros instance on data net on host cn201](#create-cirros-instance-on-data-net-on-host-cn201)
    - [Create cirros2 on 5gc-net on host cn203](#create-cirros2-on-5gc-net-on-host-cn203)
    - [Add floating ip to server](#add-floating-ip-to-server)
    - [Configure git](#configure-git)
    - [Creating test ubuntu instance](#creating-test-ubuntu-instance)


## Deployment scenario

 
 
![single_upf](../images/single_upf_deployment.png)

The configuration files for this deployment are in the `single_upf/config` folder. 

## OpenStack Commands

This file contains *some* OpenStack commands used in the setup process.
Note that the commands here *need to be changed* to achieve the setup shown in the figure.

### Create upf instance on 5gc-net on cn201
**todo**: update all the command(s) with default security group rule allowing all incoming traffic.
```
server create --image free5gc-snapshot --flavor m1.medium --security-group ns-secgroup --availability-zone nova::cn201 --key-name ns-rsa-keypair --nic net-id=b66b9127-8323-4044-8041-e725fe91b79f,v4-fixed-ip=192.168.1.12 upf1
```



### Create cirros instance on data net on host cn201
```
server create --image cirros-test-image --flavor m1.tiny --security-group ns-secgroup  --availability-zone nova::cn201 --nic net-id=5f453db8-6320-4305-9271-4eb3923598b9,v4-fixed-ip=192.168.3.31 cirros1
```

### Create cirros2 on 5gc-net on host cn203
```
server create --image cirros-test-image --flavor m1.tiny --security-group ns-secgroup  --availability-zone nova::cn203 --nic net-id=b66b9127-8323-4044-8041-e725fe91b79f,v4-fixed-ip=192.168.1.32 cirros2
```

### Add floating ip to server
```
server add floating ip cirros2 10.10.0.151
```

### Configure git
```
git config --global user.name "Niloy Saha"
git config --global user.email "niloysaha.ns@gmail.com"
```

### Creating test ubuntu instance
```
server create --image free5gc-snapshot --flavor m1.medium  --availability-zone nova::cn203 --key-name ns-rsa-keypair --nic net-id=b66b9127-8323-4044-8041-e725fe91b79f,v4-fixed-ip=192.168.1.30 ubuntu1
```



