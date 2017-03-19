# Modern IT Infrastructure: A Practical Guide

## Introduction

Hello! Let me start by telling you about myself. I have been developing software for the better part of my life: that's almost 20 years. I got my Electrical Engineering degree from the University of Alberta in 2006. I am a proud Mexican and I own a small software consultancy services firm called [Unosquare](https://www.unosquare.com).

There are two reasons why I wanted to write this guide: First, I see that most software engineers and even IT professionals sometimes don't have enough infrastructure and networking knowledge or experience to become productive fast enough in our quickly evolving industry. My hope is that I cover most of the relevant material to make you, the reader, feel plenty confident when solving a lot of the problems you are presented with. Second, in addition to feeling the need of giving back a little by sharing my knowledge, I also wanted to keep notes and explanations on my own conclusions. So, this guide will serve as a set of notes to myself too. I will not be using fancy language because I believe that it would ruin the purpose of these notes. Enjoy the read.

## Chapter 1: Networking Basics

In this chapter, we will cover IPv4 and IPv6 address notations, subnets, address classes, CIDR notation, and unicast, broadcast and multicast communications. We will examine the differences between TCP and UDP. We will look at common types of switching technologies available and how these are useful.

### The Internet Protocol (IP)

For some of you, this section might feel repetitive. I still recommend you read through it to clear out any possible confusions. Plus, you might learn new things which is always important. The *Internet Protocol* or *IP* is a generic, standard _networking_ protocol designed to **carry** _transport_ protocol messages (called *Segments*) such as *TCP* and *UDP*. The *IP* protocol operates on Layer 3, the Network Layer of the OSI model. While other protocols such as *TCP* and *UDP* belong to Layer 4 of the OSI model, the Transport layer. We are not going to cover the *OSI* (Open Systems Interconnect) model in detail because it is material that is not going to be referenced much throughout this guide. I do recommend you review it here: [ISO 749801](https://www.ecma-international.org/activities/Communications/TG11/s020269e.pdf). I just packed a lot of information in this paragraph. Do not get discouraged. Continue reading as I explain all these details.

Like we stated before, *IP* defines a standard protocol for _network_ communications. It is separate from *TCP* (one of the many transport protocols available), and it is formally specified in [RFC-791](https://tools.ietf.org/html/rfc791). So, why do people (and operating systems) commonly and even interchangeably refer to the *IP* protocol as **TCP/IP** or the **TCP/IP stack**? Why isn't i called the **UDP/IP stack** instead? The answer is not as straightforward as you might like it to be. *IP* and *TCP* are different protocol types, operating at different layers, and they are largely independent. **TCP/IP** is the **combination** of the 2 protocols, one on Layer 3 and one on Layer 4. This combination should more properly be referred to as the *IP suite* instead because TCP is not the only transport protocol that IP can handle. The term **TCP/IP** is in use today because TCP is the original, and main transport protocol used in IP. In short, **IP** is a networking protocol, the **IP Suite** is the combination of the IP networking protocol plus several transport protocols, and people refer to this as **IP Suite** or more commonly as **TCP/IP**. But let's be clear that TCP does not imply IP or vice versa. You can consult [all the transport level protocols IP supports here](https://en.wikipedia.org/wiki/List_of_IP_protocol_numbers).

What is the difference between a _network_ protocol like *IP* and a _transport_ protocol like *TCP*? The transmission blocks of a **network** protocol contain data that specify source and destination computers in a network **plus** more data **containing** the blocks of a _transport_ protocol. The physical layer carries a stream of **bits**, making up **frames** at the Data Link layer. *Frames* contain **network packets** at the *network* level,  which in turn contain **transport** level protocol data called *Segments*. Here is a diagram showing the anatomy of *Frames*, *Packets* and *Segments*. These transmission blocks are called *PDU*s or *Protocol Data Units*.

<img src="https://github.com/mariodivece/blog/blob/master/images/it-protocol-transmission-units.png?raw=true"></img>

But the OSI model is not the only layer model out there. There are multiple models that take extremely similar approaches with slightly different names. While the OSI model defines a 7-layer model to connect systems. The IP specification defines only 4 of them. Here is a table with a rough comparison. Go to [RFC-1122](https://tools.ietf.org/html/rfc1122) for additional reference.

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

As you can see from the table above, it would be easy to map back and forth between layer models. So, don't get into big debates about which model is correct. The value in all layered models lies within the ability to decouple, to the maximum possible extent the various protocols at the different layers they operate. This allows for new protocols to come to life, and existing protocols to evolve with little to no regard for protocols in other layers. Check out this super interesting (partial) list of [popular protocols at the different OSI model layers](https://en.wikipedia.org/wiki/List_of_network_protocols_(OSI_model)). Also, note how *IPv4* and *IPv6* are both listed as Layer 3 protocols, the *IP Suite* (or *TCP/IP*) is listed as a Layer 3+4 protocol, and *TCP* and *UDP* are Layer 4 protocols.

Fun Fact: the IP layer model is **older** than the OSI model. IP was introduced officially in 1982 (the year I was born!) and the OSI Model was published in 1984. But enough about layers! Let's look at the fundamental elements that are practical and relevant to us. What standard aspects of networking are defined by the *Internet Protocol*, or *IP*? Many, in fact. But you just need to deeply understand a few of them.

- **Addresses**: It defines a way to represent network addresses, or more properly called, IP Addresses. Addresses are unique in a network and identify hosts. Hosts can have 1 or more IP addresses too.
- **Packets**: It defines a Layer 2, Protocol Data Unit with 2 basic parts: The first is called the *IP Header* which contains information about the source address, destination address, transport level protocol, and several of other details. The second is the *IP Data* which contains the transport-level message (or payload) between senders and receivers. As a reminder of one of the previous sections, Packets themselves are part of the Network layer and are ecapsulated by Layer 2 (Link Layer of the OSI model) PDUs called *frames*. [More about the structure of IP packets is available here](https://tools.ietf.org/html/rfc791#section-3.1). We will study *frames* when we get to switching.
- **Gateways**: Gateways or more properly called **Routers**, are computers that map and know how to reach addresses in the Internet or some other network on behalf of another host. A router allows other computers to send and receive packets to and from destinations they can't really reach on their own (i.e. hosts outside of their local network). Routers typically reach their final destinations either directly, or by using other routers and that is how the entire Internet is put together: like a web of hosts behind routers connecting to each other. As a side note, a network *hop* occurs when a network packet passes through a router. Please visit [this site](http://www.vox.com/a/internet-maps) containing charts that will help you visualize how this works. And just for fun, try to use the ```tracert``` command to see how many hops (or routers) your computer needs to go through to reach google.com. Try:

``` 
> tracert google.com 
```

In contrast, *IP* does **not** define the following:
- The order in which packets are sent and received.
- Receiving or sending acknowledgements that packets were received at the intended destination.
- Determining if the packets were received without corruption by the destination host.
- The format of the data contained in the packets.
- **Ports**: Surprisingly enough, IP does *not* define ports. We use addresses to identify hosts, and we use ports to identify applications within hosts. This allows different programs running in the same host to communicate with other programs running on remote hosts simultaneously. Ports are a notion that belongs to the realm of Transport level protocols (such as *TCP* and *UDP*) and not to the IP specification.
 
In other words, *IP* only defines the *logical* structure of a network, simplifying potentially complex network topologies by  *hiding* or *abstracting* the physical details away. You should now think about the flexibility that layered models like the OSI model provide, and how IP is an  **independent** protocol. In the future, we could have a different protocol replace IP (*IPv4*). In fact, this is slowly happening today with *IPv6*. But Transport level protocols or Application level protocols remain the same. Swapping the Network level protocol does not affect protocols in either higher or lower level protocols!

#### IPv4 Addresses

We mentioned earlier that the *IP* protocol provides us with a standard for defining IP Addresses. At the time of this writing, there are 2 versions of *IP* in use worldwide. *IPv4* or *IP version 4*, used by the clear majority of the Internet and *IPv6* used by only a small portion of the Internet. In IPv4, addresses are represented by a 32-bit sequence. This is roughly 4.3 billion unique addresses. In 2012 different sources estimate that there were between 8 and 10 billion devices connected to the Internet. So how is it possible that all those devices could be identified by using a unique IP address if the maximum amount of unique IP addresses is approximately half that number? We will explore the wonders of *NAT* and *subnetting* soon enough.

First, let's consider how to represent IP Addresses. As you most likely already know, we don't represent IP Addresses as some integer such as ```3488329``` and ```-347289985```. We represent IP Addresses in 4 *octets*, separated by a dot with each octet containing a decimal value from ```0``` to ```255```. It should be obvious that it is called an octet because it is 8 bits, and it should be also obvious that the range of an octet contains ```256``` possible values, namely ```0``` to ```255```. So, examples of IP Addresses are ```192.168.2.34```, ```8.8.8.8```, ```10.0.1.10```. There are special IPv4 Addresses reserved for certain purposes.
- Network Prefix Address: An IP Address representing the base, *zeroth* address to be used in a logical grouping of hosts. This address must not be assigned to any computer on any given group (or *subnet*). It is used for Network notation purposes only. For example, if we assume a network has ```256``` total addresses, ```192.168.4.0``` represents a network prefix address. Note that it does **not** tell us how many addresses the network contains and that is why I mentioned the assumption.
- Broadcast Address: It is in certain ways, the opposite of a Network Prefix Address because it is the last IP Address in a network subnet. An example of a Broadcast Address is ```192.168.4.255```. No single host should have this address, but ALL hosts can send packets to this address and ALL hosts can receive packets from this address. We will dig deeper into Broadcast communication later.
- The infamous "0.0.0.0" address: I say infamous because ```0.0.0.0``` has different meanings. In the context of routing it refers to the catch-all address typically called a *default route*. Then, in the context of an IP server it means *all* local addresses of this computer. Finally, in the context of an IP client, it means *no address* at all! -- We will see how this is especially useful when it comes to *DHCP*.
- Loopback Address: The legendary ```127.0.0.1``` also known as ```localhost``` is an IP address that a host gives itself for testing purposes only. Please note that IP addresses ranging from ```127.0.0.0``` to ```127.255.255.255``` cannot be reached from outside the host so don't use them!
- "Private" IP Addresses: These address ranges are addresses for hosts that are not directly connected to the Internet. This does not mean that they can't reach the Internet. It just means that they need a Router to do that job for them. The NRO (Number Resource Organization) which is the global organization responsible for tracking public IP address assignments will not give these private IP addresses out so you can use them inside your own networks. These ranges are: ```10.0.0.0``` to ```10.255.255.255```, ```172.16.0.0``` to ```172.31.255.255```, and ```192.168.0.0``` to ```192.168.255.255```.
- Multicast and Experimental IP Addresses: These IP addresses are reserved for Multicast communication (we will study multicast later) and experimental protocols. They cannot be used as public IP Addresses. The reserved range is ```224.0.0.0``` to ```239.255.255.255```. 
- Link-Local IP Addresses: This range of IP Addresses between ```169.254.0.0``` and ```169.254.255.255``` is allocated for communication between hosts on a single link. Whoa! What does that mean exactly? When a network interface in the host is unable to determine what IP address to use because there is no available DHCP server or because it has not been assigned an IP Address manually, it will automatically try to configure itself so it is able to communicate with other automatically-configured hosts in the network. When you see these addresses though, it typically means there's something wrong with your network -- yes, like when Windows gives you an IP address in this range and you immediately know you have a problem.
- Other special IP Addresses: There are other, less relevant IP Address ranges. If you wish to consult them, please go to [RFC-3330](https://tools.ietf.org/html/rfc3330). 

Given the above list of special IP address reservations, we can conclude that a *Network Prefix Address* and a *Broadcast Address* together define a group of hosts that can communicate with each other and we call this a **subnet**. For example, if the *Network Prefix Address* is ```192.168.0.0``` and the *Broadcast Address* is ```192.168.0.255``` that means that we can assign ```192.168.0.1``` all the way to ```192.168.0.254``` to the hosts in such a network. 

You need 2 components to define an IP network address space: A Network prefix and Broadcast address. How do we represent these together? We use the Network address plus something called a **subnet mask**. In our example above, we would represent the network address space as: ```192.168.0.0/255.255.255.0```. Wait a minute. that IP address after the forward slash looks **nothing** like broadcast address! That ```255.255.255.0``` IP address **is** the **subnet mask**. And it is simply a notation to determine what bits of the ```192.168.0.0``` network prefix address identify the constant **network number** and what parts are assignable to host addresses (variable). The latter is also called the **host number**. If you convert ```255``` (decimal) to 8-bit binary, you end up with ```11111111```. So, if you bitwise AND each of the octets of the network prefix and the subnet mask, you can determine which part of the address spaced if *constant* and what part is *variable*, or *assignable to hosts*. And yes, you guessed right: the ```1``` bits are *fixed*. The ```0``` bits are variable. We will get to some more examples later in this section.

As you can see, network address spaces can be very small or very large. The notion of IP **Address Classes** appeared in 1981. This (now obsolete) standard divided IP addresses into 5 different classes as shown below.

| Class | Networks | Addresses per Network | Total Addresses | Start Address | End Address | Subnet Mask |
|-------|----------|-----------------------|-----------------|---------------|-------------|-------------|
| Class A | 128       | 16,777,216 | 2,147,483,648 | 0.0.0.0    | 127.255.255.255 | 255.0.0.0     |
| Class B | 16,384    | 65,536     | 1,073,741,824 | 128.0.0.0  | 191.255.255.255 | 255.255.0.0   |
| Class C | 2,097,152 | 256        | 536,870,912   | 192.0.0.0  | 223.255.255.255 | 255.255.255.0 |
| Class D (multicast) | N/A | N/A  | 268,435,456   | 224.0.0.0  | 239.255.255.255 | N/A           |
| Class E (reserved)  | N/A | N/A  | 268,435,456   | 240.0.0.0  | 255.255.255.255 | N/A           |

The Internet was originally designed so that small networks in homes and small businesses would be assigned class C addresses, government and large corporations assigned class B addresses, and very large networks such as carrier networks were assigned class A addresses. This would theoretically prevent IP address exhaustion and still give each host in the Internet a unique IP address. This rapidly became obsolete with the rise of the World Wide Web in the early 90's and was replaced in 1993 with the **Classless inter-domain routing (CIDR)** standard. Even if we can still refer to a given IP address as being part of an *address class*, this information is not useful at all as the **CIDR** standard is much more flexible, specific and useful when it comes to defining address spaces.

So, what exactly is the problem with address classes? Let's suppose that at home we have a Class C address space ```192.168.0.0/255.255.255.0```. We are **forced** to use the ```255.255.255.0``` subnet mask! That means that we can't define an address space from say, ```192.168.0.1``` to ```192.168.3.254``` unless we define 4 distinct networks: ```192.168.0.0/255.255.255.0```, ```192.168.1.0/255.255.255.0```, ```192.168.2.0/255.255.255.0```, and ```192.168.3.0/255.255.255.0```. It should be obvious how creating address spaces by using address classes is both, limiting and inconvenient! It's much simpler to define a single network ```192.168.0.0/255.255.252.0```. There is a single broadcast address for all that address space, there's a few more usable addresses, and we simplify configuration and routing tasks. **CIDR** notation further simplifies this by just specifying the **subnet mask** as the number of bits from left to right set to 1 (constant bits).

In our example ```192.168.0.0/255.255.252.0```, the subnet mask is ```255.255.252.0```. If we convert this to binary, we get: ```11111111.11111111.11111100.00000000```. Count the number of bits set from left to right and we get a total of ```22```. Thus, we can represent the entire address space as: ```192.168.0.0/22```. That's neat, flexible and easy to understand! No more are we limited by a mandated, fixed subnet mask depending on a given *address class**.

-- EOF --

### Local IPv4 Networks

Let's make a stop and review the most relevant concepts you will need to uunderstand this section.
- Private IP Address Ranages:  ```10.0.0.0``` to ```10.255.255.255```, ```172.16.0.0``` to ```172.31.255.255```, and ```192.168.0.0``` to ```192.168.255.255```.
- Subnet: A logical group of hosts sharing the same network prefix address but assigned distinct Host addresses.
- CIDR Notation: A standard for representing a network address space. It has to parts: a network prefix address, and a subnet mask expressed in decimal. These components are separated with a forward slash ```/```; for example ```10.34.2.0/24```.

Recall we stated Routers are computers that understand how to make requests and receive responses from and to other computers on behalf of the hosts behind them. So, we have several hosts behind a Router that communicate to the rest of the Internet by asking the router to forward packets to remote destinations. But before we explore how hosts behind a router reach destinations on the vast Internet, we need to understand how hosts in the same subnet communicate with each other.

When the term *LAN* or *Local Area Network* is brought up, you probably feel extremely familiar with it. The reality is that there seems to be some confusion when it comes to the details. A *LAN* is a group of locally managed hosts that connect to each other. Do they share the same network segment? Do they all share the same subnet? The answer to both questions is: not necessarily.

Recall a subnet is a group of hosts sharing the same network address space. Unfortunately, some poeple use the term *subnet* and *segment* interchangeably. This is incorrect. A network *segment* is not a *subnet*. The term is more generic and refers to the bus hosts are attached to. In other words, A segment changes when the connection between hosts changes on Layers 1 or 2 (Physical or Data Link layers) of the OSI model, while a subnet belongs entirely to Layer 3 (the Networking layer) of the OSI model. We can therefore conclude that a *LAN* can have multiple subnets over a single segment, a single subnet over multiple segments, or multiple subnets over multiple segments. 

Example of a single subnet over multiple segments: This is one of the most common LAN setups for home networks. There typically will be a router provided by the ISP with a port providing Internet service, a few ethernet ports, and Wi-Fi capabilities. Devices connected to the ethernet ports are on the *ethernet* segment. Devices connected over Wi-Fi are on the Wi-Fi segment. And the line going from the router to the ISP is on a different segment. But note that both, devices connected via ethernet and devices connected via Wi-Fi will all share the same address space!

Examples of multiple subnets over a signle segment: 

But what happens when a client wants to communicate directly with a different client? Turns o

A Router will typically have at least 2 network interfaces. One connecting to the public Internet and one more connected to the switch where the *LAN* or *Local Area Network*. But how do you differentiate between the 2?

Subnet Masks:

#### UDP: Fire-and-Forget

#### TCP: Reliable Communication


### Unicast, Broadcast and Multicast


### Knowledge Check

 1. What is a Protocol Data Unit?
 2. What are the fundamental differences between the PDUs used by the Link Layer and the Network Layer
 3. Which OSI model layer does the *IP* specification operate on
 4. What are the means the *IP* specification uses to ensure packets are delivered without corruption to the destination host?
 5. If a new networking specification came out in a few years, replacing *IPv4* does it mean that TCP applications would need to be rewritten? Why or Why not?
 6. Research: *TCP/IP* and *IP Suite* are equivalent terms. What is yet another synonym for these terms?
 7. Exam Question: For the network ```10.59.0.0/16```, answer the following questions 
     - What is the Network Prefix?
     - What is the Broadcast Address?
     - What is the Netmask in standard IP Address notation?
     - What is the Netmask in binary IP Address notation
     - Provide the total number of IP addresses.
     - Provide the total number of usable host addresses. 
     - Is ```10.59.129.0``` a valid, assignable IP address for a host? 
     - For the above response, explain why or why not?
 8. Can broadcast communication be accomplished using the *TCP* transport protocol? Why or why not?
 
## Chapter 2: Firewalls, Routing and Wi-Fi

In this chapter, we will cover the notion of routing. It includes concepts such as Network Address Translation, Gateways, Firewalls, and other means of establishing communications between computer systems. We will also cover useful information regarding Wireless Networks and how to set them up properly.

### How Routers talk to each other

We already know that Routing is fundamental to building IP networks. The Internet is built by putting together many IP networks. But how do routers know how to communicate with each other?  How do they know how many *hops* are required to get a packet to a destination? And how do routers know how to handle a response **all the way back** to the host that sent the request? 

### The trip of IP packets

It is very common to assume that if an IP packet is sent via a series of hops -- or Routers --, a response from the receiving host will take the same route back. This is completely incorrect!

## Chapter 3: DHCP, DNS, HTTP and HTTPS

Here we will learn how DNS works and why it is important when deploying web applications. We will also explore the specifics of the HTTP 
protocol and how asymmetric cryptography makes HTTPS possible and why it is important.

## Chapter 4: Chroot, Namespaces and Virtualization

We start getting more sophisticated in this chapter. We will study Virtual Machines, Virtual Hard Disks, Virtual Switches, and Virtual Network Adapters.

## Chapter 5: Windows Azure

We will cover the fundamentals of cloud computing starting by understanding the difference between IaaS, PaaS and SaaS. We will also learn how to successfully deploy various types of applications.

## Chapter 6: Network Security

We will understand the usefulness of a Web Application Firewall and how to perform penetration testing on web applications with well-known tools. We will also explore common attacks such as DDoS, SQLi, XSS, Dictionary Password Guessing and Brute force Password Guessing, and how to stop them. We will learn how to setup firewall rules and policies.

## Chapter 7: Continuous Integration

Although this topic leans more towards developers, it is important that a network engineer understands and is also capable of setting up
simple CI and CD environments.

## Chapter 8: Identity Management

In this chapter, we will cover basic aspects of Active Directory management, LDAP connections, Azure Directory integration, etc.

## Chapter 9: Office 365

At the time of this writing, Office 365 is in popular demand. We will study cloud-only deployments, hybrid identity management,
subscription and plan types, PSTN capabilities, and the basics of Exchange Online management.

## Chapter 10: The Private Branch Exchange

We will cover the basics of getting a VoIP phone system correctly configured, the implications of using different audio codecs, Trunks, FXO
Gateways, VoIP phones and their types, and QoS.

## Chapter 11: Other Systems

I have left this chapter to cover applications that are typically required in an enterprise environment. These include FTP servers, 
SFTP servers, Version Control systems, E-Learning systems, and others. 
