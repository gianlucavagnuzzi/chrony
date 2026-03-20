#!/bin/bash

set -x

: ${NTP_SERVER:="pool.ntp.org"}
: ${SYNC_RTC:="true"}
: ${ALLOW_CIDR:=""}

CONFIG=${CONFIG:-"/etc/chrony/chrony.conf"}

cat << EOF > "${CONFIG}"
pool ${NTP_SERVER} iburst
initstepslew 10 ${NTP_SERVER}
driftfile /var/lib/chrony/chrony.drift
cmdport 0
EOF

[ "${SYNC_RTC}" = "true" ] && echo "rtcsync" >> "${CONFIG}"
[ "${ALLOW_CIDR}" != "" ] && echo "allow ${ALLOW_CIDR}" >> "${CONFIG}"

# fix permission
chown chrony:chrony -R /var/lib/chrony /etc/chrony/chrony.conf
# remove previous pid file if it exist
[ -e /var/run/chrony/chronyd.pid ] && rm /var/run/chrony/chronyd.pid

custom_bashrc() {
cat <<'EOF'
export LS_OPTIONS="--color=auto"
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -la'
alias l='ls $LS_OPTIONS -lA'

# prompt SOLO per shell interattive
if [[ $- == *i* ]]; then
  if [ "$(id -u)" -eq 0 ]; then
    PS1="\[\e[35m\][\[\e[31m\]\u\[\e[36m\]@\[\e[32m\]\h\[\e[90m\] \w\[\e[35m\]]\[\e[0m\]# "
  else
    PS1="\[\e[35m\][\[\e[33m\]\u\[\e[36m\]@\[\e[32m\]\h\[\e[90m\] \w\[\e[35m\]]\[\e[0m\]$ "
  fi
  export PS1
fi
EOF
}

setup_bashrc() {
  for home in /root /home/*; do
    [ -d "$home" ] || continue
    bashrc="$home/.bashrc"

    # crea se manca
    [ -f "$bashrc" ] || touch "$bashrc"

    # evita duplicazioni
    grep -q '### CUSTOM BASHRC ###' "$bashrc" && continue

    {
      echo ''
      echo '### CUSTOM BASHRC ###'
      custom_bashrc
    } >> "$bashrc"
  done
}

setup_bashrc

# print cmd that will be executed
echo "Starting: $*" >&2

# launch CMD
exec "$@"
