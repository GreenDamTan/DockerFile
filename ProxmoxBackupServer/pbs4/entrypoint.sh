#!/bin/bash

if [ ! -z "$root_password" ]; then
	printf 'define the password,do config password %s\n' "$root_password"
	echo "root:$root_password"|chpasswd
fi

if [ -z "$setting_ssh_port" ];
  then
    printf 'not define the ssh_port,do mask sshd \n'
    systemctl disable sshd
    systemctl mask sshd
  else
    printf 'define the ssh_port,do config ssh_port %s\n' "$setting_ssh_port"
    sed -i "s/.*Port.*/Port $setting_ssh_port/g" /etc/ssh/sshd_config
    sed -i "s/.*PasswordAuthentication.*/PasswordAuthentication yes/g" /etc/ssh/sshd_config
    sed -i "s/.*PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config
    systemctl enable sshd
fi

[ -f "/usr/bin/pve-fake-subscription" ] && /usr/bin/pve-fake-subscription

#User mapping
if [ -z $PUID ]; then export PUID=34; fi
if [ -z $PGID ]; then export PGID=34; fi
groupmod -o -g "$PGID" backup
usermod -o -u "$PUID" backup

#Fix perm
mkdir -p /etc/proxmox-backup
if [ ! -z $NO_PBS_FIXPERM ]; then
    echo "Skip fix perm"
else
    echo "Fix perm"
    chown -R backup:backup /etc/proxmox-backup
    chown -R backup:backup /var/lib/proxmox-backup
    chown -R backup:backup /var/log/proxmox-backup
    chown -R backup:backup /backups
    chmod -R 775 /etc/proxmox-backup
fi

if [ -z $PBS_ADMIN_PASSWORD ]; then export PBS_ADMIN_PASSWORD=admin; fi

#Add a user
if [ ! -f /etc/proxmox-backup/user.cfg ]; then
    proxmox-backup-manager user create admin@pbs --password $PBS_ADMIN_PASSWORD
    proxmox-backup-manager acl update / Admin --auth-id admin@pbs

    chown -R backup:backup /etc/proxmox-backup
fi

rm -f /etc/proxmox-backup/*.lock /etc/proxmox-backup/.*.lck

exec "$@"