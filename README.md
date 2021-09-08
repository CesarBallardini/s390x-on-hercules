# README - Instala s390x sobre el emulador Hercules


```bash
time vagrant up
vagrant ssh

bash -x ~/MAINFRAME/ubuntu/network.sh
pushd ~/MAINFRAME/ubuntu/ ; sudo hercules -f hercules.cnf ; popd
```

muestra el prompt del mainframe:

```text
herc =====>
```
* cargamos el instalador del ISO montado con el server Ubuntu:

```text
ipl /mnt/iso/ubuntu.ins
```

muestra la configuración de red:

```text
Configure the network device
----------------------------

Please choose the type of your primary network interface that you will need for
installing the Debian system (via NFS or HTTP). Only the listed devices are
supported.
Network device type:
  1: ctc: Channel to Channel (CTC) or ESCON connection,
  2: qeth: OSA-Express in QDIO mode / HiperSockets,
  3: iucv: Inter-User Communication Vehicle - available for VM guests only,
  4: virtio: KVM VirtIO,
Prompt: '?' for help>

```

Los mandatos siempre comienzan con un punto (`.`).  Elegimos *Channel to Channel connection*: escribimos `.1`

* elegimos el dispositivo de lectura, seleccionamos el `.1`:

```text
The following device numbers might belong to CTC or ESCON connections.
CTC read device:
  1: 0.0.0a00,      2: 0.0.0a01,
Prompt: '?' for help>

```

* elegimos el dispositivo de escritura, seleccionamos el 2, digitando: `.2`

```text
The following device numbers might belong to CTC or ESCON connections.
CTC write device:
  1: 0.0.0a00,      2: 0.0.0a01,
Prompt: '?' for help>

```

* elegimos el protocolo de la conexión, seleccionamos Linux, digitamos `.2`

```text
Protocol for this connection:
  1: S/390 (0)  *!,  2: Linux (1),      3: OS/390 (3),
Prompt: '?' for help, default=1>
```

* elegimos obtener dirección IP de forma estática, digitamos `.2`

```text

Configure the network
---------------------

Networking can be configured either by entering all the information manually,
or by using DHCP (or a variety of IPv6-specific methods) to detect network
settings automatically. If you choose to use autoconfiguration and the
installer is unable to get a working configuration from the network, you will
be given the opportunity to configure the network manually.
Auto-configure networking?
  1: Yes  *!  2: No
Prompt: '?' for help, default=1>
```


* ingresamos la dirección IP del ubuntu server dentro del s390, digitamos `.10.1.1.2`

```text
The IP address is unique to your computer and may be:

 * four numbers separated by periods (IPv4);
 * blocks of hexadecimal characters separated by colons (IPv6).

You can also optionally append a CIDR netmask (such as "/24").

If you don't know what to use here, consult your network administrator.
IP address:
Prompt: '?' for help>

```

* ingresamos la máscara de red, digitamos: `.255.255.255.0`

```text
The netmask is used to determine which machines are local to your network.
Consult your network administrator if you do not know the value.  The netmask
should be entered as four numbers separated by periods.
Netmask:
Prompt: '?' for help, default=255.255.255.0>

```

* ingresamos el gateway, digitamos: `.10.1.1.1`

```text

The gateway is an IP address (four numbers separated by periods) that indicates
the gateway router, also known as the default router.  All traffic that goes
outside your LAN (for instance, to the Internet) is sent through this router.
In rare circumstances, you may have no router; in that case, you can leave this
blank.  If you don't know the proper answer to this question, consult your
network administrator.
Gateway:
Prompt: '?' for help, default=10.1.1.1>

```

* ingresamos el nameserver, digitamos `.8.8.8.8`

```text
The name servers are used to look up host names on the network. Please enter
the IP addresses (not host names) of up to 3 name servers, separated by spaces.
Do not use commas. The first name server in the list will be the first to be
queried. If you don't want to use any name server, just leave this field blank.
Name server addresses:
Prompt: '?' for help, default=10.1.1.1>

```

