# Automated Issue Remediation with Zabbix + Ansible

Sources:
  - [Inspiration](https://www.redhat.com/en/blog/adding-remediation-zabbix-using-ansible-tower)
  - [Similar Talk from ZabbixConf 2017](https://www.youtube.com/watch?v=R5T9NidjjDE)
  - [ZabbixConf 2017 Source](https://github.com/red-tux/zabconf2017)

The purpose of this demo is to show Ansible Tower being connected to a third
party service. For this purpose Zabbix is connected to Ansible Tower so that it can automatically start issue remediation. A task is included in the Ansible Playbook that will add data to the Zabbix issue. A similar model could also be used to connect Ansible Tower to other systems, like ServiceNow.

![Architecture Diagram](https://www.redhat.com/cms/managed-files/image1_10.png)

## Documentation
  * [Demo Preparation](docs/prep.md)
  * [Demo Procedure](docs/demo.md)
  * [Development Documentation](docs/dev.md)
