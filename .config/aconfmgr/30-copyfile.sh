CopyFile /boot/loader/entries/arch.conf 755
CopyFile /boot/loader/loader.conf 755
CopyFile /etc/locale.conf
CopyFile /etc/pacman.conf
CopyFile /etc/vconsole.conf

# Specify locales
f="$(GetPackageOriginalFile glibc /etc/locale.gen)"
sed -i 's/^#\(en_GB.UTF-8\)/\1/g' "${f}"

# setup mkinitcpio hooks
f="$(GetPackageOriginalFile mkinitcpio /etc/mkinitcpio.conf)"
mkinitcpio_hooks='HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block filesystems resume fsck)'
sed -i "s/^HOOKS=.*/${mkinitcpio_hooks}/g" "${f}"
