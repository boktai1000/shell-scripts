#!/bin/bash
# Does the equivalent of sysprep for linux boxes to prepare them for cloning.
# Based on https://lonesysadmin.net/2013/03/26/preparing-linux-template-vms/

AUTHOR='AfroThundr'
BASENAME="${0##*/}"
MODIFIED='20181205'
VERSION='1.5.0'

# Argument handler
argument_handler() {
    [[ -n $1 ]] || {
        printf 'No arguments specified, use -h for help.\n'; exit 0; }

    while [[ -n $1 ]]; do
        if [[ $1 == -v ]]; then
            printf '%s: Version %s, updated %s by %s\n' \
                "$BASENAME" "$VERSION" "$MODIFIED" "$AUTHOR"
            shift
        elif [[ $1 == -h ]]; then
            printf 'Cloning preparation script for linux systems.\n\n'
            printf 'Usage: %s [-v] (-h | -y [-d] [-l <log_file>] [-s])\n\n' "$BASENAME"
            printf 'Options:\n'
            printf '  -h  Display this help text.\n'
            printf '  -d  Remove script on completion.\n'
            printf '  -l  Specify log file location.\n'
            printf '  -s  Shutdown on completion.\n'
            printf '  -v  Emit version header.\n'
            printf '  -y  Confirm sysprep.\n'
            exit 0
        elif [[ $1 == -d ]]; then
            DELETE=true
            shift
        elif [[ $1 == -l ]]; then
            shift
            LOGFILE=$1
            shift
        elif [[ $1 == -s ]]; then
            SHUTDOWN=true
            shift
        elif [[ $1 == -y ]]; then
            CONFIRM=true
            shift
        else
            printf 'Invalid argument specified, use -h for help.\n'
            exit 0
        fi
    done
}

say () {
    LOGFILE=${LOGFILE:=/var/log/sysprep.log}

    if [[ -n $LOGFILE && ! $LOGFILE == no ]]; then
        [[ -f $LOGFILE ]] || UMASK=027 touch "$LOGFILE"
        printf '%s: %s\n' "$(date -u +%FT%TZ)" "$@" | tee -a "$LOGFILE"
    else
        printf '%s: %s\n' "$(date -u +%FT%TZ)" "$@"
    fi
}

main() {
    argument_handler "$@"

    [[ $CONFIRM == true ]] || {
        say 'Confirm with -y to start sysprep.'; exit 0; }

    say 'Beginning sysprep.'

    if /bin/grep -E '(fedora|rhel|centos)' /etc/os-release &> /dev/null; then
        FEDORA_DERIV=true
    elif /bin/grep -E '(debian|ubuntu|mint)' /etc/os-release &> /dev/null; then
        DEBIAN_DERIV=true
    else
        say 'An unknown base linux distribution was detected.'
        say 'This script works with Debian and Fedora based distros.'
        exit 10
    fi

    say 'Stopping loging and auditing daemons.'
    /bin/systemctl stop rsyslog.service
    /usr/sbin/service auditd stop

    say 'Removing old kernels.'
    if [[ $FEDORA_DERIV == true ]]; then
        if command -v package-cleanup &> /dev/null; then
            /bin/package-cleanup -qy --oldkernels --count=1 &> /dev/null
        else
            /bin/yum install -qy yum-utils &> /dev/null &&
                /bin/package-cleanup -qy --oldkernels --count=1 &> /dev/null
        fi
    elif [[ $DEBIAN_DERIV == true ]]; then
        if command -v purge-old-kernels &> /dev/null; then
            /usr/bin/purge-old-kernels -qy --keep 1 &> /dev/null
        else
            /usr/bin/apt-get install -qy byobu &> /dev/null &&
                /usr/bin/purge-old-kernels -qy --keep 1 &> /dev/null
        fi
    fi

    say 'Clearing yum packages.'
    if [[ $FEDORA_DERIV == true ]]; then
        /usr/bin/yum clean all -q &> /dev/null
        /bin/rm -rf /var/cache/yum/*
    elif [[ $DEBIAN_DERIV == true ]]; then
        /usr/bin/apt clean &> /dev/null
        /bin/rm -rf /var/cache/apt/archives/*
    fi

    say 'Clearing old logs.'
    /usr/sbin/logrotate -f /etc/logrotate.conf
    /usr/bin/find /var/log -type f -regextype posix-extended -regex \
        ".*/*(-[0-9]{8}|.[0-9]|.gz)$" -delete
    /bin/rm -f /var/log/dmesg.old
    /bin/rm -f /var/log/anaconda/*

    say 'Clearing audit logs.'
    /bin/cat /dev/null > /var/log/audit/audit.log
    /bin/cat /dev/null > /var/log/wtmp
    /bin/cat /dev/null > /var/log/lastlog
    /bin/cat /dev/null > /var/log/grubby

    say 'Clearing udev persistent rules.'
    /bin/rm -f /etc/udev/rules.d/70*

    say 'Removing MACs/UUIDs from network sripts.'
    if [[ $FEDORA_DERIV == true ]]; then
        /bin/sed -i '/^(HWADDR|UUID)=/d' /etc/sysconfig/network-scripts/ifcfg-*
    elif [[ $DEBIAN_DERIV == true ]]; then
        /bin/sed -ri '/^(mac-address|uuid)=/d' /etc/NetworkManager/system-connections/*
    fi

    say 'Cleaning out temp directories.'
    /bin/rm -rf /tmp/*
    /bin/rm -rf /var/tmp/*

    say 'Removing SSH host keys.'
    /bin/rm -f /etc/ssh/*key*

    say 'Cleaning up root home directory.'
    unset HISTFILE
    /bin/rm -f /root/.bash_history
    /bin/rm -f /root/anaconda-ks.cfg
    /bin/rm -rf /root/.ssh/
    /bin/rm -rf /root/.gnupg/

    say 'Resetting hostname.'
    echo 'CHANGEME' > /etc/hostname

    say 'Regenerate hostname and ssh keys on reboot.'
    RCLOCAL=$(/bin/readlink -f /etc/rc.local)
    # shellcheck disable=SC2016
    /bin/grep DELETEME "$RCLOCAL" &> /dev/null || {
        [[ $DEBIAN_DERIV == true ]] && {
            /bin/sed -i 's/^exit 0/#exit 0/g' "$RCLOCAL"
            echo 'DELETEME=y dpkg-reconfigure openssh-server;' \
                'sed -i "s/^#exit 0/exit 0/g" "$0"' >> "$RCLOCAL"
        }
        echo 'echo "linux-$(' \
                'dd if=/dev/urandom |' \
                'tr -cd [:lower:][:digit:] |' \
                'dd bs=1 count=9' \
            ')" > /etc/hostname;' \
            'chmod -x "$0";' \
            'sed -i "/DELETEME/ d" "$0";' \
            'echo "Hostname changed, rebooting.";' \
            'init 6' >> "$RCLOCAL"
        /bin/chmod 0744 "$RCLOCAL"
    }

    [[ $DELETE == true ]] && {
        say 'Removing the sysprep script.'; /bin/rm -f "$0"; }

    [[ $SHUTDOWN == true ]] && {
        say 'Shutting down the system.'; /sbin/init 0; }

    say 'End of sysprep.'
    exit 0
}

# Only execute if not being sourced
[[ ${BASH_SOURCE[0]} == "$0" ]] && main "$@"
