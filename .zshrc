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
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense


########################
# Command Line Editing #
########################
# emacs style
bindkey -e


###########
# HISTORY #
###########
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
# Append history as commands are executed
setopt inc_append_history
# Don't save duplicates
setopt hist_ignore_all_dups
# Share history between terminals
setopt share_history


##################
# Autocompletion #
##################
# autoload -U compinit
# compinit -i
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

