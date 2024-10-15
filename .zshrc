####################################################
#                                                  #
# This is Chad Lake's .zshrc file:                 #
#                                                  #
# This file is executed by every interactive shell #
# e.g.: options, key bindings, etc                 #
#                                                  #
####################################################



# Here are a few nice things to have installed, although this
# set up should hopefully do the right thing if they are not
# installed: 
#   bat          -- alias for cat
#   fd           -- a better find
#   fzf          -- tab completion 
#   git          -- for zinit installation
#   ripgrep      -- better grep, also used with fzf
#   thefuck      -- fixing past mistakes
#   zoxide       -- a better cd

# Profiling (also see EOF) 
# zmodload zsh/zprof



##############################################
# Set up environment (variables and options) #
##############################################
setopt nonomatch      			# hide error message if there is no match for the pattern
setopt notify          			# report the status of background jobs immediately
setopt numericglobsort 			# sort filenames numerically when it makes sense
setopt magicequalsubst                  # enable filename expansion for arguments of the form 
                                        # ‘anything=expression’
bindkey -e                              # emacs keybindings
bindkey '^p' history-search-backward    # Helpful when searching through history
bindkey '^n' history-search-forward
export LESS="-qeRiFX"                   # Make less case-insensitive
# integrate with fzf if it exists 
if type fzf &> /dev/null; then
   eval "$(fzf --zsh)"
   if type rg &> /dev/null; then
      # use ripgrep
      export FZF_DEFAULT_COMMAND='rg --files --hidden'
   fi
fi
VISUAL=$( command -v nvim 2>/dev/null \
             || command -v vim 2>/dev/null \
             || command -v vi )
# force LS_COLORS over ssh; iTerm2 and Solarized muck this up
[ ${+SSH_CLIENT} ] && export LS_COLORS="di=00;34:ln=00;35:so=00;32:pi=01;33:ex=00;31:bd=00;34"



<<<<<<< HEAD
##############
## Packages ##
##############
# This avoids a package manager, as they all seem to have issues
ZSH_PKGS_DIR="${HOME}/.zsh_pkgs"
=======
###########
## ZINIT ##
###########
# # # Main directory for zinit
# ZINIT_HOME="${HOME}/.zinit/zinit"
# # # Setup if necessary
# [ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
# [ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
# # # Load zinit
# source "${ZINIT_HOME}/zinit.zsh"
# # # remove zi as a zinit alias, as it squashes zi from zoxide
# unalias zi   		
# # # add in plugins
# type fzf &> /dev/null && zinit light Aloxaf/fzf-tab
# zinit light zsh-users/zsh-completions
# zinit light zsh-users/zsh-autosuggestions
>>>>>>> a7f9c1e (decluttering zshrc)

# fzf-tab (if fzf is installed)
if type fzf &> /dev/null; then
  if [ ! -d ${ZSH_PKGS_DIR}/fzf-tab ]; then
     mkdir -p ${ZSH_PKGS_DIR}/fzf-tab
     git clone https://github.com/Aloxaf/fzf-tab ${ZSH_PKGS_DIR}/fzf-tab
     # need to load this AFTER compinit- see later in this file 
  fi
fi

# zsh-completions
if [ ! -d ${ZSH_PKGS_DIR}/zsh-completions ]; then
   mkdir -p ${ZSH_PKGS_DIR}/zsh-completions
   git clone https://github.com/zsh-users/zsh-completions.git \
      ${ZSH_PKGS_DIR}/zsh-completions
fi
[ -d ${ZSH_PKGS_DIR}/zsh-completions ] \
   && fpath=(${ZSH_PKGS_DIR}/zsh-completions/src $fpath)

# zsh-autosuggestions
if [ ! -d ${ZSH_PKGS_DIR}/zsh-autosuggestions ]; then
   mkdir -p ${ZSH_PKGS_DIR}/zsh-autosuggestions
   git clone https://github.com/zsh-users/zsh-autosuggestions \
      ${ZSH_PKGS_DIR}/zsh-autosuggestions
fi
[ -f ${ZSH_PKGS_DIR}/zsh-autosuggestions/zsh-autosuggestions.zsh ] \
   &&source ${ZSH_PKGS_DIR}/zsh-autosuggestions/zsh-autosuggestions.zsh


################
# prompt stuff #
################
export PS1='%(!.%F{red}[ROOT.%F{blue}[)@%m]%f %F{#ff875f}%(3~;../;)%2~:%(!.#.>)%f '
export PS2='%F{#ff875f}%_>%f '



