#!/bin/bash
echo "Backup /etc/fstab..."
cp /etc/fstab /etc/fstab.backup
echo "Creating temp file..."
dd if=/dev/zero of=/tempfile bs=1024 count=1048576
mkfs.ext3 -jqF /tempfile
echo "Backup /tmp..."
mkdir /temp_tmp
mv /tmp/* /temp_tmp
echo "Mounting /tmp..."
mount -o loop,noexec,nosuid,rw /tempfile /tmp
chmod 1777 /tmp
echo "Restoring /tmp..."
mv /temp_tmp/* /tmp
rm -rf /temp_tmp
echo "Write to mount command to /etc/fstab..."
echo “/tempfile /tmp ext3 loop,rw,noexec,nosuid,nodev 0 0″ >> /etc/fstab
echo "Linking /var/tmp..."
rm -rf /var/tmp
link -s /tmp /var/tmp
echo "Done."