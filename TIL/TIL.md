# TIL (Today I've Learned)

### 31/05/2021
I listened to the first lecture on **[Andersen](https://andersenlab.com) DevOps courses**. Speakers was great. The Lesson was structured and interesting.

I refreshed my knowledge about **application development life cycles**, remembered their advantages and disadvantages.

### 01/06/2021
I was reading "**UNIX and Linux System Administration Handbook**", chapter about daemons.

### 02/06/2021
Found and started using the utility **[noti](https://github.com/variadico/noti)**. Very useful.

I continued reading the book **"A Practical Guide to Continuous Delivery"** by *Eberhard Wolff*, part 1, chapter 2.

I was also prepairing for the second lesson on the cource.

I listened to a lecture about the principles of **CI\CD** (Continuous Integration and Continuous Deployment). It was informative.

### 03/06/2021
Saved my notebook from the **biggest** in my life OS freeze. I have Mint 19.3 and the point was that my cat named ***"Kotunja"*** sat down at night on my notebooks keyboard and started typing a thousand of words, symbols, special symbols, press down some "hard" Hot-Keys and my notebook just freeze because of this "typing" attack. And it was not responding at all, keyboard, mouse, touchpad, screen - just nothing. But, for my luck - I'd opened SSH on my devices in local network (it's opened only in private LAN\WAN), so I just connected to my notebook from my Android Smartphone over SSH, ran **htop** utility and kill all "bad" processes easily. By the way, first connect to my frozen notebook via SSH took about **10-15 seconds**. In normal situation it took maybe **0.5** sec, or even less. 

### 04/06/2021
I read the book **"A Practical Guide to Continuous Delivery"** by *Eberhard Wolff*, part 2, chapter 3.

I read several articles about utilities on the [LinuxUprising](https://www.linuxuprising.com) website. I often use it to find convenient, large and small utilities and programs for Linux.

### 05/06/2021
I've remembered some features of the standard **ping** utility. More specifically, -c (count) -i (interval) and -s (size) options. For example, if I run it with ***-c 100*** parameter, ***-i 0.1*** parameter and ***-s 64400*** parameter (near maximum) and for destination use local IP like ***192.100.0.1*** you can create a load in LAN\WAN about in **20 Mbps**. Yes, this is absolutely not any kind of speed test, but as a local network quick test this might be useful in some situations. If you run two or three copies of ping with  options ***-c 1000 -i 0.01 -s 64000*** - you can test also some localhost max internal speed (maybe one of some ***bus speed***?). For my notebook, it is about **265 Mbps**. 

    sudo ping -c 100 -i 0.1 -s 64500 192.168.100.1

![Local Network](https://github.com/MikeKozhevnikov/devops-cource/blob/main/media/wlo1.png?raw=true)

    sudo ping -c 2000 -i 0.01 -s 64500 localhost

![Localhost](https://github.com/MikeKozhevnikov/devops-cource/blob/main/media/lo.png?raw=true)




### 06/06/2021
I read the documentation about ["The Cache Component"](https://symfony.com/doc/current/components/cache.html) and ["The Asset Component"](https://symfony.com/doc/current/components/asset.html) of [Symfony](https://symfony.com) Framework (version 5.3), theirs features and usage. 

### 07/06/2021
I listened to a lecture about the features of **scripting** for DevOps, and also about such tools as **Ansible**, **Chef**, **Puppet** and **SaltStack**, their features, advantages and disadvantages. That was very interesting.

### 08/06/2021
I watched informative, useful and interesting videos on the YouTube channel named ["DistroTube"](https://www.youtube.com/c/DistroTube) that's specialized on Linux and its features.


### 09/06/2021
I received an error, saying that my ntfs partitions mounted on Linux are in **read-only** mode. On the Internet, there are three quick ways to solve that problem:

1. Check access rights (not my case, all right was ok) 
2. Use gparted with "error fixing" at all your ntfs partitions. 
3. Use utilities hdparm and badblocks to find and fix possible bad sectors. 
4. Format partitions (no, sorry). 

But in my case I decided that maybe at first we might check errors in "native" for ntfs OS - **Win 10**? So I did it and it **worked**. After reboot, my ntfs partitions was ok in my Linux Mint with **full access** mode.

---

I listened to a lecture about **compiled**, **interpreted**, and **JIT-compiled** (Just-In-Time) programming languages. And also about various IDEs. It was very informative. By the way, my favorite IDE is **VS Code**. It's simple, fast and very powerful with plugins.

### 10/06/2021
I started working on my "bashscript" homework, including using the book "**Advanced Bash-Scripting Guide**" by ***Mendel Cooper***.

### 11/06/2021
There are very useful utility in Linux - **hdparm**. This utility can do some interesting and useful things with your HDD (SSD also). For example: it can check you HDD for some errors, fix bad sectors, get and set some device parameters and flags. But for me the most interesting feature of this utility - **speed checks**. If you run this utility with ***-t*** option, you can find out the **reading speed of HDD**. I tried this on my notebook with HDD and the result was about **110-130 MB/sec**. On my VPS servers, also with HDD, it showed about **150-170 MB/sec**, that's not so bad, actually. Unfortunately, I don't have any devices with an SSD. I would be interested in the results. With the ***-T*** option, you can also view the **read speed from the buffer** without using disk, i.e., using only memory, cache, and processor (CPU). 

Results of
    
    sudo hdparm -tT /dev/sda

for my notebook:

![Local Network](https://github.com/MikeKozhevnikov/devops-cource/blob/main/media/homepc.png?raw=true)

for development VPS:

![Local Network](https://github.com/MikeKozhevnikov/devops-cource/blob/main/media/development-server.png?raw=true)

### 12/06/2021
I spent all the night moving and decorating my week's notes from my paper diary to my notebook TIL blog. (*There was a reason for that*)