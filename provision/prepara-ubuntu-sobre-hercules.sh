#!/usr/bin/env bash

UBUNTU_ISO_FILENAME=$1
UBUNTU_ISO_URL=$2

NUMCPU=4                         # cantidad de CPUs

gateway_interface=enp0s8
# la interfaz configurada con la dirección IP 192.168.44.11:
#gateway_interface=$( ifconfig | grep -B1 192.168.44.11 | grep -o "^\w*" )

## la interfaz del default gateway: (esta no es la que hace falta)
#gateway_interface=$( netstat -rn | awk '/^0.0.0.0/ { print $NF; exit }' )


descarga_iso_ubuntu_para_s390() {
  mkdir -p /vagrant/tmp/
  pushd /vagrant/tmp/
  [ -f ${UBUNTU_ISO_FILENAME} ] || wget ${UBUNTU_ISO_URL}
  popd
}

prepare_dir_structure() {  # Prepare the Mainframe directory structure for Ubuntu Hercules simulation
  mkdir -p ~/MAINFRAME/ubuntu/dasd
  cd ~/MAINFRAME/ubuntu/dasd

  # filename: ~/MAINFRAME/ubuntu/dasd/ubuntu.disk 
  # device type: 3390-3
  # initial volser: LIN120
  # size: 8000 cylinders
  # size 3338 is one less than the number of cylinders on a 3390-3: 3339.  This is the maximum size of a minidisk on z/VM® (other than a full-pack minidisk) when the underlying disk is a 3390-3.  
  #dasdinit -lfs -linux ubuntu.disk 3390-3 LIN120      # this creates 2.8 GB disk
  #dasdinit -lfs -linux ubuntu.disk 3390-3 LIN120 8000 # this creates 6.8 GB disk

  [ -f ubuntu.120.cckd ] || dasdinit -z -lfs -linux ubuntu.120.cckd 3390-3 LIN120    # you can use zlib or bz2 compressed DASDs by using the -z or -bz2 arguments
}


crea_hercules_cnf() {

  cat - | sudo tee ~/MAINFRAME/ubuntu/hercules.cnf > /dev/null <<!EOF
CPUSERIAL 012345 # You can choose your own serial number

CPUMODEL  2964 # z13
#CPUMODEL 2086
#CPUMODEL 3090

DIAG8CMD ENABLE
ECPSVM YES

PANTITLE  "zubuntu" # chosen hostname

MAINSIZE 6000 # This 6 gigabyte size is usable
#MAINSIZE 1024


NUMCPU ${NUMCPU}
MAXCPU ${NUMCPU}

#OSTAILOR LINUX
OSTAILOR Z/OS
PANRATE SLOW
#PANRATE 80

ARCHMODE z/Arch
#ARCHMODE ESAME
CODEPAGE 437/500


#ALRF ENABLE (deprecated)
ARCHLVL ENABLE asn_lx_reuse
ARCHLVL  ENABLE BIT53
ARCHLVL  ENABLE BIT54 # Interlocked-access facility 2
ARCHLVL  ENABLE BIT44 # PFPO Facility
ARCHLVL  ENABLE BIT37 # unknown
ARCHLVL  ENABLE BIT45 # FAST BCR SERIAL (on by default)
ARCHLVL  ENABLE BIT49 # MISC INST EXTN 1 (on by default)

CCKD RA=2,RAQ=4,RAT=2,WR=2,GCINT=5,GCPARM=0,NOSTRESS=0,TRACE=0,FREEPEND=-1
CNSLPORT 3270
CONKPALV (3,1,10)
LOADPARM 0A95DB..
LPARNAME HERCULES
MOUNTED_TAPE_REINIT DISALLOW
PGMPRDOS LICENSED
SHCMDOPT NODIAG8
SYSEPOCH 1900
TIMERINT 50
TZOFFSET +1400
YROFFSET 0


# .-----------------------Device number
# |     .-----------------Device type
# |     |       .---------File name and parameters
# |     |       |
# V     V       V
#---    ----    --------------------

# Display Terminals
0700 3270
0701 3270

# dasd
0120 3390 ./dasd/ubuntu.120.cckd

# tape
0581    3420

# network                               s390     realbox
0A00,0A01  CTCI -n /dev/net/tun -t 1500 10.1.1.2 10.1.1.1

!EOF

}


crea_network_script() {  # networking script to start prior the Hercules simulation so that we can use the network inside our simulator

  cat - | sudo tee ~/MAINFRAME/ubuntu/network.sh > /dev/null <<!EOF
sudo iptables -F INPUT
sudo iptables -F OUTPUT
sudo iptables -F FORWARD
sudo iptables -t nat -A POSTROUTING -o ${gateway_interface} -s 10.1.1.0/24 -j MASQUERADE
sudo iptables -A FORWARD -s 10.1.1.0/24 -j ACCEPT
sudo iptables -A FORWARD -d 10.1.1.0/24 -j ACCEPT
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
echo 1 | sudo tee /proc/sys/net/ipv4/conf/all/proxy_arp
!EOF

  sudo chmod a+rx ~/MAINFRAME/ubuntu/network.sh

}

##
# main
#

descarga_iso_ubuntu_para_s390
prepare_dir_structure
crea_hercules_cnf
crea_network_script

##
# iniciar hercules:
#
# bash -x ~/MAINFRAME/ubuntu/network.sh
# pushd ~/MAINFRAME/ubuntu/ ; sudo hercules -f hercules.cnf ; popd
