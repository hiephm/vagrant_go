- Download/install vagrant, virtualbox
- Before clone this repository, make sure that "git config core.autocrlf false"
- vagrant plugin install vagrant-vbguest
- vagrant box add debian/jessie64
- Edit C:\Users\{username}\.vagrant.d\boxes\debian-VAGRANTSLASH-jessie64\8.5.2\virtualbox\include\_Vagrantfile
	==> type: "virtualbox"
- vagrant up
- vagrant vbguest --auto-reboot --do install
- vagrant provision

# Tips:
- Disable Keyboard Capture to use Windows Alt-Tab while in virtual machine