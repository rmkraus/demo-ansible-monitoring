# Demo Preparation

Before you are able to create this demo, you must have an AWS account with a working Route 53 domain setup. The demo scripts will handle the rest.

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
  9. Go to `Configuration -> Templates -> Template DB MySQL -> Items` and update the `MySQL status` item to have an update interval of 14s.