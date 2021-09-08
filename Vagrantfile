# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

HOSTNAME = "herc"

$msg = <<MSG
------------------------------------------------------
s390x on Hercules Simulator
------------------------------------------------------
MSG

#UBUNTU_ISO_FILENAME='ubuntu-18.04.1-server-s390x.iso'
#UBUNTU_ISO_URL='http://old-releases.ubuntu.com/releases/bionic/ubuntu-18.04.1-server-s390x.iso'

UBUNTU_ISO_FILENAME='ubuntu-18.04.2-server-s390x.iso'
UBUNTU_ISO_URL='http://old-releases.ubuntu.com/releases/bionic/ubuntu-18.04.2-server-s390x.iso'

#UBUNTU_ISO_FILENAME='ubuntu-18.04.5-server-s390x.iso'
#UBUNTU_ISO_URL='http://cdimage.ubuntu.com/releases/18.04/release/ubuntu-18.04.5-server-s390x.iso'



#UBUNTU_ISO_FILENAME='ubuntu-16.04-server-s390x.iso'
#UBUNTU_ISO_URL='https://old-releases.ubuntu.com/releases/xenial/ubuntu-16.04-server-s390x.iso'

#UBUNTU_ISO_FILENAME='ubuntu-16.04.1-server-s390x.iso'
#UBUNTU_ISO_URL='https://old-releases.ubuntu.com/releases/xenial/ubuntu-16.04.1-server-s390x.iso'

#UBUNTU_ISO_FILENAME='ubuntu-16.04.2-server-s390x.iso'
#UBUNTU_ISO_URL='https://old-releases.ubuntu.com/releases/xenial/ubuntu-16.04.2-server-s390x.iso'

#UBUNTU_ISO_FILENAME='ubuntu-16.04.3-server-s390x.iso'
#UBUNTU_ISO_URL='https://old-releases.ubuntu.com/releases/xenial/ubuntu-16.04.3-server-s390x.iso'

