#!/usr/bin/env bash
# vim: filetype=sh


##### modeline end #####

##################################################################################################
### Inspired by Kfir Lavi - http://www.kfirlavi.com/blog/2012/11/14/defensive-bash-programming ###
### Inspired by Aaron Maxwell - http://redsymbol.net/articles/unofficial-bash-strict-mode      ###
##################################################################################################

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

temporary_files() {
    # Useful debug, does not work in OSX
    echo $FUNCNAME $@

    local dir=$1
    
    # to debug section
    set -x

    ls $dir \
        | grep pid \
        | grep -v daemon

    #finish debug section
    set +x
}

main() {
    local files=$(temporary_files /tmp/)
}

# Run script
main
