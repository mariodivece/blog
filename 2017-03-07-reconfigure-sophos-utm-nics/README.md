# How to reconfigure Sophos UTM network interfaces via CLI

## The Problem

Sometimes you restore a backup or accidentally disable a NIC in your firewall deployment and you end up with an inaccessible
WebAdmin or NIC confuration that was not intended. Contrary to the typical search results which suggest editing text files, 
I present a solution that I believe is much easier and uses the standard configurations.

## Preparation Work

Create a backup if possible before making any changes. I always prefer a VM deployment so I am able to create snapshots of the VM
at several points in the process and I can easily revert the state of the VM if something goes horribly wrong. I suggest you do the same.
Login to your firewall via ```SSH``` or on the device itself. When prompted, Username ```loginuser```, Password: ```yourpasswordhere```. 
Now enter ```sudo confd-client.plx```.

## Performing Configuration Changes

The ```CLI``` is totally unsupported but it's easy to work with and navigate. It has several modes of operation. We are going to use the
```OBJS``` Mode, so go ahead and type in ```OBJS``` and press ```Enter``` You should see a message stating that you have entered ```OBJS```
mode.

Now go ahead and hit the ```TAB``` key a couple of times. You should see a list of object categories with ```interface``` beign one of them.
Type in ```interface``` and press ```Enter```. Tip: You don't have to type in the entire name. Typing the first few letters and hitting ```TAB```
will show what your options are :).

Go into the ```ethernet``` subcategory. and press ```TAB``` twice. It will list the existing object names. Identify the adapter that
you wish to access and type in a few letters of its name to go into its configuration.

In my case, sometimes ethernet objects do not have an assigned Hardware objects after a reinstall. In other words, my ```itfhw``` for the given
network adapter object appears empty!  I simply enter: ```itfhw=``` and ```TAB``` to list the options I have and then enter the more distinctive
name so it's able to assign it. You can change not only this setting but any other setting you wish in this same way. For example, you can
enable the interface by typing: ```enable=1```.

Finally, once you are done with your changes, you will need to write the changes: Simply enter ```w``` and ```Enter```. This writes the configuration changes you just made.
To exit the CLI, just type in ```exit```. That's it! I hope this helps someone.
