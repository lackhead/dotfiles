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



################################
# Aliases and simple functions #
################################
# freload() - for all args, reload the autoloaded function
freload() { while (( $# )); do; unfunction $1; autoload -U $1; shift; done }
alias pwds='gpg --decrypt ~clake/private/passes.gpg | less'
alias h='history'
alias rm='rm -i'
alias dig='dig +search +noall +answer $*'
# get ls to be pretty
# Default ls 
alias ls='ls -Fh'
# Do we have GNU ls? 
if $(ls --group-directories-first /tmp  2>&1 >/dev/null); then
   alias ls='ls --group-directories-first -Fh'
else 
   # look for the coreutils version of ls
   if $(type -p gls 2>&1 >/dev/null); then
      alias ls='gls --group-directories-first -Fh'
   fi
fi
alias git_branch='(command git symbolic-ref -q HEAD || command git name-rev --name-only --no-undefined --always HEAD) 2>/dev/null'
# Mac specific stuff
if [[ $(uname -s) == "Darwin" ]]; then
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


##############
# PATH stuff #
##############
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

# 
# Set up path
#
for dir in /usr/local/{s,}bin /opt/homebrew/bin ~/bin ; do
   if [[ -d $dir ]]; then
      pathmunge $dir before
   fi
done

#
# Set up fpath
#
fpath=( ~/.zsh_functions "${fpath[@]}" )
if [[ -d "${HOME}/.zsh_functions" ]]; then
   # Autoload shell functions with the executable bit on.
   for func in ${HOME}/.zsh_functions/*(N-.x:t); do
      unhash -f $func 2>/dev/null
      autoload -Uz  $func
   done
fi

