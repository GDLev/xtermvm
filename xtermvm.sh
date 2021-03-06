echo "#################################################"
echo "#  xTerm terminal for Proxmox VMs               #"
echo "#  https://github.com/GDLev/xtermvm             #"
echo "#                                               #"
echo "#  Requirements:                                #"
echo "#  - QEMU Guest agent (on VM)                   #"
echo "#  - Serial port 0 (on VM)                      #"
echo "#  - Linux OS                                   #"
echo "#################################################"
echo ""
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
read -p "The proxmox panel needs to be restarted. Do it now? (y/n): " agree_a
if test "$agree_a" = "y"
then
     reboot
fi
