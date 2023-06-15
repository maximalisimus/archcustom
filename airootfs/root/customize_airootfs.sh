#!/bin/bash

set -e -u

# Locale
sed -i 's/#\(ru_RU\.UTF-8\)/\1/' /etc/locale.gen
locale-gen
echo "LANG=ru_RU.UTF-8" > /etc/locale.conf
echo "LC_MESSAGES=ru_RU.UTF-8" >> /etc/locale.conf

# virtual console
echo "LOCALE=\"ru_RU.UTF-8\"" > /etc/vconsole.conf
echo "KEYMAP=\"ru\"" >> /etc/vconsole.conf
echo "FONT=\"cyr-sun16\"" >> /etc/vconsole.conf
echo "CONSOLEFONT=\"cyr-sun16\"" >> /etc/vconsole.conf
echo "USECOLOR=\"yes\"" >> /etc/vconsole.conf
echo "TIMEZONE=\"Europe/Moscow\"" >> /etc/vconsole.conf
echo "HARDWARECLOCK=\"UTC\"" >> /etc/vconsole.conf
echo "CONSOLEMAP=\"\"" >> /etc/vconsole.conf

# Time and clock
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
hwclock --systohc --utc

# hostname
echo "archcustom" > /etc/hostname

# root and live user
usermod -s /bin/bash root
cp -aT /etc/skel/ /root/
useradd -m -p "" -g users -G "adm,log,users,uucp,wheel,audio,games,disk,floppy,input,kvm,optical,scanner,storage,video,tty,utmp,network,rfkill,power" -s /bin/bash liveuser
#chmod 750 /etc/sudoers.d
mkdir -p /etc/sudoers.d/
touch /etc/sudoers.d/g_wheel
echo "root ALL=(ALL) ALL" > /etc/sudoers.d/g_wheel
echo "%wheel  ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/g_wheel
chmod 440 /etc/sudoers.d/g_wheel
chown -R liveuser:users /home/liveuser

# Uncomment mirrors and amend journald
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

# Enable services
systemctl enable choose-mirror.service
systemctl set-default multi-user.target

