# SMF selection
This file describes the SMF selection procedure in free5gc `v3.0.5`.

SMF selection criteria are given in 3GPP TS 23.501 Section 6.3.2.

The available SMFs are filtered by S-NSSAI only. The relevant code is [https://github.com/free5gc/nrf/blob/386a6bdda516b64da43dd1711e3893528deaf0b9/producer/nf_discovery.go#L287](https://github.com/free5gc/nrf/blob/386a6bdda516b64da43dd1711e3893528deaf0b9/producer/nf_discovery.go#L287). This can be verified by running the following query in mongodb. 

  ```
  db.NfProfile.find({
      $and: [
          {
              "nfType": "SMF"
          },
          {
              "smfInfo.sNssaiSmfInfoList": { $elemMatch: {
                      "sNssai.sd": "112233"
                  }
              }
          },
      ],
  },
  {
      "ipv4Addresses": 1
  })
  ```

The parameters used for filtering SMF are S-NSSAI and DNN. This can be seen here.
  ```go
  {ServiceNames:{isSet:true value:[nsmf-pdusession]} RequesterNfInstanceFqdn:{isSet:false value:} TargetPlmnList:{isSet:true value:[{"mcc":"208","mnc":"93"}]} RequesterPlmnList:{isSet:false value:<nil>} TargetNfInstanceId:{isSet:false value:<nil>} TargetNfFqdn:{isSet:false value:} HnrfUri:{isSet:false value:} Snssais:{isSet:true value:[{"sst":1,"sd":"112233"}]} Dnn:{isSet:true value:network2} NsiList:{isSet:false value:<nil>} SmfServingArea:{isSet:false value:} Tai:{isSet:false value:<nil>} AmfRegionId:{isSet:false value:} AmfSetId:{isSet:false value:} Guami:{isSet:false value:<nil>} Supi:{isSet:false value:} UeIpv4Address:{isSet:false value:} IpDomain:{isSet:false value:} UeIpv6Prefix:{isSet:false value:<nil>} PgwInd:{isSet:false value:false} Pgw:{isSet:false value:} Gpsi:{isSet:false value:} ExternalGroupIdentity:{isSet:false value:} DataSet:{isSet:false value:<nil>} RoutingIndicator:{isSet:false value:} GroupIdList:{isSet:false value:<nil>} DnaiList:{isSet:false value:<nil>} SupportedFeatures:{isSet:false value:} UpfIwkEpsInd:{isSet:false value:false} ChfSupportedPlmn:{isSet:false value:<nil>} PreferredLocality:{isSet:false value:} AccessType:{isSet:false value:<nil>} IfNoneMatch:{isSet:false value:}}
  ```

If more than one SMF is available for a given S-NSSAI, the first instance is chosen. The current implementation does not support any other selection criteria. The relevant code is [https://github.com/free5gc/amf/blob/6e0202ce2de6366856b005e5a5722745e420008f/consumer/sm_context.go#L100](https://github.com/free5gc/amf/blob/6e0202ce2de6366856b005e5a5722745e420008f/consumer/sm_context.go#L100).
  

The following shows the result of filtering SMF by S-NSSAI. Very little information is included which can be used for SMF selection.

  ```go
  {ValidityPeriod:100 NfInstances:[{NfInstanceId:d86056f0-da2d-4901-88b6-18263f1163f4 NfType:SMF NfStatus:REGISTERED HeartBeatTimer:0 PlmnList:0xc0004f6048 SNssais:0xc0004f6078 PerPlmnSnssaiList:[] NsiList:[] Fqdn: InterPlmnFqdn: Ipv4Addresses:[127.0.0.62] Ipv6Addresses:[] AllowedPlmns:<nil> AllowedNfTypes:[] AllowedNfDomains:[] AllowedNssais:<nil> Priority:0 Capacity:0 Load:0 Locality: UdrInfo:<nil> UdmInfo:<nil> AusfInfo:<nil> AmfInfo:<nil> SmfInfo:0xc0000ae680 UpfInfo:<nil> PcfInfo:<nil> BsfInfo:<nil> ChfInfo:<nil> NrfInfo:<nil> CustomInfo:map[] RecoveryTime:<nil> NfServicePersistence:false NfServices:0xc0004f6138 NfProfileChangesSupportInd:false NfProfileChangesInd:false DefaultNotificationSubscriptions:[]}] NrfSupportedFeatures:}
  ```










 

