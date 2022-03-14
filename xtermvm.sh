echo 
"
#################################################
#  xTerm terminal for Proxmox VMs               #
#  By GDLev                                     #
#                                               #
#  Requirements:                                #
#  - QEMU Guest agent (on VM)                   #
#  - Serial port 0 (on VM)                      #
#  - Serial port 0 (on VM)                      #
#  - Linux OS                                   #
#################################################\n\n
"
read -p "please enter the ID of your virtual machine: " vm
echo "setting up serial socket..."
qm set $vm -serial0 socket
echo "setting up serial socket... Done"
echo "changing grub settings and serial ports..."
qm guest exec $vm -- sh -c 'echo 'GRUB_CMDLINE_LINUX="quiet console=tty0 console=ttyS0, 115200"' >> /etc/default/grub'
qm guest exec $vm -- update-grub
qm guest exec $vm -- systemctl enable serial-getty@ttyS0.service
qm guest exec $vm -- systemctl start serial-getty@ttyS0.service
echo "changing grub settings and serial ports... Done"
read -p "VM ($vm) reboot required! Do it now? (y/n): " agree
if test "$agree" = "y"
then
     qm guest exec $vm -- reboot
     echo "Done"
fi
echo "installation complete\n"
read -p "the introduced changes may not be visible until the proxmox panel is restarted. Do it now? (y/n): " agree_a
if test "$agree_a" = "y"
then
     qm guest exec $vm -- reboot
     echo "Done"
fi
