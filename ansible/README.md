# Ansible assignment

## Contents
---
### What's that?

This is a Python application on [**Flask**](https://flask.palletsprojects.com/) that can be deployed to a server using [**Ansible**](https://www.ansible.com) and handling ***GET*** and ***POST*** requests.

**Requirements:**
+ [Ansible](https://www.ansible.com)
+ Any VM (Virtual Mashine) or VPS server with ***Debian 10*** with configured network, **available** IP address (for VM, for example, configured bridge interface)

**Notes:**
+ ***Debian 10*** by default, but should work on any ***Debian-based*** system that uses the [**APT** Package manager](https://tracker.debian.org/pkg/apt)

### What do I need to do to make a deployment?
+ 
+ 

### What do Flask application (service)?
+ the service listens at least on port 80 (443 as an option)
+ the service accepts GET and POST methods
+ the service should receive `JSON` object and return strings in the following manner:
    ```sh
    curl -XPOST -d'{"animal":"giraffe", "sound":"hmy-hmy", "count": 2}' http://ip/
    🦒 says hmy-hmy
    🦒 says hmy-hmy
    Made with ❤️ by Mikhail
    ```
### What does the remote server configuration look like after deploying with Ansible?
+ Allowed connections only to the ports 22, 80 and 443.
+ Disabled root login.
+ Disabled all authentication methods except 'public keys'.
+ An [**nginx**](https://nginx.org) server listening on ports **80** and **443**.
+ Flask application is configured through [**systemd**](https://systemd.io) as a service so that it restores its functionality after a system reboot.
+ Python3-pip & flask installed, ***emoji*** module for flask installed.

### What would you expect to see when visiting a random unknown website?
Hmm... Maybe something ***mysterious***?

---

## Assignment description

### Create and deploy your own service
### The development stage:
For the true enterprise grade system we will need Python3, Flask and emoji support. Why on Earth would we create stuff that does not support emoji?!

* the service listens at least on port 80 (443 as an option)
* the service accepts GET and POST methods
* the service should receive `JSON` object and return strings in the following manner:
```sh
curl -XPOST -d'{"animal":"cow", "sound":"moooo", "count": 3}' http://myvm.localhost/
cow says moooo
cow says moooo
cow says moooo
Made with ❤️ by %your_name

curl -XPOST -d'{"animal":"elephant", "sound":"whoooaaa", "count": 5}' http://myvm.localhost/
elephant says whoooaaa
elephant says whoooaaa
elephant says whoooaaa
elephant says whoooaaa
elephant says whoooaaa
Made with ❤️ by %your_name
```
* bonus points for being creative when serving `/`

### Hints
* [installing flask](https://flask.palletsprojects.com/en/1.1.x/installation/#installation)
* [become a developer](https://flask.palletsprojects.com/en/1.1.x/quickstart/)
* [or whatch some videos](https://www.youtube.com/watch?v=Tv6qXtc4Whs)
* [dealing with payloads](https://www.digitalocean.com/community/tutorials/processing-incoming-request-data-in-flask)
* [Flask documentation](https://flask.palletsprojects.com/en/1.1.x/api/#flask.Request.get_json)
* [The database](https://emojipedia.org/nature/)
* 🐘 🐮 🦒
* what would you expect to see when visiting a random unknown website?

### The operating stage:
* create an ansible playbook that deploys the service to the VM
* make sure all the components you need are installed and all the directories for the app are present
* configure systemd so that the application starts after reboot
* secure the VM so that our product is not stolen: allow connections only to the ports 22,80,443. Disable root login. Disable all authentication methods except 'public keys'.
* bonus points for SSL/HTTPS support with self-signed certificates
* bonus points for using ansible vault

### Requirements
* Debian 10
* VirtualBox VM
