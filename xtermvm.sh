echo "please enter the ID of your virtual machine:"
read id

echo "setting up serial socket..."
qm set $id -serial0 socket
echo "setting up serial socket... Done"
echo "changing grub settings and serial ports..."
qm guest exec $id -- sh -c 'echo 'GRUB_CMDLINE_LINUX="quiet console=tty0 console=ttyS0, 115200"' >> /etc/default/grub'
qm guest exec $id -- update-grub
qm guest exec $id -- systemctl enable serial-getty@ttyS0.service
qm guest exec $id -- systemctl start serial-getty@ttyS0.service
echo "changing grub settings and serial ports... Done"
read -p "VM ($id) reboot required! Do it now? (y/n)" agree
if test "$agree" = "y"
then
     qm guest exec $id -- reboot
     echo "Done"
fi

echo "installation complete"
echo "the introduced changes may not be visible until the proxmox panel is restarted"
