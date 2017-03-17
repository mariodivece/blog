# Modern IT Infrastructure: A Practical Guide

## Introduction

Hello! Let me start by telling you about myself. I have been developing software for the better part of my life: that's almost 20 years. I got my Electrical Engineering degree from the University of Alberta in 2006. I am a proud Mexican and I own a small software consultancy services firm called [Unosquare](https://www.unosquare.com).

There are two reasons why I wanted to write this guide: First, I see that most software engineers and even IT professionals sometimes don't have enough infrastructure and networking knowledge or experience in order to become productive fast enough in our quickly evolving industry. My hope is that I cover most of the relevant material to make you, the reader, feel plenty confident at solving any problem you are presented with. Second, in addition to feeling the need of giving back a little by sharing my knowledge, I also wanted to keep notes and explanations on my own conclusions. So this guide will serve as a set of notes to myself too. I will not be using fancy language because I belive that it would ruin the purpose of these notes. Enjoy the read.

## Chapter 1: Networking Basics

In this chapter we will cover IPv4 and IPv6 address notations, subnets, address classes, CIDR notation, and unicast, broadcast and multicast communications. We will examine the differences between TCP and UDP. We will look at common types of switching technologies available and how these are useful.

### The Internet Protocol (IP)

For some of you, this section might feel repetitive. I still recommend you read through it to clear out any possible confusions. Plus, you might learn new things which is always important. The *Internet Protocol* or *IP* is a generic, standard _networking_ protocol designed to **carry** _transport_ protocol messages (called *Segments*) such as *TCP* and *UDP*. The *IP* protocol operates on Layer 3, the Network Layer of the OSI model. While other protocols such as *TCP* and *UDP* belong to Layer 4 of the OSI model, the Transport layer. We are not going to cover the *OSI* (Open Systems Interconnect) model in detail because it is material that is not going to be referenced much throughout this guide. I do recommend you review it here: [ISO 749801](https://www.ecma-international.org/activities/Communications/TG11/s020269e.pdf). I just packed a lot of information in this paragraph. Do not get discouraged. Continue reading as I explain all these details.

Like we stated before, *IP* defines a standard protocol for _network_ communications. It is completely separate from *TCP* (one of the many transport protocols available), and it is formally specified in [RFC-791](https://tools.ietf.org/html/rfc791). So, why do people (and operating systems) commonly and even interchangeably refer to the *IP* protocol as **TCP/IP** or the **TCP/IP stack**? The answer is not as strightforward as you might like it to be. *IP* and *TCP* are different protocol types, operating at different layers, and they are largely independent. **TCP/IP** is the **combination** of the 2 protocls, one on Layer 3 and one on Layer 4. This combination should more properly be referred to as the *IP suite* instead because TCP is not the only transport protocol that IP can handle. The term **TCP/IP** is in use today because TCP is the original, and main transport protocol used in IP. In short, **IP** is a networking protocol, the **IP Suite** is the combination of the IP networking protocol plus a number of transport protocols, and people refer to this **IP Suite** more commonly as **TCP/IP**. But let's be clear that TCP does not imply IP or viceversa. You can take a look at [all the transport level protocols IP supports here](https://en.wikipedia.org/wiki/List_of_IP_protocol_numbers).

What is the difference between a _network_ protocol like *IP* and a _transport_ protocol like *TCP*? The transmission blocks of a **network** protocol contain data that specify source and destinatation computers in a network **plus** more data **containing** the blocks of a _transport_ protocol. The physical layer carries a stream of **bits**, making up **frames** at the Dat Link layer. *Frames* contain **network packets** at the *network* level,  which in turn contain **transport** level protocol data called *Segments*. Here is a diagram showing the anatomy of *Frames*, *Packets* and *Segments*. These transmission blocks are called *PDU*s or *Protocol Data Units*.

<img src="https://github.com/mariodivece/blog/blob/master/images/it-protocol-transmission-units.png?raw=true"></img>

But the OSI model is not the only layer model out there. There are multiple models that take extremely similar approaches with slightly different names. While the OSI model defines a 7 layer model to connect systems. The IP specification defines only 4 of them. Here is a table with a rough comparison. See [RFC-1122](https://tools.ietf.org/html/rfc1122) for additional reference.

<table>
   <thead>
      <th>Layer</th>
      <th>OSI Model</th>
      <th>IP Model</th>
      <th>Post Office (fictional) Model</th>
   </thead>
   <tbody>
      <tr>
         <td>7</td>
         <td>Application</td>
         <td rowspan="3">Application: Higher level protocols such as FTP or HTTP</td>
         <td rowspan="3">Literary content of a letter</td>
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
         <td>Words and sentences in a letter</td>
      </tr>
      <tr>
         <td>3</td>
         <td>Network</td>
         <td>Internet and Link layers. Packets within Frames</td>
         <td>The sender and recipient of a letter</td>
      </tr>
      <tr>
         <td>2</td>
         <td>Data Link</td>
         <td>Frames (not part of IP)</td>
         <td>The ink and paper used to write the letter</td>
      </tr>
      <tr>
         <td>1</td>
         <td>Physical</td>
         <td>Bits (not part of IP)</td>
         <td>The courier company</td>
      </tr>
   </tbody>
</table>

As you can see from the table above, it would be easy to map back and forth between layer models. So don't get into big debates about which model is correct. The value in all layered models lies within the ability to decouple, to the maximium possible extent the various protocols at the different layers they operate. This allows for new protocols to come to life, and existing protocols to evolve with little to no regard for protocols in layers below them. Check out this super interesting (partial) list of [popular protocols at the different OSI model layers](https://en.wikipedia.org/wiki/List_of_network_protocols_(OSI_model)). Also, note how *IPv4* and *IPv6* are both listed as Layer 3 protocols, the *IP Suite* (or *TCP/IP*) is listed as a Layer 3+4 protocol, and *TCP* and *UDP* are Layer 4 protocols.

Fun Fact: the IP layer model is **older** than the OSI model. IP was introduced officially in 1982 (the year I was born!) and the OSI Model was published in 1984. But enough about layers! Let's take a look at the fundamental elements that are practical and relevant to us. What standard aspects of networking are defined by the *Internet Protocol*, or *IP*? Many, in fact. But you just need to deeply understand a few of them.

- **Addresses**: It defines a way to represent network addresses, or more properly called, IP Addresses. Addresses are unique in a network and identify hosts. Hosts can have 1 or more IP addresses too.
- **Packets**: It defines a transmission data structure with 2 basic parts. The first is called the *IP Header* whcih contains information about the source address, destination address, transport level protocol, and a number of other details. The second is the *IP Data* which contains the transport-level message (or payload) between senders and receivers. As a reminder of one of the previous sections, Packets themselves are part of the Network layer and are contained within Layer 2 (Link Layer of the OSI model) structures called *frames*. [More about the structure of IP packets is available here](https://tools.ietf.org/html/rfc791#section-3.1). We will study *frames* when we get to switching.
- **Gateways**: Gateways or more porperly called **Routers**, are computers that map and know how to reach a number of addresses in the Internet or some other network on behalf of another host. A router allows other computers to send and receive packets to and from destinations thay can't really reach on their own (i.e. hosts outside of their local network). Routers typically reach their final destinations either directly, or by using other routers and that is how the entire Internet connects together: like a web of hosts behind routers connecting to each other. As a side note, a network *hop* occurs when a network packet passes through a router. Please visit [this site](http://www.vox.com/a/internet-maps) containing charts that will help you visualize how this works. And just for fun, try to use the ```tracert``` command to see how many hops (or routers) your computer needs to go through in order to reach google.com. Try:

``` 
> tracert google.com 
```

In contrast, *IP* does **not** define the following:
- The order in which packets are sent and received.
- Receiving or sending acknoledgements that packets were received at the intended destination.
- Determining if the packets were received without corruption by the destination host.
- The format of the data contained in the packets.
- **Ports**: Surprisingly enough, IP does *not* define ports. We use addresses to identify hosts, and we use ports to identify applications within hosts. This allows different programs running in the same host to communicate with other programs running on remote hosts simultaneously. Ports are a notion that belongs to the realm of Transport level protocols (such as *TCP* and *UDP*) and not to IP.
 
In other words, *IP* only defines the *logical* structure of a network, simplifying potentially complex network topologies by  *hiding* or *abstracting* the physical details away. You should now think about the flexibility that layered models like the OSI model provide, and how IP is an  **independent** protocol. In the future we could have a different protocol replace IP (*IPv4*). In fact this is slowly happening today with *IPv6*. But Transport level protocols or Application level protocols remain the same. Swapping the Network level protocol does not affect protocols in either higher or lower level protocols!

#### IPv4 Addresses

We mentioned earlier that the *IP* protocol provides us with a standard for defining IP Addresses. At the time of this writing, there are 2 versions of *IP* in use worldwide. *IPv4* or *IP version 4*, used by the vast majority of the Internet and *IPv6* used by only a small protion of the Internet. In IPv4, addresses are represented by a 32-bit sequence. This is roughly 4.3 billion unique addresses. In 2012 different sources estimate that there were between 8 and 10 billion devices connected to the Internet. So how is it possible that all those devices could be identified by using a unique IP address if the maximum amount of unique IP addresses is approximately half that number? We will explore the wonders of *NAT* and *subnetting* soon enough.

First, let's look into how to represent IP Addresses. As you most likely already know, we don't represent IP Addresses as some integer such as ```3488329``` and ```-347289985```. We respresent IP Addresses in 4 *octects*, separated by a dot with each octet containing a decimal value from ```0``` to ```255```. It should be obvious that it is called an octet becuase it is 8 bits, and it should be also obvious that the range of an octet contains ```256``` possible values, namely ```0``` to ```255```. So examples of IP Addresses are ```192.168.2.34```, ```8.8.8.8```, ```10.0.1.10```. There are special IP Addresses reserved for certain purposes.
- Network Address: An IP Address representing the base, *zeroth* address to be used in a logical grouping of hosts. This address must not be assigned to any computer on any given group (or *subnet*). It is used for Network notation purposes only. For example, if we assume a network has ```256``` total addresses, ```192.168.4.0``` represents a network address. Note that it does **not** tell us how many addresses the particular network contains and that is why I mentioned the assumption.
- Broadcast Address: The last IP Address in a network subnet. It is in certain ways, the opposite of a Network Address. An example of a Broadcast Address is ```192.168.4.255```. No single host should have this address, but ALL hosts can send packets to this address and ALL hosts can receive packets from this address. We will dig deeper into Broadcast communication later.
- The infamous "0.0.0.0" address: I say infamous because ```0.0.0.0``` has different meanings. In the context of routing it refers to the catch-all address typically called a *default route*. Then, in the context of an IP server it means *all* local addresses of this computer. Finally, in the context of an IP client, it means *no address* at all! -- We will see how this is especially useful when it comes to *DHCP*.
- Loopback Address: The legandary ```127.0.0.1``` also known as ```localhost``` is an IP address that a host gives itself for testing purposes only. Please note that IP addresses ranging from ```127.0.0.0``` to ```127.255.255.255``` cannot be reached from outside the host so don't use them!
- "Private" IP Addresses: These address ranges are addresses for hosts that are not directly connected to the Internet. This does not mean that they can't reach the Internet. It just means that they need a Router to do that job for them. The NRO (Number Resource Organization) which is the global organization responsible for tracking public IP address assignments will not give these private IP addresses out. These ranges are: ```10.0.0.0``` to ```10.255.255.255```, ```172.16.0.0``` to ```172.31.255.255```, and ```192.168.0.0``` to ```192.168.255.255```.
- Multicast and Experimental IP Addresses: These IP addresses are reserved for Multicast communication (more on that later) and experimental portocols. They cannot be used as public IP Addresses. The range is ```224.0.0.0``` to ```239.255.255.255```. 
- Link-Local IP Addresses: This range of IP Addresses between ```169.254.0.0``` and ```169.254.255.255``` is allocated for communication between hosts on a single link. Whoa! What does that mean exactly? When a network interface in the host is unable to determine what IP address to use because there in no available DHCP server or because it has not been assigned an IP Address manually, it will automatically try to configure itself in order to communicate with other automatically-configured hosts in the network. When you see these addresses though, it typically means there's something wrong with your network -- yes, like when Windows gives you an IP address in this range and you immediately know you have a problem.
- Other special IP Addresses: There are other, less relevant IP Address ranges. If you wish to consult them, please take a look at [RFC-3330](https://tools.ietf.org/html/rfc3330). 

Given the above list of special IP addresses, we can conclude that a *Network Address* and a *Broadcast Address* together define a group of hosts that can communicate with each other. For example, if the *Network Address* is ```192.168.0.0``` and the *Broadcast Address* is ```192.168.0.255``` that means that we can assign addresses ```192.168.0.1``` all the way to ```192.168.0.254``` to the hosts in such a network. So, in short, you need 2 components to represent a network address space: Network and Broadcast addresses. How do we represent these? We use the Network address plus something called a **subnet mask**. In our example above, we would represent the network address space as: ```192.168.0.0/255.255.255.0```. The subnet mask is that ```255.255.255.0``` IP address. And it is simply a notation to determine what bits of the ```192.168.0.0``` network address identify the network and what parts are assignable to host addresses. If you convert 255 (decimal) to 8-bit binary, you end up with ```11111111```. So if you bitwise AND each of the octects of the network address and the subnet mask, you can determine which part of the address spaced if *constant* and what part is *variable*, or *assignable to hosts*. The ```1``` bits are *fixed*. The ```0``` bits are variable.


Recall we stated Gateways or Routers are computers that understand how to make requests and receive responses from and to other machines on behalf of the clients behind them. So we have a number of host behind a Router that communicate to the rest of the Internet by asking the router to forward packets to a remote destination. But before we explore how hosts behind a router reach destinations on the vast Internet, we will explore how machines communicate locally.

But what happens when a client wants to communicate directly with a different client? Turns o

A Router will typically have at least 2 network interfaces. One connecting to the public Internet and one more connected to the switch where the *LAN* or *Local Area Network*. But how do you differentiate between the 2?

Subnet Masks:

#### UDP: Fire-and-Forget

#### TCP: Reliable Communication


#### Unicast, Broadcast and Multicast


#### Knowledge Check

 1. What is a Protocol Data Unit?
 2. What are the fundamental differences between the PDUs used by the Link Layer and the Network Layer
 3. Which OSI model layer does the *IP* specification operate on
 4. What are the means the *IP* specification uses to ensure packets are delivered without corruption to the destination host?
 5. If a new networking specification came out in a few years, replacing *IPv4* does it mean that TCP applications would need to be rewritten? Why or Why not?
 6. Research: *TCP/IP* and *IP Suite* are equivalent terms. What is yet another sdynonym for these terms?
 7. Exam Question: For the network ```10.59.0.0/16```, answer the following questions 
     - What is the Network Address?
     - What is the Broadcast Address?
     - What is the Netmask in standard IP Address notation?
     - What is the Netmask in binary IP Address notation
     - Provide the total number of IP addresses.
     - Provide the total number of usable host addresses. 
     - Is ```10.59.129.0``` a valid, assignable IP address for a host? 
     - For the above response, explain why or why not?

## Chapter 2: Firewalls, Routing and WiFi

In this chapter we will cover the notion of routing. It includes comcepts such as Network Address Translation, Gateways, Firewalls, and other means of establishing communications between computer systems. We will also cover useful information regarding Wireless Networks and how to set them up properly.

### How Routers talk to each other

We already know that Routing is fundamental to building IP networks. The Internet is build by putting together a large number of IP networks. But how do routers know how to communicate with each other?  How do they know how many *hops* are required to get a packet to a destination? And how do routers know how to handle a response **all the way back** to the host that sent the request? 

### The trip of IP packets

It is very common to assume that if an IP packet is sent via a series of hops -- or Routers --, a response from the receiving host will take exactly the same route back. This is completely incorrect!

## Chapter 3: DHCP, DNS, HTTP and HTTPS

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
