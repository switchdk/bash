#!/usr/bin/env bash
# vim: filetype=sh



######## Many of the settings are inspired by cyberciti.biz #########

# History settings
HISTCONTROL=ignoreboth
HISTIGNORE="reboot:shutdown *:ls:pwd:exit:mount:man *:history"
shopt -s histappend
shopt -s cmdhist
export HISTSIZE=1000
export HISTFILESIZE=2000
export HISTTIMEFORMAT="%F %T "

# Shell settings
shopt -s checkwinsize
shopt -s extglob
shopt -s cdspell

# Add git branch support
source ~/bin/git-prompt.sh
export PS1="\[\033[0;37m\]\342\224\214\342\224\200$([[ $? != 0 ]] && echo "[\[\033[0;31m\]\342\234\227\[\033[0;37m\]]\342\224\200")[\[\033[0;33m\]\u\[\033[0;37m\]@\[\033[0;96m\]\h\[\033[0;37m\]]\342\224\200[\[\033[0;32m\]\w\[\033[0;37m\]]\[\033[0;35m\]\$(__git_ps1)\n\[\033[0;37m\]\342\224\224\342\224\200\342\224\200\342\225\274 \[\033[0m\]"

# Make the shell colourful
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Setup PATH
export PATH=$PATH:~/bin:~/.npm-global/bin:/usr/local/sbin

# Add NPM path to avoid permission issues
export NODE_PATH=$NODE_PATH:~/.npm-global/lib/node_modules

# Useful aliases
alias ls='ls -GFh'
alias ll='ls -laGFh'
alias top='top -o cpu'
alias filetree="ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/ /' -e 's/-/|/'"

# OSX Aliases
alias macvim='open -a macvim'
alias atom='open -a atom'
alias macdown='open -a macdown'
alias source_ansible2='source ~/bin/virtualenv-py/ansible2/bin/activate'
alias source_ansible194='source ~/bin/virtualenv-py/ansible194/bin/activate'

# Useful sources
if [ -d ~/Development-Ext/git-subrepo ]; then
  source $(dirname ~/Development-Ext/git-subrepo)/git-subrepo/.rc
fi

if [ -f /usr/local/Cellar/bash-completion/1.3/etc/bash_completion ]; then
  source /usr/local/Cellar/bash-completion/1.3/etc/bash_completion
fi

# Useful functions
function git-lazy-commit() {
  if [ -n "$1" ]; then
    git add .
    git commit --all -m "$1"
    git push
  else
    echo Error: Provide a commit message
  fi
}

function git-print() {
  git log --oneline --graph --decorate
}

function git-reset-upstream() {
  git reset --hard @{u}
}

function git-reset-hard-prev-commit() {
  git reset --hard HEAD~1
}

# Show top 10 history command on screen 
function ht {
  history | awk '{a[$4]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head
}
 
# Wrapper for host and ping command
# Accept http:// or https:// or ftps:// names for domain and hostnames
_getdomainnameonly(){
	
  local h="$1"
	#local f="${h,,}" # Requires modern version of bash (v 4.x) - upper case to lower case substition
	local f="$(echo $h | tr [[:upper:]] [[:lower:]])" # Works on OSX with bash 3.x

	# remove protocol part of hostname
  f="${f#http://}"
  f="${f#https://}"
	f="${f#ftp://}"
	f="${f#scp://}"
	f="${f#scp://}"
	f="${f#sftp://}"
	
  # remove username and/or username:password part of hostname
	f="${f#*:*@}"
	f="${f#*@}"
	
  # remove all /foo/xyz.html*  
	f=${f%%/*}
	
  # show domain name only
	echo "$f"
}
 
ping(){
	
  local array=( $@ )  		# get all args in an array
	local len=${#array[@]}          # find the length of an array
	local host=${array[$len-1]}     # get the last arg
	local args=${array[@]:0:$len-1} # get all args before the last arg in $@ in an array 
	local _ping="/sbin/ping"
	local c=$(_getdomainnameonly "$host")
	[ "$t" != "$c" ] && echo "Sending ICMP ECHO_REQUEST to \"$c\"..."
	# pass args and host
	$_ping $args $c

}
 
host(){

  local array=( $@ )
	local len=${#array[@]}
	local host=${array[$len-1]}
	local args=${array[@]:0:$len-1}
	local _host="/usr/bin/host"
	local c=$(_getdomainnameonly "$host")
	[ "$t" != "$c" ] && echo "Performing DNS lookups for \"$c\"..."
  	$_host $args $c
}

# Useful OpenSSL functions
function openssl-view-certificate-pem () {
    openssl x509 -text -noout -in "${1}" -inform PEM
}

function openssl-view-certificate-der () {
    openssl x509 -text -noout -in "${1}" -inform DER
}

function openssl-view-csr () {
    openssl req -text -noout -verify -in "${1}"
}

function openssl-view-key () {
    openssl rsa -check -in "${1}"
}

function openssl-view-pkcs12 () {
    openssl pkcs12 -info -in "${1}"
}

# Connecting to a server (Ctrl C exits)
function openssl-client () {
    openssl s_client -status -connect "${1}":443
}

# Convert PEM private key, PEM certificate and PEM CA certificate (used by nginx, Apache, and other openssl apps) to a PKCS12 file (typically for use with Windows or Tomcat)
function openssl-convert-pem-to-p12 () {
    openssl pkcs12 -export -inkey "${1}" -in "${2}" -certfile ${3} -out ${4}
}

# Convert a PKCS12 file to PEM
function openssl-convert-p12-to-pem () {
    openssl pkcs12 -nodes -in "${1}" -out "${2}"
}

# Check the modulus of a certificate (to see if it matches a key)
function openssl-check-certificate-modulus {
    openssl x509 -noout -modulus -in "${1}" | shasum -a 256
}

# Check the modulus of a key (to see if it matches a certificate)
function openssl-check-key-modulus {
    openssl rsa -noout -modulus -in "${1}" | shasum -a 256
}

# Check the modulus of a certificate request
function openssl-check-key-modulus {
    openssl req -noout -modulus -in "${1}" | shasum -a 256
}

# Encrypt a file (because zip crypto isn't secure)
function openssl-encrypt () {
    openssl aes-256-cbc -in "${1}" -out "${2}"
}

# Decrypt a file
function openssl-decrypt () {
    openssl aes-256-cbc -d -in "${1}" -out "${2}"
}
