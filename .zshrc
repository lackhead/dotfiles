####################################################
#                                                  #
# This is Chad Lake's .zshrc file:                 #
#                                                  #
# This file is executed by every interactive shell #
# e.g.: options, key bindings, etc                 #
#                                                  #
####################################################



###################
# General Options #
###################
setopt nonomatch           			# hide error message if there is no match for the pattern
setopt notify              			# report the status of background jobs immediately
setopt numericglobsort     			# sort filenames numerically when it makes sense


########################
# Command Line Editing #
########################
# emacs style
bindkey -e


###########
# HISTORY #
###########
# When sudo'ing, keep all the history in root's .zsh_history file
if [[ $UID == 0 || $EUID == 0 ]]; then
    export HISTFILE=/root/.zsh_history
else
    export HISTFILE=~/.zsh_history
fi
export HISTSIZE=10000			# number of commands to keep in memory (for use by zsh)
export SAVEHIST=100000			# number of commands to keep in the HISTFILE
setopt INC_APPEND_HISTORY		# Append history as commands are executed, not when shell exits
setopt HIST_IGNORE_ALL_DUPS		# Don't need to save duplicated commands
setopt EXTENDED_HISTORY          	# Write the history file in the ':start:elapsed;command' format.
# setopt SHARE_HISTORY             	# Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    	# Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          	# Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      	# Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         	# Do not display a previously found event.
setopt HIST_SAVE_NO_DUPS         	# Do not write a duplicate event to the history file.
setopt HIST_VERIFY              	# Do not execute immediately upon history expansion.
setopt APPEND_HISTORY            	# append to history file



##################
# Autocompletion #
##################
# autoload -U compinit
# compinit
# matches case insensitive for lowercase
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# pasting with tabs doesn't perform completion
# zstyle ':completion:*' insert-tab pending
# show completion menu when number of options is at least 2
# zstyle ':completion:*' menu select=2


################
# prompt stuff #
################
export PS1="[@%m] %(4~;../;)%3~:%(!.#.>) "

