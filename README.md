# Deprecation Notice!
This repository is no longer actively maintained. We have moved to Kubernetes container based deployment, details of which can be found at [5gc-manifests](https://github.com/niloysh/5gc-manifests).

# 5G Core Deployments

This repository describes the setup and configuration of the 5G core deployment of the 5G testbed at the University of Waterloo as part of the [5G Network Slicing](https://wat5gslicing.github.io/) project.

This setup leverages various open-source projects such as
the [free5gc](https://github.com/free5gc/free5gc) and [UERANSIM](https://github.com/aligungr/UERANSIM).

## Table of Contents
- [Basic Slicing Deployments](#basic-slicing-deployments)
- [Key Performance Indicators](#key-performance-indicators)
- [Cloud Gaming Use-case](#cloud-gaming-use-case)

## Basic Slicing Deployments
The `basic-slicing-deployments` directory contains the following network slice deployment scenarios:
- Single network slice with a single PDU session (1 UPF)
- Single network slice with two PDU sessions (2 UPFs)
- Two network slices with an UE connnected to each slice
- Two network slices with UE connected to both slices
- Two network slices with two gNodeBs

## Key Performance Indicators
The `key-performance-indicators` directory contains notes on calculating some of the network slice KPIs such as network slice throughput. Slice KPI monitoring involves extracting and correlating the performance metrics from the 5G core functions such as SMF and UPF.

## Cloud Gaming Use-case
The `cloud-gaming-deployments` directory contains configuration files and scripts used for deploying a cloud gaming use-case. This involves streaming a video game from a host PC to an UE through the 5G core deployment. This builds upon the `basic-slice-deployments`. The purpose of this deployment is to showcase the benefits of network slicing by having a network slice dedicated to the gaming stream.


