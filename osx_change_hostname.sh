#!/usr/bin/env bash
# vim: filetype=sh


##### modeline end #####
set -e
set -u 
set -o pipefail
IFS=$'\n\t'

readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink $(pwd))  # OSX
readonly ARGS=("$@")

function change_hostname() {

  # Useful for debug
  #echo $FUNCNAME $@

  local newname="$1"
  sudo scutil --set ComputerName "$newname"
  sudo scutil --set LocalHostName "$newname"
  sudo scutil --set HostName "$newname"
  dscacheutil -flushcache
  sudo shutdown -r +2 'Computer will be rebooted for new hostname to take effect'

}

function usage() {

  # Useful for debug
  #echo $FUNCNAME $@

  echo 'Usage: ./'${PROGNAME}' newhostname'
  exit 1

}

function main() {

  echo 'You will prompted for your sudo password'
  echo 'The computer will be rebooted once the change is complete.'
  read -p 'Do you wish to continue (y/n):' prompt

  if [ "${prompt}" == "y" ]; then

    if [ ${#ARGS[@]} -eq 1 ]; then
      change_hostname ${ARGS[0]} 
    else
      usage
    fi

  else
    echo 'Exiting...'
    exit 0
  fi
}

# Run script
main
