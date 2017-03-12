# Modern IT Infrastructure: A Practical Guide

## Introduction

Hello! Let me start by telling you about myself. I have been developing software for the better part of my life. Almost 20 years now. 
I got my Electrical Engineering degree from the University of Alberta. I am a proud Mexican and I own a small software consultancy services firm called Unosquare.

There are two reasons why I wanted to write this guide: First, I see that most software engineers, developers and even some IT people 
simply don't have enough knowledge or the experience required to become productive fast enough in our quickly evolving industry. My hope is that I cover enough material to make you, the reader, feel plenty confident at solving any problem you are given. Second, in addition to feeling the need of giving back a little and sharing my knowledge, I also felt that I wanted to keep notes and explanations on my own conclusions. So it will serve as a set of notes to myself too.

## Chapter 1: Networking Basics

In this chapter we will cover IPv4 and IPv6 address notations, address classes, unicast, broadcast and multicast communications. We will
examine the differences between TCP and UDP. We will look at common types of switching technologies available and how these are useful.
We will also cover useful information regarding Wireless Networks and how to set them up properly.

### The Internet Protocol Suite

For most of you, this section will be rather trivial. I still recommend you read through it. The *Internet Protocol* or *IP* is a generic, standard network protocol suite that provides the basis for additional comminucation protocols on top of it such as *TCP* or *Transmission Control Protocol* and *UDP* or *User Datagram Protocol*. The *IP* suite operates at layer 3, the networking layer of the OSI model. We are not going to cover the *OSI* (Open Systems Interconnect) because it is basic material that is not going to be referenced much throughout this guide.

What is important, is that you understand that *IP* defines some basic aspects of communications and networking. It is **NOT** TCP/IP so please drop the term TCP for now because TCP is a protocol that is part of the *suite* of protcols that build on top of *IP*. Let me repeat that: Protocols such as *TCP* and *UDP* are part of a *suite* of protocols that build on **top** of the *IP* standard.

So, let's cut to the chase: what standard aspects are defined by the *Internet Protocol*, or *IP*? Many, in fact. But you just need to understand a few of them.

 - Addresses: It defines a way to represent network addresses, or mor properly called, IP Addresses.
 - Packets: It defines a transmission data structure with 2 parts. The first is called the *IP Header* whcih contains information about the source, destination, and the second is the *IP Data* which contains the messages between such senders and receivers. Packets themselves are contained within Layer 2 (Link layer of the OSI model) structures calles *frames*.
 
 | Frame Header | IP Header | Protocol Header | Protocol Data | Frame Footer |
 - Gateways: Gateways or Routers are computers that map and know how to reach a number of addresses in the Internet on behalf of a client. A router allows other computers to send and receive packets to and from destinations thay can't really reach on their own. Gateways typically reach their final destinations by using other gateways and that is how the entire Internet connects. Every time a packet passes through a router, this is called a *hop*. Please visit [this site](http://www.vox.com/a/internet-maps) containing maps that will help you understand how this works.
 - Ports: In addition to identifying source and destination computers, ports are used to identify applications within computers. This allows different programs running in the same computer to communicate with other computers simultaneously. Please not that ports are technically **NOT** part of the *IP* specification 

In contrast, it does **not** define:
 - The order in which packets are sent and received.
 - Receiving or sending acknoledgements that packets were received at the intended destination.
 - Determining if the packets were received without corruption by the destination computer.
 - The format of the data contained in the packets.
 
In other words, *IP* defines **how** to create connections between multiple systems simplifying potentially complex network topology by simply hiding it. But without additional standard protocols defined on top of it, you should have realized by now that it really is not of much practical use. Think about why for a few minutes.

#### TCP to the Rescue

#### UDP: Fire-and-forget

#### Knowledge Check

 - Q1: 

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

## Chapter 10: The Provate Branch Exchange

We will cover the basics of getting aphone system correctly configured, the implications of using different audo codecs, Trunks, FXO
Gateways, VoIP phones and their types, and QoS.

## Chapter 11: Other Systems

I have left this chapter to cover applications that are typically required in an enterprise environment. These include FTP servers, 
SFTP servers, Version Control systems, E-Learning systems, and others. 
