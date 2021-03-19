# Setup a secure Ethereum node using the Syntropy Stack

This integration can help exchanges, on-chain data analysts, node runners, etc. setup a secure, stable and monitored Ethereum node.
The Terraform script will automatically orchestrate the needed monitoring and node infrastructure. The Ansible playbook configure the Ethereum node and monitoring. To ensure security and stability all of the connections between the Ethereum node and the monitoring solution are made through a private Syntropy network.

## Topology

![](assets/topology.png)

## Benefits

The integration provides a few tangible benefits to different stakeholders:
* Exchanges can now manage their multi-cloud node infrastructure easily without having to worry about network connections and security between the instances.
* Less technical node-runners can easily setup a secure and observable Ethereum node
* On-chain Ethereum data analysts can manage Ethereum node clusters on multiple clouds with additional observability

## Requirements

There are some prerequisites to use this example:

* An active Google Cloud Platform account with billing enabled
* An active Linode Cloud account
* Python >= 3.6
* Terraform and Ansible >= 2.10 installed on your local machine
* A Linux machine to run the Ansible playbook

## Installation

For this example, you will need the Syntropy Stack ansible collection
and its dependencies. To install them run:

```
ansible-galaxy collection install git@github.com:SyntropyNet/syntropy-ansible-collection.git
```

To install the collection's dependencies, navigate into the collection directory
and run:
```
pip3 install -U -r requirements.txt
```

## Variables

In order for Terraform and Ansible to be able to set up everything automatically,
you will need to input a few variables in `infra/terraform.tfvars` and 
`ansible/vars/main.yml`. The examples for these can be found in their respective
`.example` files.

Useful links for generating the variables:

1. [How to generate Linode Personal Access Token](https://www.linode.com/docs/guides/getting-started-with-the-linode-api/)
2. [How to generate Google Cloud Platform service key](https://cloud.google.com/iam/docs/creating-managing-service-account-keys)
3. [How to generate a Syntropy Agent Token](https://docs.syntropystack.com/docs/get-your-agent-token)

## Provisioning infrastructure

After you have filled in your Terraform and Ansible variables, you can start
creating your virtual machines. This is a simple step and only requires two
commands (in the `infra` directory):

```
terraform init
terraform apply
```

## Deploying the Ethereum node and monitoring services using Ansible

After the virtual machines are done setting up, you can start provisioning
the Ethereum node and monitoring services (Grafana, Prometheus, eth-netstats).
In order to do this, only one command has to be run:

```
ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -i inventory.yml main.yml
```

This can take a while, since a lot is done in this playbook (takes about 15-20 min, so take your eyes off the screen).


## Checkout the network setup on Syntropy Platform

If configured correctly, the network layout should be simple and look like this:

![](assets/syntropy_network.png)

## Visiting the monitoring site

You can visit the Grafana instance with the link `http://10.44.1.3:3000` and entering
the credentials you entered in the `vars/main.yml` file.

After logging in, you should be able to visit the two dashboards (Ethereum node and machine info):
![](assets/eth_node_grafana.png)
![](assets/node_grafana.png)

## Checking out the Ethereum net-stats

This integration includes an instance of Ethereum Netstats which provides
a nice user experience for seeing the status of your Ethereum nodes.
You can access eth-netstats at `http://10.44.1.5:3000` and it should look
like this:

![](assets/eth_netstats.png)

## Expanding the setup

If needed, you can add additional Geth command line flags in the `vars/main.yml`. In case a different cloud provider is needed,
you can either set them up yourself and put the IP addresses of the machines in the `ansible/inventory.yml` file or
modify the Terraform script to automatically provision instances in the cloud provider of your choice.