* ingresamos el hostname, digitamos `.ubuntu390`

```text
Please enter the hostname for this system.

The hostname is a single word that identifies your system to the network. If
you don't know what your hostname should be, consult your network
administrator. If you are setting up your own home network, you can make
something up here.
Hostname:
Prompt: '?' for help, default=ubuntu>

```

* ingresamos el dominio del host, digitamos `.virtual`

```text
The domain name is the part of your Internet address to the right of your host
name.  It is often something that ends in .com, .net, .edu, or .org.  If you
are setting up a home network, you can make something up, but make sure you use
the same domain name on all your computers.
Domain name:
Prompt: '?' for help>

```

* ingresamos la contraseña de la cuenta `installer`, y luego continuamos la instalación mediante SSH, digitamos, por ejemplo: `.perico`

```text


Generating SSH host key

Continue installation remotely using SSH
----------------------------------------

You need to set a password for remote access to the Debian installer. A
malicious or unqualified user with access to the installer can have disastrous
results, so you should take care to choose a password that is not easy to
guess. It should not be a word found in the dictionary, or a word that could be
easily associated with you, like your middle name.

This password is used only by the Debian installer, and will be discarded once
you finish the installation.
Remote installation password:

```

* reingresamos la contraseña

```text

Please enter the same remote installation password again to verify that you
have typed it correctly.
Re-enter password to verify:
```


* ahora confirmamos el *fingerprint* y nos conectamos luego por SSH

```text
Start SSH

To continue the installation, please use an SSH client to connect to the IP
address 10.1.1.2 and log in as the "installer" user. For example:

   ssh installer@10.1.1.2

The fingerprint of this SSH server's host key is:
SHA256:jShlvRnYqsPf4QEhcb49W39bG7De97c9MArEeNyeGjs
                                                                                                                                                                                                                   
Please check this carefully against the fingerprint reported by your SSH                                                                                                                                           
client.                                                                                                                                                                                                            
 Press enter to continue!                                                           
```

* muestra detalles al oprimir "Enter":

```text
HHC02273I Index  1: ipl /mnt/iso/ubuntu.ins
HHC02273I Index  2: .1
HHC02273I Index  3: .2
HHC02273I Index  4: .10.1.1.2
HHC02273I Index  5: .255.255.255.0
HHC02273I Index  6: .10.1.1.1
HHC02273I Index  7: .8.8.8.8
HHC02273I Index  8: .ubuntu390
HHC02273I Index  9: .virtual
HHC02273I Index 10: .perico
```

* desde la VM hacemos:

```bash
ssh-keyscan 10.1.1.2 >> ~/.ssh/known_hosts
sshpass -p perico ssh installer@10.1.1.2
```


La instalación es la estándar de Ubuntu. No olvidar:
* crear cuenta de usuario, ejemplo `cesar`.
* contraseña para la cuenta, ejemplo: `cesarpw`
* instalar Open SSH server entre los paquetes
* no instalar ningún perfil, porque el espacio en disco es de sólo 2.5 GB.

La instalación demoró unas tres horas.

Cuando termina, se reinicia el sistema recién instalado, con lo cual se apaga el Ubuntu.

Para iniciar el Ubuntu nuevamente, en la pantalla de la consola, debe apretar la tecla ESC, y allí la secuencia
de teclas 'L' (IPL) y 'C' (por el dispositivo `C 0120 3390 DASD ./dasd/ubuntu.120.cckd [3339 cyls]`)

Con ESC volvemos a la consola de Hercules.

Luego de un momento, enla consola de Hercules aparece:

