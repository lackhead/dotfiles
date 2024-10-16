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



################
# prompt stuff #
################
# Enable substitution in the prompt.
setopt prompt_subst
# enable colors in the prompt
autoload -U colors && colors 
# construct GIT information part of prompt, if in a repo
function git_info() {

  # Taken from Josh Dick w/ only cosmetic changes
  # https://joshdick.net/2017/06/08/my_git_prompt_for_zsh_revisited.html

  # Exit if not inside a Git repository
  ! git rev-parse --is-inside-work-tree > /dev/null 2>&1 && return

  # Git branch/tag, or name-rev if on detached head
  local GIT_LOCATION=${$(git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD)#(refs/heads/|tags/)}

  local AHEAD="%{$fg[red]%}⇡NUM%{$reset_color%}"
  local BEHIND="%{$fg[cyan]%}⇣NUM%{$reset_color%}"
  local MERGING="%{$fg[magenta]%}⚡︎%{$reset_color%}"
  local UNTRACKED="%{$fg[red]%}●%{$reset_color%}"
  local MODIFIED="%{$fg[yellow]%}●%{$reset_color%}"
  local STAGED="%{$fg[green]%}●%{$reset_color%}"

  local -a DIVERGENCES
  local -a FLAGS

  local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_AHEAD" -gt 0 ]; then
    DIVERGENCES+=( "${AHEAD//NUM/$NUM_AHEAD}" )
  fi

  local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_BEHIND" -gt 0 ]; then
    DIVERGENCES+=( "${BEHIND//NUM/$NUM_BEHIND}" )
  fi

  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
    FLAGS+=( "$MERGING" )
  fi

  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    FLAGS+=( "$UNTRACKED" )
  fi

  if ! git diff --quiet 2> /dev/null; then
    FLAGS+=( "$MODIFIED" )
  fi

  if ! git diff --cached --quiet 2> /dev/null; then
    FLAGS+=( "$STAGED" )
  fi

  local -a GIT_INFO
  # GIT_INFO+=( "\033[38;5;15m±" )
  GIT_INFO+=( "%F{#a6e3a1}($GIT_LOCATION)%{$reset_color%}" )
  [[ ${#DIVERGENCES[@]} -ne 0 ]] && GIT_INFO+=( "${(j::)DIVERGENCES}" )
  [[ ${#FLAGS[@]} -ne 0 ]] && GIT_INFO+=( "${(j::)FLAGS}" )
  echo "${(j: :)GIT_INFO}"

}
# Prompt definition
export PS1='
%(!.%F{red}[ROOT.%F{blue}[)@%m]%f $( git_info )
%F{#fab387}%(3~;../;)%2~ %F{#cdd6f4}%(!.#.>)%f '
export PS2='%F{#cdd6f4}%_>%f '



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
autoload -U compinit
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

# Turn off menu if we have fzf
if type fzf &> /dev/null 2>&1; then
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



# Profiling (see top of file)
# zprof

