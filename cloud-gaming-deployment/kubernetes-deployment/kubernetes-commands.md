# Kubernetes commands

## See deployed helm charts
`helm list`

## Get pods status
`kubectl get pods -o wide`

## See container logs
`kubectl logs --follow free5gc-upf-5ffbc9d5cc-dtsvh upf`


## Open shell on container
`kubectl -n <namespace> exec -it <ue-pod-name> -- bash`


## Run gnb from gnb container
`./nr-gnb -c ../config/gnb-config.yaml`

