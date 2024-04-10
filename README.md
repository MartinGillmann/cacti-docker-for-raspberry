# cacti-docker-for-raspberry
Run Cacti monitoring solution in a docker on Linux/Debian/Raspberrypi 4.

[Cacti](https://www.cacti.net/)

[Docker](https://www.docker.com/)

[Raspberry](https://www.raspberrypi.com/products/raspberry-pi-4-model-b/)


The Dockerfile handles the installation of the needed components (PHP, Apache2, MySQL, Cacti...) and all the tweaking to get Cacti running smoothly.

# Instructions

### 1) Copy the Dockerfile 
and cd into the folder where you copied the Dockerfile into

### 2) Create the docker image
```
sudo docker build -t i_cacti_v17 -f Dockerfile .
```

### 3) Run the image (create a container from the image and run it
```
sudo docker run -p 8081:80 -d --restart=unless-stopped -t --name c_cacti_v17 --hostname CactiV17 i_cacti_v17
```

### 4) The startup takes about 120 seconds, wait or run
```
sudo docker logs -f c_cacti_v17
```
and have a look at the log until you see a line like
```
Cacti Startup: You are ready to start. Open the browser on http://<MYSERVERNAME>/cacti
```
than press CTRL+C to exit the log.

### 5) Use a browser to connect to it
```
http://<MYSERVERNAME>/cacti
```
and logon with the default username **admin** and password **admin**.

![Browser Startup](https://github.com/MartinGillmann/cacti-docker-for-raspberry/blob/361c60a1887bb2b7c44f76e456d4397a1c81cb08/Images/Cacti_startup.jpg)

To find out the ip of your docker host use **ifconfig eth0**
```
root@raspberrypi:/# ifconfig eth0
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.41.11.54  netmask 255.255.0.0  broadcast 10.41.255.255
```

# Alternative with docker hub
The image can also be pulled from docker hub
```
docker pull martingillmannch/i_cacti
```

# Prerequirements
A device which has docker running. In my case it is the raspberry pi 4.
```
root@raspberrypi:/# uname -a
Linux raspberrypi 6.1.0-rpi4-rpi-v8 #1 SMP PREEMPT Debian 1:6.1.54-1+rpt2 (2023-10-05) aarch64 GNU/Linux
```
```
root@raspberrypi:/# lscpu
Architecture:            aarch64
  CPU op-mode(s):        32-bit, 64-bit
  Byte Order:            Little Endian
CPU(s):                  4
  On-line CPU(s) list:   0-3
Vendor ID:               ARM
  Model name:            Cortex-A72
    Model:               3
    Thread(s) per core:  1
    Core(s) per cluster: 4
    Socket(s):           -
    Cluster(s):          1
    Stepping:            r0p3
    CPU(s) scaling MHz:  100%
    CPU max MHz:         1800.0000
    CPU min MHz:         600.0000
    BogoMIPS:            108.00
    Flags:               fp asimd evtstrm crc32 cpuid
Caches (sum of all):
  L1d:                   128 KiB (4 instances)
  L1i:                   192 KiB (4 instances)
  L2:                    1 MiB (1 instance)
```
```
root@raspberrypi:/# docker -v
Docker version 24.0.7, build afdd53b
```

# Support
If you feel this has saved you time, please consider buying me a coffee.

[www.buymeacoffee.com/mgillmann](https://www.buymeacoffee.com/mgillmann)

Thanks!



