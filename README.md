# My Blog
A repository with technical tips, notes and some code

| Date | Entry | Categories |
|------|-------|------------|
| 2017-01-03 | <a href="https://github.com/mariodivece/strongswan-bridge-guide">Multiple IPSec Policy Routes in Windows Azure</a> | Infrastructure, IPsec, Linux |
| 2017-01-24 | Windows Server 2016 Anonymous File and Printer Sharing | Infrastructure, Windows |

## Windows Server 2016 Anonymous File and Printer Sharing

I wanted to experiment a bit with anonymous File and PRinter Sharing in Windows Server 2016. I needed local LAN users (not domain-joined) to be able to access folders and printers without getting prompted for a username and a password. I read a lot in the forums and I found a lot of stuff that isn't really necessary. Please note that this method anables the Guest account in the Server so please don't use it in an enterprise environment. Just manage Domain users instead.

### Preparation work

`Start` > `Local Secirity Policy` > `Local Policies` > `Security Options`
 - Accounts: Guest Account Status: `Enabled`
 - Network access: Let Everyone permissions apply to anonymous users: `Enabled`
 - Network access: Do not allow anonymous enumeration of SAM accounts and shares: `Disabled`
 
<img srec="https://raw.githubusercontent.com/mariodivece/blog/master/images/local-segurity-policy.png"></img>
