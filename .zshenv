#########################################
#                                       #
# This is Chad Lake's .zshenv file:     #
#                                       #
# This file is executed by every shell  #
# e.g.: aliases, path, env variables    #
#                                       #
#########################################


##################################
# Skip Ubuntu's default compinit #
##################################
# On Ubuntu systems, setting this variable will skip the automatic compinit 
# load (in /etc/zsh/zshrc).  While this means we will have to do so our own
# damn self, it does mean that we can do so with the -u flag to skip insecure
# directory checks when using sudo (it will complain that /home/clake is not 
# owned by root!).  So, deal with this ourselves so that the right thing can 
# be done
skip_global_compinit=1



##############
# PATH stuff #
##############

# Set up fpath 
for fdir in ${HOME}/.zsh_functions; do
   if [[ -d ${fdir} ]]; then
      fpath=( ${fdir} "${fpath[@]}" )
      # Autoload shell functions with the executable bit on.
      for func in ${fdir}/*(N-.x:t); do
         unhash -f $func 2>/dev/null
         autoload -Uz  $func
      done
   fi
done

# Set up path 
for dir in /usr/local/{s,}bin /opt/homebrew/bin ~/bin ; do
   if [[ -d $dir ]]; then
      pathmunge $dir before
   fi
done
