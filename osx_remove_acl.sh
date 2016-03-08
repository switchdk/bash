#!/usr/bin/env bash
# vim: filetype=sh


##### modeline end #####
set -e
set -u 
set -o pipefail
IFS=$'\n\t'

readonly PROGNAME=$(basename $0)
readonly PROGDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )  # OSX
#readonly PROGDIR=$(dirname $(readlink -f ${BASH_SOURCE[0]})) # Linux
readonly ARGS=("$@")

##### All vars should be local #####
##### Everything is a function #####

function remove_acl() {

  # Useful for debug
  #echo $FUNCNAME $@

  local foldername="$1"
  chmod -R -N ${foldername}

}

main() {

  if [ ${#ARGS[@]} -gt 0 ]; then

    for f in "${ARGS[@]}"; do

      echo 'Removing ACLs on '${f}'...' && \
      remove_acl ${f} && \
      echo 'Removed ACLs on '${f} || \
      echo 'Failed to remove ACLs on '${f}

    done
  else

    echo 'Usage: ./'${PROGNAME}' folder1 folder2 folder3 ...'

  fi
}

# Run script
main