```text
[[0;32m  OK  [0m] Reached target Timers.
[[0;32m  OK  [0m] Listening on D-Bus System Message Bus Socket.
[[0;32m  OK  [0m] Reached target Sockets.
[[0;32m  OK  [0m] Reached target Basic System.
[[0;32m  OK  [0m] Started Regular background program processing daemon.
         Starting Configure dump on panic for System z...
         Starting Permit User Sessions...
         Starting OpenBSD Secure Shell server...
         Starting CPACF statistics collectio  n process for Linux on System z...

[[0;32m  OK  [0m] Started D-Bus System Message Bus.
[[0;32m  OK  [0m] Started irqbalance daemon.
[[0;32m  OK  [0m] Started Set the CPU Frequency Scaling governor.
         Starting System Logging Service...
         Starting Accounts Service...
         Starting Login Service...
         Starting Dispatcher daemon for systemd-networkd...
[[0;32m  OK  [0m] Started Configure dump on panic for System z.
[[0;32m  OK  [0m] Started Permit User Sessions.
[[0;1;31mFAILED[0m] Failed to start CPACF statistics co  mon process for Linux o
n System z.
See 'systemctl status cpacfstatsd.service' for details.
[[0;32m  OK  [0m] Started System Logging Service.
         Starting Hold until boot process finishes up...
         Starting Terminate Plymouth Boot Screen...
[[0;32m  OK  [0m] Started Hold until boot process finishes up.
[[0;32m  OK  [0m] Started Login Service.
[[0;32m  OK  [0m] Started Serial Getty on sclp_line0.
[[0;32m  OK  [0m] Started Serial Getty on ttysclp0.
[[0;32m  OK  [0m] Created slice system-getty.slice.
[[0;32m  OK  [0m] Reached target Login Prompts.
[[0;32m  OK  [0m] Started Terminate Plymouth Boot Screen.
[[0;32m  OK  [0m] Started Accounts Service.
[[0;32m  OK  [0m] Started OpenBSD Secure Shell server.
[[0;32m  OK  [0m] Started Dispatcher daemon for systemd-networkd.
[[0;32m  OK  [0m] Reached target Multi-User System.
[[0;32m  OK  [0m] Reached target Graphical Interface.
[[0;32m  OK  [0m] Started Stop ureadahead data collection 45s after completed st
artup.
         Starting Update UTMP about System Runlevel Changes...
[[0;32m  OK  [0m] Started Update UTMP about System Runlevel Changes.

Ubuntu 18.04.5 LTS ubuntu390 sclp_line0

ubuntu390 login:
herc =====>
```

Entonces se puede usar nuevamente SSH para conectarse al sistema Ubuntu:


```bash
ssh-keyscan 10.1.1.2 >> ~/.ssh/known_hosts

# las credenciales creadas durante la instalación:
sshpass -p cesarpw ssh -X cesar@10.1.1.2
```

# Dentro de Ubuntu en s390x

cesar@ubuntu390:~$ 

* `arch`

```
s390x
```

* `uname -a`

```
Linux ubuntu390 4.15.0-156-generic #163-Ubuntu SMP Thu Aug 19 23:28:47 UTC 2021 s390x s390x s390x GNU/Linux
```

* `LANG=C lscpu`

```
Architecture:        s390x
CPU op-mode(s):      32-bit, 64-bit
Byte Order:          Big Endian
CPU(s):              4
On-line CPU(s) list: 0-3
Thread(s) per core:  1
Core(s) per socket:  4
Socket(s) per book:  1
Book(s) per drawer:  1
Drawer(s):           1
NUMA node(s):        1
Vendor ID:           IBM/S390
Machine type:        2964
BogoMIPS:            117647.00
Hypervisor:          PR/SM
Hypervisor vendor:   IBM
Virtualization type: full
Dispatching mode:    horizontal
L1d cache:           512K
L1i cache:           512K
NUMA node0 CPU(s):   0-3
Flags:               esan3 zarch stfle msa ldisp eimm dfp edat etf3eh highgprs sie
```


* `lsb_release -a`

```
No LSB modules are available.
Distributor ID:	Ubuntu
Description:	Ubuntu 18.04.5 LTS
Release:	18.04
Codename:	bionic
```


* `df -h`