#UBUNTU_ISO_FILENAME='ubuntu-20.04.1-live-server-s390x.iso'
#UBUNTU_ISO_URL='https://old-releases.ubuntu.com/releases/focal/ubuntu-20.04.1-live-server-s390x.iso'


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  if Vagrant.has_plugin?("vagrant-hostmanager")
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.manage_guest = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true

    # uso cachier con NFS solamente si el hostmanager gestiona los nombres en /etc/hosts del host
    if Vagrant.has_plugin?("vagrant-cachier")

      config.cache.auto_detect = false
      # W: Download is performed unsandboxed as root as file '/var/cache/apt/archives/partial/xyz' couldn't be accessed by user '_apt'. - pkgAcquire::Run (13: Permission denied)

      config.cache.synced_folder_opts = {
        owner: "_apt"
      }

      # Configure cached packages to be shared between instances of the same base box.
      # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
      config.cache.scope = :box

      # OPTIONAL: If you are using VirtualBox, you might want to use that to enable
      # NFS for shared folders. This is also very useful for vagrant-libvirt if you
      # want bi-directional sync

      # NOTA: con encrypted HOME, no funciona el NFS, si no es tu caso, descomenta los parametros siguientes:
      #config.cache.synced_folder_opts = {
      #  type: :nfs,
      #  # The nolock option can be useful for an NFSv3 client that wants to avoid the
      #  # NLM sideband protocol. Without this option, apt-get might hang if it tries
      #  # to lock files needed for /var/cache/* operations. All of this can be avoided
      #  # by using NFSv4 everywhere. Please note that the tcp option is not the default.
      #  mount_options: ['rw', 'vers=3', 'tcp', 'nolock', 'fsc' , 'actimeo=2']
      #}

      # For more information please check http://docs.vagrantup.com/v2/synced-folders/basic_usage.html
   end

  end

 config.vm.post_up_message = $msg

 config.vm.define HOSTNAME do |srv|

    srv.vm.box = "ubuntu/focal64"

    srv.vm.network "private_network", ip: "192.168.44.11", name: 'vboxnet3', adapter: 2

    srv.vm.box_check_update = false
    srv.ssh.forward_agent = true
    srv.ssh.forward_x11 = true
    srv.vm.hostname = HOSTNAME

    if Vagrant.has_plugin?("vagrant-hostmanager")
      srv.hostmanager.aliases = %W(#{HOSTNAME+".virtual.ballardini.com.ar"} #{HOSTNAME} )
    end

    srv.vm.provider :virtualbox do |vb|
      vb.gui = false
      vb.cpus = 4
      vb.memory = "8192"

      # https://github.com/hashicorp/vagrant/issues/9524#issuecomment-385990711
      # Cuando el nombre de dirctorio mas nombre de machine tiene largo mayor a 64 caracteres
      vb.customize ["modifyvm", :id, "--audio", "none"]

      # set timesync parameters to keep the clocks better in sync
      # sync time every 10 seconds
      vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-interval", 10000 ]
      # adjustments if drift > 100 ms
      vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-min-adjust", 100 ]
      # sync time on restore
      vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-on-restore", 1 ]
      # sync time on start
      vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-start", 1 ]
      # at 1 second drift, the time will be set and not "smoothly" adjusted
      vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 1000 ]

      vb.customize ["modifyvm", :id, "--hostonlyadapter2", "vboxnet3"]  # eth1
      vb.customize ["modifyvm", :id, "--hostonlyadapter3", "vboxnet4"]  # eth2

      vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
      vb.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]

      # https://www.virtualbox.org/manual/ch08.html#vboxmanage-modifyvm mas parametros para personalizar en VB
    end
  end

    ##
    # Aprovisionamiento
    #
    config.vm.provision "fix-no-tty", type: "shell" do |s|  # http://foo-o-rama.com/vagrant--stdin-is-not-a-tty--fix.html
        s.privileged = false
        s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
    end
    config.vm.provision "ssh_pub_key", type: :shell do |s|
      begin
          ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip
          s.inline = <<-SHELL
            mkdir -p /root/.ssh/
            touch /root/.ssh/authorized_keys
            echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
            echo #{ssh_pub_key} >> /root/.ssh/authorized_keys
          SHELL
      rescue
          puts "No hay claves publicas en el HOME de su pc"
          s.inline = "echo OK sin claves publicas"
      end
    end

    config.vm.provision "actualiza", type: "shell" do |s|
        s.privileged = false
        s.inline = <<-SHELL
          export DEBIAN_FRONTEND=noninteractive
          export APT_LISTCHANGES_FRONTEND=none
          export APT_OPTIONS=' -y --allow-downgrades --allow-remove-essential --allow-change-held-packages -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold '

          sudo -E apt-get --purge remove apt-listchanges -y > /dev/null 2>&1
          sudo -E apt-get update -y -qq > /dev/null 2>&1
          sudo dpkg-reconfigure --frontend=noninteractive libc6 > /dev/null 2>&1
          [ $( lsb_release -is ) != "Debian" ] && sudo -E apt-get install linux-image-generic ${APT_OPTIONS}
          sudo -E apt-get upgrade ${APT_OPTIONS} > /dev/null 2>&1
          sudo -E apt-get dist-upgrade ${APT_OPTIONS} > /dev/null 2>&1
          sudo -E apt-get autoremove -y > /dev/null 2>&1
          sudo -E apt-get autoclean -y > /dev/null 2>&1
          sudo -E apt-get clean > /dev/null 2>&1

          sudo timedatectl set-ntp on
        SHELL
    end

    config.vm.provision :reload

    config.vm.provision "instala_hercules", type: "shell", privileged: false, path: "provision/instala-hercules.sh"
    config.vm.provision "prepara_ubuntu",   type: "shell", privileged: false, path: "provision/prepara-ubuntu-sobre-hercules.sh",  args: [ UBUNTU_ISO_FILENAME, UBUNTU_ISO_URL ]

    config.trigger.after :up, :reload do |trigger|
      trigger.info = "monta ISO Ubuntu para s390x"
      trigger.run_remote = {
        path: "provision/monta-iso.sh",
        args: [ UBUNTU_ISO_FILENAME ],
        privileged: false
      }
    end

end

