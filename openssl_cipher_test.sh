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

function cipher_test() {

  local server="$1"
  local cipher="$2"
  local result=$(echo -n | \
                openssl s_client \
                -cipher "${cipher}" \
                -connect ${server} \
                2>&1)
  echo ${result}

}

main() {
  
  local server=${ARGS[0]}
  local port=${ARGS[1]}
  local delay=1

  echo Obtaining cipher list from $(openssl version)
  local ciphers=$(openssl ciphers 'ALL:eNULL' | sed -e 's/:/\
  /g')

  for cipher in ${ciphers[@]}; do

    echo -n Testing $cipher...
    local result=$(cipher_test ${server}:${port} ${cipher})

    if [[ "$result" =~ "Cipher is ${cipher}" || "$result" =~ "Cipher    :" ]] ; then
      echo YES
    elif [[ "$result" =~ ":error:" ]] ; then
      error=$(echo -n $result | cut -d':' -f6)
      echo NO \($error\)
    else
      echo UNKNOWN RESPONSE
      echo $result
    fi
  sleep ${delay}
  done

}

# Run script
main
