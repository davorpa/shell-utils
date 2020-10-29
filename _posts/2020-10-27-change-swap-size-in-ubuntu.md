---
layout: post
comments: true
category: code
tags: [linux, ubuntu, shell, bash, swap, memory]
title: Change swap size in Ubuntu 18.04 or newer
#lang: en-US
excerpt_separator: <!--more-->
---
---

![Gparted Linux Swap Partitioning]({{'/assets/posts/linux-gparted-swap.jpg' | relative_url}})

Swap is a special area on your computer, which **the operating system can use as additional RAM**.

Starting with Ubuntu 17.04, _the swap partition was replaced by a swap file_. The main advantage of the swap file is easy resizing.

In the following example, we’ll extend the swap space available in the `/swapfile` from `2 GB` to `8 GB`.
<!--more-->
Why? Recently I bought a laptop without any operative system installed and I definitely wanted to start moving to Linux, triying with the Ubuntu distro. By default, the installation allocated me a 2GB file and after an intensive use I realize that sometimes it freezes, especially if Chrome browser does some bull shits 😆. Then, I need enter on TTY and kill some processes before computer dead completelly and desn't respond.

Normally **it's recomended** that swap file has the same size that physical memory size. If you have 8 GB of RAM, then 8 GB of swap. At least, in Windows is something like that.

## Steps

Execute these commands in a shell following the next order:

1.  Check current size:
    ```bash
    grep SwapTotal /proc/meminfo
    # SwapTotal:       2097148 kB
    ```

2.  Turn off all swap processes:
    ```bash
    sudo swapoff -a
    ```
    This can spend some time because need to release resources, and erase these portion of disk. So, be patient 😉.

3.  Resize the swap:
    ```bash
    sudo dd if=/dev/zero of=/swapfile bs=1G count=8
    ```
    `if` = input file.
    `of` = output file.
    `bs` = block size.
    `count` = multiplier of blocks. `8 => 8GB`

    This can take a while too because needs create the new file.

4.  Change permissions:
    ```bash
    sudo chmod 600 /swapfile
    ```

5.  Make the new file usable as swap:
    ```bash
    sudo mkswap /swapfile
    ```

6.  Activate:
    ```bash
    sudo swapon /swapfile
    ```

7.  Edit `/etc/fstab` and add the new swapfile if it isn’t already there
    ```bash
    /swapfile   none    swap    sw  0   0
    ```
    It should not be necesary because step 6 do it for you, but just in case inspect it.

6.  Check the the new amount of swap available:
    ```bash
    grep SwapTotal /proc/meminfo
    # SwapTotal:       7812496 kB
    ```

## Conclusions

If your computer starts to use the fan and maybe freezes for a long time during that, you know almost a light at the end of the tunnel that shows you the way to start.

I hope this post has been helpful.
