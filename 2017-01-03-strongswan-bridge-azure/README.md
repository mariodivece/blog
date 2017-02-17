# Multiple Sophos (IKEv1) to Azure IPsec Tunnels
A guide on how to setup multiple site-to-site IPsec connections between Sophos UTMs and Windows Azure

*:star: Please star this guide if you find it useful!*

[![Analytics](https://ga-beacon.appspot.com/UA-8535255-2/unosquare/strongswan-guide/)](https://github.com/igrigorik/ga-beacon)
 
## Introduction
Windows Azure is a great PaaS provider from Microsoft that allows companies to connect their local resources to their Azure infrastructure. This guide assumes you are familiar with site-to-site VPNs and that you need to connect multiple IKEv1 Policy Route SAs to Windows Azure. You need to be very patient because these things could take up a number of hours of your time. Make sure you can focus on these procedures for about 4 hours.

## The Problem
Assume you have created an Azure Virtual Network with Address Space `10.55.0.0/16` called `vnet`. You then create a Subnet `10.55.0.0/20` called `vnet-lan`. This subnet is where you will be connecting your VMs for their private network addresses. But then you need to connect those VMs to your branch offices. Windows Azure conveniently provides something called a Virtual Network Gateway which requires a Gateway Subnet in your `vnet`. So you went ahead and created your Gateway Subnet `vent-gw` within your `vnet` with address space `10.55.255.0/24`. You then created a Local Network Gateway to your first site `local-site-01` with a public IP address `S01.0.0.0` and an address space `172.16.16.0/22` which is your office's LAN subnet. All was well at this point. Then, you created a Virtual Network Gateway `azure-gw-01` and selected Gateway Type: `VPN`, and when making the choice between VPN Types, `Route-based` or `Policy-based` you found yourself researching and trying to understand what those choices meant. In short: Route-based is for routers that support Dynamic routing (IKEv2) and Policy-based just means static routing (IKEv1). Windows Azure only supports a single connection to our `vnet` with Policy-based routing (we need to connect the rest of the branch offices) but at the same time, Sophos UTMs do not support Dynamic routing! What do we do now? We read throught the rest of this guide.

## The Objective
Below is a digram of what we want to accomplish. We basically want to tunnel LAN traffic back and forth between Azure VMs conneted to the `vnet` and our UTM sites. We also want Azure VMs to use the standard default gateway to access the internet. This is called **split-tunnel routing**. In order to acocmplish our objective:
- We will **DELETE** the following items from your Azure setup (we don't need them):
 - Virtual Network Gateway
 - Local Network Gateway
 - GatewaySubnet Subnet in your `vnet`
- We will need to setup an Azure Route Table in our `vnet-lan`
- We will create a Router/IPsec gateway VM in Ubuntu Linux 16 LTS that will act as the brigde between Azure VMs and all other local sites.
- We will setup the barnch office sites to connect to our Azure Router VM
<img src="https://raw.githubusercontent.com/mariodivece/strongswan-bridge-guide/master/images/diagram-objective.png"></img>
In the diagram above, carefully note that our Azure Router VM is not connected to the internet **DIRECTLY**. It uses a Default Gateway that Azure **automatically** sets up for every subnet. In our case `vnet-lan`. Referring to the diagram:
- Azure `vnet` Address Space: 10.55.0.0/16 (somewhat irrelevant)
- Azure `vnet-lan` Subnet: 10.55.0.0/20 (within address space above)
- Azure `vnet-lan` Default Gateway: Local IP: 10.55.0.1 (automatically assigned)
- Azure `vnet-lan` Default Gateway: Public IP: A.Z.U.R (finctional, replace with your own)
- Local Site 1 Default Gateway Public IP: S.I.T.1 (fictional, replace with your own)
- Local Site 1 Default Gateway Private IP: 172.16.16.1
- Local Site 1 Subnet: 172.16.16.0/22
- Azure Router VM Local IP: 10.55.1.1 (Make sure it has a static IP address assignment)
 
## The Procedure - On Windows Azure
1. Start by ensuring you have a `vnet` Virtual Network and and a `vent-lan` Subnet associated with it, according to the sample parameters above. The image below shows my `vnet` and `vnet-lan` configurations. <img src="https://raw.githubusercontent.com/mariodivece/strongswan-bridge-guide/master/images/vnet-config.png"></img> <img src="https://raw.githubusercontent.com/mariodivece/strongswan-bridge-guide/master/images/vnet-lan-config.png"></img>
2. Go ahead and create a Route Table `vnet-routes`. It will allow IP packet forwarding from Azure VMs to our Azure Router VM **exclusively** for our branch office sites. The Next Hop setting of every entry must be set to `Virtual Appliance` and the IP address of our Azure Router VM (in this example `10.55.1.1`). Associate the new route table to your `vnet-lan`. Below is a screenshot of my configuration. <img src="https://raw.githubusercontent.com/mariodivece/strongswan-bridge-guide/master/images/vnet-routes.png"></img> <img src="https://raw.githubusercontent.com/mariodivece/strongswan-bridge-guide/master/images/vnet-routes-config.png"></img>
3. Create a new Azure VM: This will be our Azure Router VM which I will refer to as `vm-router`. I have selected Ubuntu Server 16 LTS with 1 core and 3.5 GB of memory. A total of 4 resources were created when I created this VM: A network interface, a netork security group, a public IP address, and the VM itself. It also created the VHD blob (virtual hard disk) for my VM in the storage account I selected. Make sure the newtork interface has a static private IP address `router-private-ip` assignment of `10.55.1.1`. The public IP address of this interface will be set to Dynamic. Change it to Static. Also, keep a note on this Public IP Adddress (which I will call `router-public-ip`), because we will connect via SSH to this machine to configure it as a router and an IPsec bridge and we will also use it to configure the bridge. In our next step. I am attaching some screenshots for reference purposes. <img src="https://raw.githubusercontent.com/mariodivece/strongswan-bridge-guide/master/images/vm-router-vm.png"></img> <img src="https://raw.githubusercontent.com/mariodivece/strongswan-bridge-guide/master/images/vm-router-config.png"></img>
4. Turning the Ubuntu Azure VM into a router and a bridge takes very little effort but it's actually where the magic happens.
 - Use PuTTY or any other SSH client to connect to the public IP address of `vm-router`. Enter the username and password you set for the VM when you created it.
 - Enter root mode by typing in: `sudo sudo su`
 - Enable IP packet forwarding. Type: `nano /etc/sysctl.conf` and locate and **uncomment** (i.e. remove the hashes) the following lines:
 ```bash
net.ipv4.ip_forward=1
net.ipv6.conf.all.forwarding=1
```
 - Hit Ctrl+X and then Y when prompted to save to commit the changes.
 - Make `sysctl` changes permanent by typing in: `sysctl -p`
 - Update, upgrade and install existing packages and include `strongswan`
 ```bash
apt-get update
apt-get upgrade
apt-get install strongswan
 ```
 - We are going to be using PSK (Pre-Shared Key) authentication for our IPsec bridge. So, create a long password. Let's call it `router-psk` from now on. Now go ahead and edit the file that will contain our `router-psk`. Type in: `nano /etc/ipsec.secrets`. Delete everything in there and ensure your file looks like the following (with the corresponding replacements):
 ```bash
 # replace router-public-ip with your Router VM public IP address
 # also replace your router-psk with your long password. It should be enclosed in double quotes.
 router-public-ip %any : PSK "router-psk"
 ```
- Hit Ctrl+X and then Y when prompted to save to commit the changes.
- Now let's confgure our StrongSwan bridge. Go ahead and type in: `nano /etc/ipsec.conf`, delete eveything in there and make the replacements as shown in the example below. I am setting up 2 branch office site connections below, but you can set up 1 or as many as you want:
 ```bash
# ipsec.conf - strongSwan IPsec configuration file

config setup

# Connections
conn %default
        type="tunnel"
        authby="psk"
        keyingtries=%forever
        auto="start"
        dpdaction="restart"
        closeaction="restart"
        compress="no"
        keyexchange="ikev1"
        ike="aes256-md5-modp1536"
        ikelifetime="7800"
        esp="aes128-md5"
        keylife="3600"
        rekeymargin="540"
        leftid="router-public-ip"
        leftsubnet="10.55.0.0/20"
        leftfirewall="yes"

conn router_site-01
        right="site-01-public-ip"
        rightid="site-01-public-ip"
        rightsubnet="172.16.16.0/22"

conn router_site-02
        right="site-02-public-ip"
        rightid="site-02-public-ip"
        rightsubnet="10.4.0.0/20"

 ```
- Again, hit Ctrl+X and then Y when prompted to save to commit the changes.
- Now, restart the IPsec service `ipsec restart`. To see the status of the IPsec tunnels, enter `ipsec statusall`. And to see detailed logs of the connections try: `tail /var/log/syslog`.

## The Procedure - On the Sophos UTM

There really isn't anything complicated here. It's the typical Site-to-Site VPN setup. Create A Gateway matching our `vm-router`'s `router-public-ip`, and create a connection with the `AES-128 (ACC)` policy. I am attaching some screenshots to give you an idea.

<img src="https://raw.githubusercontent.com/mariodivece/strongswan-bridge-guide/master/images/sophos-gateway.png"></img>

<img src="https://raw.githubusercontent.com/mariodivece/strongswan-bridge-guide/master/images/sophos-policy.png"></img>

<img src="https://raw.githubusercontent.com/mariodivece/strongswan-bridge-guide/master/images/sophos-connection.png"></img>

## Conclusion

If you want to test connectivity, simply `ping router-private-ip` from any of the baranch office's machine. You should get a response. That's it! Please star this guide if you find it useful or leave a comment if you'd like to improve it.
