# Containerized 5G testbed deployment

Configuration files and documentation for the containerized 5G core and UERANSIM deployment.

## Containerized 5G Core
The containerized 5G core is deployed using Helm. The original charts were
taken from the [towards5gs project](https://github.com/Orange-OpenSource/towards5gs-helm). The charts were
modified for a few reasons, mainly to add additional UPF and SMF instances and
perform the corresponding changes in the Free5GC configuration files. The
container images for the UPF and SMF were also modified to include our modified
UPF and SMF binaries. 

## Deploying the 5G core helm chart.
The helm chart for the 5G core is
[here](helm-charts/free5gc-multi-slice-0.1.3.tgz). For the chart to work you
need to complete/setup the following:
1. A Kubernetes cluster with a sufficient amount of workers to run the
   containers. The [gtp5g kernel module](https://github.com/PrinzOwO/gtp5g)
   needs to be installed on any worker that the UPF containers might run on, in
   most cases it's best to install it on all of the worker nodes. 

1. Flannel CNI plugin. See [here](https://github.com/flannel-io/flannel)

1. Multus-CNI plugin installed. See [here](https://github.com/k8snetworkplumbingwg/multus-cni) for directions.

1. Install [Helm3](https://helm.sh/docs/intro/install/).

1. Configure the networking parameters of the chart for your Kluster. See
   [here](https://github.com/Orange-OpenSource/towards5gs-helm/tree/main/charts/free5gc#networks-configuration)
   for a list of the parameters that need to be configured.

1. Configure a persistent volume for the MongoDB that stores persistent state.
   You can also set up a persistent volume provisioner so that persistent
   volume claims are automatically allocated a volume in the case that their
   request can be supported by the storage backing the persistent volumes. For
   testing purposes we've used static provisioning as is described
   [here](https://kubernetes.io/docs/concepts/storage/persistent-volumes/). The
   resource in [this](create-free5gc-pv.yml) corresponds to the PV configured
   for the core (assuming that the host that the PV is stored in is called
   `kubernetes-master`).

The following table lists the versions for the various software components that need to be installed:

| Component | Version |
| --------- | ------- |
| Helm      | v3.3.4 |
| Multus-CNI | ? |
| Flannel-CNI | v0.8.6 |
| kubectl-client | v1.22.1 |
| kubectl-server | v1.22.1 |

Once the Kluster is configured you can deploy the containerized core:
```shell
deployment_name="free5gc" # Can be any name
path_to_helm_chart="/some/path/to/the/chart/free5gc-multi-slice.tgz" # Can also install from a chart repo if the chart is hosted somewhere.
helm install $deployment_name $path_to_helm_chart
```

## Deploying the UERANSIM helm chart.
Assuming that the Free5GC helm chart deployed successfully, deploying the UERANSIM helm chart should be more straightforward. 
```shell
deployment_name="ueransim" # Can be any name
path_to_helm_chart="/some/path/to/the/chart/ueransim.tgz" # Can also install from a chart repo if the chart is hosted somewhere.
helm install $deployment_name $path_to_helm_chart --set createNetworks=false
```
The `createNetworks=false` flags ensures that the networking related Kubernetes
resources are not recreated by the UERANSIM chart. They are created when the
Free5GC chart is deployed and shared between the two deployments.