###########
# Aliases #
###########
alias pwds='gpg --decrypt ~clake/private/passes.gpg | less'
alias rm='rm -i'
alias dig='dig +search +noall +answer $*'
alias ls='ls --color -Fh'
if type bat &> /dev/null; then 
   alias cat='bat'
   BAT_THEME="Solarized (dark)"
elif type batcat &> /dev/null; then
   # bat is installed as batcat on Ubuntu...why?!?
   alias cat='batcat'
   BAT_THEME="Solarized (dark)"
fi
type thefuck &> /dev/null && eval $(thefuck --alias) 
type fdfind &> /dev/null && alias find=fdfind
type fd &> /dev/null && alias find=fd



###########
# HISTORY #
###########
# When sudo'ing, keep all the history in root's .zsh_history file
if [[ $UID == 0 || $EUID == 0 ]]; then
    export HISTFILE=/root/.zsh_history
else
    export HISTFILE=~/.zsh_history
fi
export HISTSIZE=100000			# number of commands to keep in memory (for use by zsh)
export SAVEHIST=100000			# number of commands to keep in the HISTFILE
setopt INC_APPEND_HISTORY		# Append history as commands are executed, not when shell exits
setopt EXTENDED_HISTORY          	# Write the history file in the ':start:elapsed;command' format.
# setopt SHARE_HISTORY             	# Share history between all sessions.
setopt HIST_IGNORE_DUPS                 # Don't enter into history if it duplicates the previous command
setopt HIST_FIND_NO_DUPS         	# Do not display a previously found event.
setopt HIST_VERIFY              	# Do not execute immediately upon history expansion.
setopt APPEND_HISTORY            	# append to history file



##################
# Autocompletion #
##################
autoload -Uz compinit
compinit -i

_comp_options+=(globdots)   # match against hidden files
# use arrow keys to navigate the menu
zstyle ':completion:*' menu select
# Order of operations for matching (exact matches, globs, fuzzy)
zstyle ':completion:*' completer _complete _extensions _approximate
# Use cache for commands
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${HOME}/.zcompcache"
# matching case insensitive - lower case also match upper case
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending
# // gets expanded to /
zstyle ':completion:*' squeeze-slashes true
# Colors
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# if we have fzf
if type fzf &> /dev/null 2>&1; then
   # load the fzf-tab plugin, if it exists
   [ -f ${ZSH_PKGS_DIR}/fzf-tab/fzf-tab.plugin.zsh ] \
      && source ${ZSH_PKGS_DIR}/fzf-tab/fzf-tab.plugin.zsh
   zstyle ':completion:*' menu no
   zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color -F $realpath'
fi



##########
# zoxide #
##########
# use Zoxide for cd if it exists
# NOTE: this has to happen 
if type zoxide &> /dev/null; then

  # reset the db if root (particularly in NFS-mounted home dirs)
  if [ "$EUID" = "0" ]; then
     export _ZO_DATA_DIR="/root/.local/share/zoxide"
  fi

  eval "$(zoxide init --cmd cd zsh)"

fi



#######################
# Pyenv Configuration #
#######################
if [[ -d "$HOME/.pyenv" && $EUID != 0 ]]; then
   export PYENV_ROOT="$HOME/.pyenv"
   [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
   eval "$(pyenv init -)"
   # pyenv-virtualenv
   # eval "$(pyenv virtualenv-init -)"
fi



######################
# SCI Specific Stuff #
######################
if [[ $( hostname -f ) == *".sci.utah.edu" ]]; then

  # root has some GPG keys that get used
  if [[ $UID == 0 || $EUID == 0 ]]; then
      export GNUPGHOME=/root/.gnupg
  fi

  # babylon is my jump host (but only me)
  if [[ "$HOST" == "babylon" && "$EUID" != "0" ]]; then
     # load up ssh-agent
     kch
  fi

  # Get SCI specific directories
  for dir in /sci-it/{,s}bin /sci-it/ansible/bin; do
     if [[ -d $dir ]]; then
        pathmunge $dir before
     fi
  done

fi

# For accessing SCI from off campus
alias sci-ssh='ssh -A -J ssh://shell.sci.utah.edu:5522 $*'

<<<<<<< HEAD
=======


# Profiling (see top of file)
# zprof

>>>>>>> a7f9c1e (decluttering zshrc)
