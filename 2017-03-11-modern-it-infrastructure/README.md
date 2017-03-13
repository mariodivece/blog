# Modern IT Infrastructure: A Practical Guide

## Introduction

Hello! Let me start by telling you about myself. I have been developing software for the better part of my life. Almost 20 years now. 
I got my Electrical Engineering degree from the University of Alberta. I am a proud Mexican and I own a small software consultancy services firm called Unosquare.

There are two reasons why I wanted to write this guide: First, I see that most software engineers, developers and even some IT people 
simply don't have enough knowledge or the experience required to become productive fast enough in our quickly evolving industry. My hope is that I cover enough material to make you, the reader, feel plenty confident at solving any problem you are presented with. Second, in addition to feeling the need of giving back a little by sharing my knowledge, I also felt that I wanted to keep notes and explanations on my own conclusions. So this guide will serve as a set of notes to myself too.

## Chapter 1: Networking Basics

In this chapter we will cover IPv4 and IPv6 address notations, subnets, address classes, unicast, broadcast and multicast communications. We will examine the differences between TCP and UDP. We will look at common types of switching technologies available and how these are useful. We will also cover useful information regarding Wireless Networks and how to set them up properly.

### The Internet Protocol Suite

For most of you, this section will be rather trivial. I still recommend you read through it. The *Internet Protocol* or *IP* is a generic, standard _network_ protocol specification that provides the basis for additional _transport_ protocols on top of it such as *TCP* or *Transmission Control Protocol* and *UDP* or *User Datagram Protocol*. The *IP* protocol operates on Layer 3, the Network Layer of the OSI model. We are not going to cover the *OSI* model (Open Systems Interconnect) in detail because it is material that is not going to be referenced much throughout this guide. I do recommend you review it [ISO 749801](https://www.ecma-international.org/activities/Communications/TG11/s020269e.pdf).

What is important, is that you understand that *IP* defines basic standards of _network_ communications in its [RFC-791](https://tools.ietf.org/html/rfc791). People commonly and interchangebly refer to the *IP* protocol as **TCP/IP** because the original protocol in the *IP* suite was *TCP* but *IP* and *TCP* are **different** things, so please forget *TCP* for now because *TCP* is a _transport protocol_ that is part of the *suite* of protcols that build on top of *IP*. Let me repeat that: **Transport** protocols such as *TCP* and *UDP* are part of a *suite* of protocols that build on **top** of the *IP* sspecification. *TCP* and *UDP* are referred to as **Transport Layer** protocols. The term **TCP/IP** is in use today for convention reasons. But TCP does not imply IP or viceversa. You can take a look at [all the transport level protocols IP supports here](https://en.wikipedia.org/wiki/List_of_IP_protocol_numbers).

So, let's cut to the chase. What standard aspects of networking are defined by the *Internet Protocol*, or *IP*? Many, in fact. But you just need to deeply understand a few of them. Keep in mid that the OSI model defines 7 layers for network communication. The IP specification in constrast, defines only 4 of them with slightly different and somewhat overlapping concepts. Here is a table with a rough comparison. See [RFC-1122](https://tools.ietf.org/html/rfc1122) for additional reference.

<table>
<thead>
  <th>Layer</th>
  <th>OSI Model</th>
  <th>IP Equivalence</th>
</thead>
<tbody>
	<tr>
      <td>7</td>
      <td>Application</td>
      <td rowspan="3">Application: Higher level protocols such as FTP or HTTP</td>
    </tr>
	<tr>
      <td>6</td>
      <td>Presentation</td>
    </tr>
	<tr>
      <td>5</td>
      <td>Session</td>
    </tr>
	<tr>
      <td>4</td>
      <td>Transport</td>
      <td>Transport: IP Suite protocol such as TCP or UDP</td>
    </tr>
	<tr>
      <td>3</td>
      <td>Network</td>
      <td>Internet and Link layers. Packets within Frames</td>
    </tr>
	<tr>
      <td>2</td>
      <td>Data Link</td>
      <td>Frames (not part of IP)</td>
    </tr>
	<tr>
      <td>1</td>
      <td>Physical</td>
      <td>Bits (not part of IP)</td>
    </tr>
</tbody>
</table>

The IP layer model is actually older IP was introduced officially in 1982 (the year I was born!) and the OSI Model was published in 1984. But enough about layers. Let's take a look at the fundamental elements that is practical to understand.

- **Addresses**: It defines a way to represent network addresses, or more properly called, IP Addresses. Addresses are unique in a network and identify hosts. Hosts can have 1 or more IP addresses too.
- **Packets**: It defines a transmission data structure with 2 parts. The first is called the *IP Header* whcih contains information about the source, destination, and a number of other details, and the second is the *IP Data* which contains the messages (or payload) between senders and receivers. Packets themselves are part of the Network layer and are contained within Layer 2 (Link Layer of the OSI model) structures called *frames*. [More about the structure of IP packets is available here.](https://tools.ietf.org/html/rfc791#section-3.1) ``` TODO: Picture here```
- **Gateways**: Gateways or more porperly called **Routers**, are computers that map and know how to reach a number of addresses in the Internet or some other network on behalf of another host. A router allows other computers to send and receive packets to and from destinations thay can't really reach on their own. Gateways typically reach their final destinations wither directly or by using other gateways and that is how the entire Internet connects together: like a web of hosts behind routers connect to each other. Interestingly enough, a network *hop* occurs when a packet passes through one of these routers. Please visit [this site](http://www.vox.com/a/internet-maps) containing charts that will help you visualize how this works. Just for fun, try to use the ```tracert``` command to see how many hops (or routers) your computer needs to go through in order to reach google.com. Try:

``` 
> tracert google.com 
```

In contrast, *IP* does **not** define the following:
 - The order in which packets are sent and received.
 - Receiving or sending acknoledgements that packets were received at the intended destination.
 - Determining if the packets were received without corruption by the destination computer.
 - The format of the data contained in the packets.
 - **Ports**: Surprisingly enough, IP does *not* define the notion of ports. We use addresses to identify hosts, and we use ports to identify applications within hosts. This allows different programs running in the same host to communicate with other hosts simultaneously. Ports are a notion that belongs to the realm of Transport level protocols (such as *TCP* and *UDP*).
 
In other words, *IP* defines **how to create connections** between hosts, simplifying potentially complex network topology by  *hiding* it or *abstracting* the details away. You should now think about how the OSI model is flexible enough and how IP is an  **independent** protocol in networks. In the future we could have a different protocol replace IP (in fact its is happening with *IPv6*, more on that later) and still not be required to change the way Transport-level protocols or applications work.

#### IPv4 Addresses

We mentioned earlier that the *IP* suite provides us with a standard for defining IP Addresses. At the time of this writing, there are 2 versions of *IP* in use worldwide. *IPv4* used by the vast majority of the Internet and *IPv6* used by only a small protion of the Internet. In IPv4, addresses are represented by a 32-bit number. This is roughly 4.3 billion unique addresses. In 2012 different sources estimate that there were between 8 and 10 billion devices connected to the Internet. So how is it possible that all those devices could be identified by using a unique IP address if the maximum amount of unique IP addresses is roughly half that number? We will explore what *subnetting* is shortly.

First, let's look into how to represent IP Addresses. As you most likely already know, we don't represent IP Addresses as some integer such as ```3488329``` and ```-347289985```. We respresent IP Addresses in 4 *octects*, separated by a dot with each octet containing a decimal value from ```0``` to ```255```. It should be obvious that it is called an octet becuase it is 8 bits, and it should be also obvious that the range of an octet contains ```256``` possible values, namely ```0``` to ```255```. So examples of IP Addresses are ```192.168.2.34```, ```8.8.8.8```, ```10.0.1.10```. There are special IP Addresses reserved for certain purposes.
 - Network Address: An IP Address representing the base, zeroth address to be used in a group of computers. This address must not be assigned to any computer on any given group (or *subnet* -- more on that later). It is used for Network notation purposes only. For example ```192.168.4.0``` represents a network address. Note that it does **not** tell us how many addresses the particular network contains.
 - Broadcast Address: The last IP Address in a network subnet. It is in certain ways, the opposite of a Network Address. An example of a Broadcast Address is ```192.168.4.255```. No single host should have this address, but ALL hosts can send packets to this address and ALL hosts can receive packets from this address. We will dig deeper into Broadcast communication later.
 - Loopback Address: The legandary ```127.0.0.1``` also known as ```localhost``` is an IP address that a host gives itself for testing purposes only. Please note that IP addresses ranging from ```127.0.0.0``` to ```127.255.255.255``` cannot be reached from outside the host so don't use them!
 - "Private" IP Addresses: These address ranges are addresses for hosts that are not directly connected to the Internet. This does not mean that they can't reach the Internet. It just means that they need a Router to do that job for them. The NRO (Number Resource Organization) which is the global organization responsible for tracking public IP address assignments will not give these private IP addresses out. These ranges are: ```10.0.0.0``` to ```10.255.255.255```, ```172.16.0.0``` to ```172.31.255.255```, and ```192.168.0.0``` to ```192.168.255.255```.
 - Multicast and Experimental IP Addresses: These IP addresses are reserved for Multicast communication (more on that later) and experimental portocols. They cannot be used as public IP Addresses. The range is ```224.0.0.0``` to ```239.255.255.255```. 
 - Link-Local IP Addresses: This range of IP Addresses is allocated for communication between hosts on a single link. Whoa! What does that mean exactly? When a network interface in the host is unable to determine what IP address to use because there in no available DHCP server or because it has not been assigned an IP Address manually, it will automatically try to configure itself in order to communicate with other automatically-configured hosts in the network. When you see these addresses though, it typically means there's something wrong with your network.
 - Other special IP Addresses: There are other, less relevant IP Address ranges. If you wish to consult them, please take a look at [RFC-3330](https://tools.ietf.org/html/rfc3330). 

Recall we stated Gateways or Routers are computers that understand how to make requests and receive responses from and to other machines on behalf of the clients behind them. So we have a number of computers behind a Router that communicate to the rest of the Internet by asking the router to forward packets to a remote destination. Local LAN addresses are 

But what happens when a client wants to communicate directly with a different client? Turns o

A Router will typically have at least 2 network interfaces. One connecting to the public Internet and one more connected to the switch where the *LAN* or *Local Area Network*. But how do you differentiate between the 2?

Subnet Masks:

#### UDP: Fire-and-Forget

#### TCP: Reliable Communication


#### Unicast, Broadcast and Multicast


#### Knowledge Check

 1. What are the differences between the data structures used by the Link Layer and the Network Layer
 2. Which OSI model layer does the *IP* specification operate on
 3. What are the means the *IP* specification uses to ensure packets are delivered without corruption to the destination host?
 4. If a new networking specification came out in a few years, replacing *IPv4* does it mean that TCP applications would need to be rewritten? Why or Why not?
 5. 

## Chapter 2: Firewalls and Routing

In this chapter we will cover the notion of routing. It includes comcepts such as Network Address Translation, Gateways, Firewalls, and other means of establishing communications between computer systems.

## Chapter 3: DNS, HTTP and HTTPS

Here we will learn how DNS works and why it is important when deploying web applications. We will also explore the specifics of the HTTP 
protocol and how asymmetric cryptography makes HTTPS possible and why it is important.

## Chapter 4: Hyper-V

We start getting more sophisticated in this chapter. We take a look at Virtual Machines, Virtual Hard Disks, Virtual Switches, and Virtual Network Adapters.

## Chapter 5: Windows Azure

We will cover the fundamentals of cloud computing starting by understanding the difference between IaaS, PaaS and SaaS. We will also learn how to successfully deploy various types of applications.

## Chapter 6: Network Security

We will understand the usefulness of a Web Application Firewall and how to perform penetration testing on web applications with well-known tools. We will also explore common attacks such as DDoS, SQLi, XSS, Dictionary Password Guessing and Bruteforce Password Gessing, and how to stop them. We will learn how to setup firewall rules and ploicies.

## Chapter 7: Continuous Integration

Although this topic leans more towards developers, it is important that a network engineer understands and is also capable of setting up
simple CI and CD environments.

## Chapter 8: Identity Management

In this chapter we will cover basic aspects of Active Directory management, LDAP connections, Azure Directory integration, etc.

## Chapter 9: Office 365

At the time of this writing, Office 365 is in popular demand. We will take a look at cloud-only deployments, hybrid identity management,
subscription and plan types, PSTN capabilities, and the basics of Exchange Online management.

## Chapter 10: The Private Branch Exchange

We will cover the basics of getting aphone system correctly configured, the implications of using different audo codecs, Trunks, FXO
Gateways, VoIP phones and their types, and QoS.

## Chapter 11: Other Systems

I have left this chapter to cover applications that are typically required in an enterprise environment. These include FTP servers, 
SFTP servers, Version Control systems, E-Learning systems, and others. 