```
S.ficheros     Tamaño Usados  Disp Uso% Montado en
udev             2,8G      0  2,8G   0% /dev
tmpfs            570M   204K  570M   1% /run
/dev/dasda1      2,2G   1,4G  779M  64% /
tmpfs            2,8G      0  2,8G   0% /dev/shm
tmpfs            5,0M      0  5,0M   0% /run/lock
tmpfs            2,8G      0  2,8G   0% /sys/fs/cgroup
tmpfs            570M      0  570M   0% /run/user/1000
```


* `LANG=C free -m`

```
              total        used        free      shared  buff/cache   available
Mem:           5693          63        5345           0         283        5546
Swap:           105           0         105
```

Podemos navegar por Internet por ejemplo mediante `links2`:

```bash
sudo apt-get install links2 -y
```

y podemos utilizar aplicaciones gráficas, por ejemplo `xeyes`:

```bash
sudo apt install x11-apps

xeyes
```



# Apagado

* apagamos el sistema Ubuntu

```bash
sudo poweroff
```

* terminamos Hercules, en la consola, escribimos: `quit`

```
HHC02272I Highest observed MIPS and IO/s rates
HHC02272I   from Wed Sep  8 00:00:00 2021
HHC02272I     to Wed Sep  8 01:40:32 2021
HHC02272I   MIPS: 629.214457  IO/s: 1555
HHC00101I Thread id 00007f3e832c9700, prio 15, name Processor CP00 ended
HHC00101I Thread id 00007f3e834cc700, prio 15, name Processor CP01 ended
HHC00101I Thread id 00007f3e833cb700, prio 15, name Processor CP02 ended
HHC00101I Thread id 00007f3e830c7700, prio 15, name Processor CP03 ended
HHC00101I Thread id 00007f3e82fb1700, prio  4, name Console connection ended
HHC00333I 0:0120           size free  nbr st   reads  writes l2reads    hits switches
HHC00334I 0:0120                                                  readaheads   misses
HHC00335I 0:0120 --------------------------------------------------------------------
HHC00336I 0:0120 [*] 0776477257 000 % 3023    0102251 0269648 0000001 0113718  0146153
HHC00337I 0:0120                                                     0125282  0039927
HHC00338I 0:0120 ./dasd/ubuntu.120.cckd
HHC00339I 0:0120 [0] 0776477257 000 % 3023 rw 0102251 0269648 0000001
HHC00101I Thread id 00007f3e82a5e700, prio  8, name Read-ahead thread-1 ended
HHC00101I Thread id 00007f3e8295d700, prio  8, name Read-ahead thread-2 ended
HHC00101I Thread id 00007f3e8265a700, prio 16, name Garbage collector ended
HHC00101I Thread id 00007f3e8285c700, prio 16, name Writer thread-1 ended
HHC00101I Thread id 00007f3e8275b700, prio 16, name Writer thread-2 ended
HHC01427I Main storage released
HHC01427I Expanded storage released
HHC01422I Configuration released

HHC02103I Logger: logger thread terminating
HHC01424I All termination routines complete
HHC01425I Hercules shutdown complete
HHC01412I Hercules terminated
HHC00101I Thread id 00007f3e83819740, prio  0, name Control panel ended
```

* apagamos la VM

```bash
# desde la pc:
vagrant halt
```


# Referencias

* https://astr0baby.wordpress.com/2018/06/03/installing-ubuntu-18-04-server-s390x-in-hercules-mainframe-simulator/ como base
* https://www.youtube.com/watch?v=QTBNt32ERWE con estas correcciones
* https://github.com/hercules-390/hyperion
* https://wiki.ubuntu.com/S390X/Installation%20In%20LPAR instrucciones para instalar Ubuntu dentro de s390
* https://supratim-sanyal.blogspot.com/2018/10/bionic-beaver-on-zarchitecture-my.html
* http://www.fargos.net/packages/README_UbuntuOnHercules.html usa scripts para ayudar a configurar y correr los mandatos


