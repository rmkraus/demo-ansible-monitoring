# Demo Preparation

## Prerequisites

Before you are able to create this demo:
  - You must have an AWS account with a working Route 53 domain setup.
  - Your AWS account must have sufficient rights to create gateways, routes, subnets, network acls, key pairs, security groups, and ec2 instances.
  - You must also have a valid Ansible Tower license.

The demo scripts will handle the rest.

## Administration Scripts

The following scripts are included in the `/app` directory in the container. They should be used for administering the demo environment.

  - `chaos.yml` - Ansible Playbook to cause controlled chaos.
  - `connect.sh` - Bash script that will open an SSH session to the specified host. Usage: `./connect.sh [tower|zabbix|app-0|app-1|app-2]`
  - `deploy.yml` - Ansible Playbook to deploy and configure the demo environment.
  - `destroy.yml` - Ansible Playbook to cleanly remove the demo environment from AWS.
  - `shutdown.yml` - Ansible Playbook to shutdown all the hosts in the environment. This will not remove them from AWS.
  - `startup.yml` - Ansible Playbook to startup all the hosts in the environment.

## Procedure

Use the following steps to create and prepare the demo environment.

1. Pull the latest container image, and create a local directory that will be used for storing your demo's configuration and setup data.

```bash
docker pull rmkraus/demo-ansible-monitoring:latest
mkdir demo-data
```

2. Launch the container interactively to get the demo control prompt.

```bash
docker run \
    --mount type=bind,src=/full/path/to/demo-data,dst=/data \
    --name demo \
    -it rmkraus/demo-ansible-monitoring:latest

# after exit, the container can be restarted with
docker start -i demo
```

3. The container will populate the data directory with a skeleton configuration and initialize the internal Terraform database. Update the `/date/config.sh` and `/data/tower-license.txt` files with the data for your demo.

4. Create the demo environment using the deploy playbook. This will take some time as all the infrastructure is created.

```bash
./deploy.yml
```

5. Log into Zabbix to perform initial configuration.
  1. Log in the the credentials Admin/zabbix
  2. Go to `Administration -> Users` and set Admin's password to the same password used for Ansible Tower.
  3. Go to `Administration -> User groups` and disable the Guests group
  4. Go to `Configuration -> Templates -> Template OS Linux -> Triggers` and disable the `Lack of free swap space` check.
  5. Go to `Configuration -> Actions -> Event source: Auto registration` and create a new action.
  ```
    Under Action:
        Name: auto

    Under Operations:
        Create a new Operations:
          - Operation Type: Add Host
          - Operation Type: Link to Template
            Templates: Template OS Linux
          - Operation Type: Enable Host
  ```
  6. Wait a few minutes and all the hosts should start to appear under `Configuration -> Hosts`.
  7. Under `Configuration -> Hosts`; select app-0, app-1, and app-2; and click `Mass update`. In the `Templates` tab, check `Link templates`, add `Template DB MySQL` to the text box, and click `Update`.
  8. Go to `Configuration -> Templates -> Template DB MySQL -> Triggers` and change the `MySQL is down` trigger expression to `{Template DB MySQL:mysql.ping.last(0)}=0 or {Template DB MySQL:mysql.ping.nodata(20)}=1`.
  9. Also in `Configuration -> Templates -> Template DB MySQL -> Triggers`, make the `MySQL status` trigger dependent on the `Template OS Linux | Zabbix agent on Template OS Linux is unreachable for 5 minutes` trigger.
  10. Go to `Configuration -> Templates -> Template DB MySQL -> Items` and update the `MySQL status` item to have an update interval of 14s.
