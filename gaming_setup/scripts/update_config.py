# script to update all configuration files (.yaml) when VM IPs change.
from ruamel import yaml

yml = yaml.YAML()
yml.indent(mapping=2, sequence=4, offset=2)

CORE_IP = '192.168.1.CORE'
UPF_IP = '192.168.1.UPF'
gNB_IP = '192.168.1.gNB'
UE_IP = '192.168.1.UE'

with open('../config/amfcfg.yaml', 'r') as amfcfg:
    data = yml.load(amfcfg)
    print("Reading amfcfg.yaml success.")

    # update values
    data['configuration']['ngapIpList'][0] = CORE_IP

    # # check updates
    # print(yaml.dump(data, Dumper=yaml.RoundTripDumper))

with open('../config/amfcfg.yaml', 'w') as amfcfg:
    yml.dump(data, amfcfg)
    print("Updated amfcfg.")
