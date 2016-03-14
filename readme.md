# Bash Scripts for Linux and OSX

This repo contains bash scripts I have written to simplify common, repeatable tasks. Feel free to use/reuse and/or comment on the code. I am always open to suggestions.

## bash_profile
This is the bash_profile I currently use on OSX. It contains some code specific to my environment and some specific to OSX. You are welcome to copy/paste from it but I doubt you will be able to use the script in its entirety.

Much of the script is copied and slightly modified from information gathered from [nixCraft](https://www.cyberciti.biz) - my goto website when I am in doubt about anything Linux.

Many thanks to the individual(s) behind nixCraft.

## bash_template.sh
The template I use when writing new scripts from scratch.

Lots of kudos to the clever people that have inspired these script.

## osx_change_hostname.sh
Change the hostname of an OSX computer. Slightly more challenging than on Linux so I decided to *document* it in a script

## osx_remove_acl.sh and osx_remove_xattr.sh
When synchronising files between multiple OSX devices, I often run into issues ACLs and extended attributes. These scripts remove ACLs and XATTR from the designated folders.

## openssl_cipher_test.sh
Script to test the supported cipher types of a web server i.e. SSL2/3, TLS1.x etc.

Usage:

```
./openssl_cipher_test.sh <serveraddress> <port>
```