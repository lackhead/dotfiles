#########################################
#                                       #
# This is Chad Lake's .zshenv file:     #
#                                       #
# This file is executed by every shell  #
# e.g.: aliases, path, env variables    #
#                                       #
#########################################




##############################################
# Set up environment (variables and options) #
##############################################
# Make less case-insensitive
export LESS="-qeRiFX"
# enable filename expansion for arguments of the form ‘anything=expression’
setopt magicequalsubst



###########
# Aliases #
###########
alias pwds='gpg --decrypt ~clake/private/passes.gpg | less'
alias h='history'
alias rm='rm -i'
alias dig='dig +search +noall +answer $*'
alias ls='ls -F'
alias git_branch='(command git symbolic-ref -q HEAD || command git name-rev --name-only --no-undefined --always HEAD) 2>/dev/null'
# Mac specific stuff
if [[ $(uname -s) == "Darwin" ]]; then
    alias ls='ls -FG'
    alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
    alias update_mac_software='/usr/bin/sudo /usr/sbin/softwareupdate -ir --verbose'
    # let's use python3
    if [ -x /usr/local/bin/python3 ]; then
       alias python='/usr/local/bin/python3'
       alias py='/usr/local/bin/python3'
       alias pip='/usr/local/bin/pip3'
    fi
    # Flush DNS cache
    alias flushdns="dscacheutil -flushcache"
    # Recursively delete `.DS_Store` files
    alias cleanup_dsstore="find . -name '*.DS_Store' -type f -ls -delete"
fi
# not an alias, but we're overriding a builtin so it makes sense to put it here
function cd () {
  builtin cd "$@" && ls
}
# Dotfile configs- see http://www.github.com/lackhead/dotfiles for more info
alias dotconf='/usr/bin/git --git-dir=${HOME}/.dotconf/ --work-tree=$HOME'



#############
# functions #
#############
#
# blogify - turn images into thumbnails
# 
blogify() {
   for file in $*; do
      /usr/bin/sips -Z 800 -s format jpeg $file --out ${file%.*}.TN.jpg
   done
}


#
# kch - get ssh-agent running
# NOTE: this isn't don't automatically as I don't want agents floating around 
#       everywhere- an agent will only be started specifically when I start one.
#       BUT- if I land on a host where an agent is running, it should connect 
#       automatically (hence, source the keychain file if it exists) 
# NOTE: include AddKeysToAgent in ~/.ssh/config to have them automatically added 
#       to the agent upon first use
#
kch() {
   # 
   # kch just starts up keychain if necessary and sources the ENVVAR file
   local keychain=$( type -p keychain | awk '{ print $NF }');
   ${keychain} --host ${HOST} 
   if [ -f ~/.keychain/${HOST}-sh ]; then
      source ~/.keychain/${HOST}-sh;
   fi 
}
# If an agent already exists, make sure every shell knows about it
if [ -f ~/.keychain/${HOST}-sh ]; then
   source ~/.keychain/${HOST}-sh;
fi


#
# pathmunge - add/remote a directory from PATH
# 
pathmunge() {
   #
   # pathmunge: add a new entry to the PATH variable
   #
   # Usage:
   #   pathmunge <dir> [before]
   #
   #      This appends <dir> to the path array; if a second argument exists and is the string "before"
   #      then <dir> is prepended instead of appended.
   #
   #   pathmunge -r <dir>
   #
   #      In this usage the directory is removed from the path if it exists.
   #

   # do we have anything to do?
   if [[ $# -eq 0 ]]; then
      return
   fi

   # Are we removing or not?
   if [[ $1 == "-r" ]]; then
      shift
      local remove=1
   fi

   # make sure directory exists and is not already in PATH
   # before adding it in.
   local dirtoadd=$1
   local position=$2
   if [[ -d $dirtoadd ]]; then

       # remove any previous occurrence of $dirtoadd
       path=("${(@)path:#${dirtoadd}}")

       # exit if that's all they wanted us to do
       if [[ $remove -eq 1 ]]; then
          return
       fi

       # add the new entry; note that I am using () expansion so that
       # any null entries are removed (possibly created in the line above)
       if [[ "$position" == "before" ]]; then
          path=($dirtoadd $path)
       else
          path=($path $dirtoadd)
       fi

       # de-dupe just in case
       typeset -gU path

   else

       echo "No such directory: $1"
       return 1

   fi
}




##############
# PATH stuff #
##############
# Note that Library/Python/3.6/bin is for homebrew installed python3 on MacOS
for dir in /usr/local/linkedin/bin /usr/local/{s,}bin ~/Library/Python/3.6/bin ~/bin; do
   if [[ -d $dir ]]; then
      pathmunge $dir before
   fi
done



