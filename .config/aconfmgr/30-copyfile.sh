CopyFile /boot/loader/entries/arch.conf 755
CopyFile /boot/loader/loader.conf 755

CopyFile /etc/amdgpu-fan.yml
CopyFile /etc/aurto/trusted-users 640 shane
CopyFile /etc/conf.d/lm_sensors
CopyFile /etc/default/amdgpu-custom-state.card1
CopyFile /etc/default/earlyoom
CopyFile /etc/greetd/config.toml
CopyFile /etc/locale.conf
CopyFile /etc/pacman.conf
CopyFile /etc/pacman.d/archrepo 755
CopyFile /etc/pacman.d/mirrorlist
CopyFile /etc/pam.d/greetd
CopyFile /etc/sysctl.d/80-gamecompatibility.conf
CopyFile /etc/vconsole.conf

CopyFile /usr/local/bin/sxiv 755
CopyFile /usr/local/man/man1/sxiv.1
CopyFile /usr/local/share/sxiv/exec/image-info 755
CopyFile /usr/local/share/sxiv/exec/key-handler 755

# Specify locales
f="$(GetPackageOriginalFile glibc /etc/locale.gen)"
sed -i 's/^#\(en_GB.UTF-8\)/\1/g' "${f}"

# setup mkinitcpio hooks
f="$(GetPackageOriginalFile mkinitcpio /etc/mkinitcpio.conf)"
mkinitcpio_hooks='HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block filesystems resume fsck)'
sed -i "s/^HOOKS=.*/${mkinitcpio_hooks}/g" "${f}"
