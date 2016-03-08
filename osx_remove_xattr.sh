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

function remove_xattr() {

  # Useful for debug
  #echo $FUNCNAME $@

  local foldername="$1"
  xattr -r -c ${foldername}
}

main() {

  if [ ${#ARGS[@]} -gt 0 ]; then

    for f in "${ARGS[@]}"; do

      echo 'Removing XATTRs on '${f}'...' && \
      remove_xattr ${f} && \
      echo 'Removed XATTRs on '${f} || \
      echo 'Failed to remove XATTRs on '${f}

    done

  else
    echo 'Usage: ./'${PROGNAME}' folder1 folder2 folder3 ...'
  fi
}

# Run script
main
