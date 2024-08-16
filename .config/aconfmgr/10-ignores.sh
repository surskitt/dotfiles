#!/usr/bin/env bash

IgnorePath '/lost+found'

IgnorePathsExcept /boot \
    loader/loader.conf \
    loader/entries/arch.conf

IgnorePath '/etc/.pwd.lock'
IgnorePath '/etc/.updated'
IgnorePath '/etc/adjtime' # hardware clock settings, written by hwclock
IgnorePath '/etc/ca-certificates/*'
IgnorePath '/etc/fonts/conf.d' # change to IgnorePathExcept if any configs are added
IgnorePath '/etc/fstab' # mountpoints
IgnorePath '/etc/group*' # groups
IgnorePath '/etc/gshadow*' # groups
IgnorePath '/etc/hostname'
IgnorePath '/etc/ld.so.cache'
IgnorePath '/etc/machine-id'
IgnorePath '/etc/mkinitcpio.d/linux.preset'
IgnorePath '/etc/os-release'
IgnorePath '/etc/passwd*'
IgnorePath '/etc/shadow*'
IgnorePath '/etc/shells'
IgnorePath '/etc/ssl/*'
IgnorePath '/etc/subgid*'
IgnorePath '/etc/subuid*'
IgnorePath '/etc/sudoers.d/*'
IgnorePath '/etc/systemd/*' # enable systemd services with functions

IgnorePath '/usr/bin/groupmems'

IgnorePath '/usr/lib/*' # library files
IgnorePath '/usr/share/*.cache'
IgnorePath '/usr/share/glib-2.0/*'
IgnorePath '/usr/share/info/*'
IgnorePath '/usr/share/mime/*'
IgnorePath '/usr/share/vim/*'

IgnorePath '/var/.updated'
IgnorePath '/var/db/*'
IgnorePath '/var/lib/*' # systemd files
IgnorePath '/var/log/*' # log files
IgnorePath '/var/tmp/*'

IgnorePath '/var/lib/pacman/local/*' # package metadata
IgnorePath '/var/lib/pacman/sync/*.db' # repos
IgnorePath '/var/lib/pacman/sync/*.db.sig' # repo sigs
IgnorePath '/etc/pacman.d/gnupg/*' # pacman gnupg socket files
IgnorePath '/etc/pacman.d/mirrorlist' # pacman mirrors (automated with reflector)
