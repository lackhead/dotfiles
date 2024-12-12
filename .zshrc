####################################################
#                                                  #
# This is Chad Lake's .zshrc file:                 #
#                                                  #
# This file is executed by every interactive shell #
# e.g.: options, key bindings, etc                 #
#                                                  #
####################################################

# Profiling (also see EOF)
# zmodload zsh/zprof

##############################################
# Set up environment (variables and options) #
##############################################
setopt nonomatch       # hide error message if there is no match for the pattern
setopt notify          # report the status of background jobs immediately
setopt numericglobsort # sort filenames numerically when it makes sense
setopt magicequalsubst # enable filename expansion for arguments of the form
# ‘anything=expression’
bindkey -e                           # emacs keybindings
bindkey '^p' history-search-backward # Helpful when searching through history
bindkey '^n' history-search-forward
export LESS="-qeRiFX" # Make less case-insensitive
for ed in subl nvim vim vi; do
    if type $ed &>/dev/null; then
        export EDITOR=$(which $ed)
        break
    fi
done
# On Ubuntu systems, setting this variable will skip the automatic compinit
# load (in /etc/zsh/zshrc).  While this means we will have to do so our own
# damn self, it does mean that we can do so with the -u flag to skip insecure
# directory checks when using sudo (it will complain that /home/clake is not
# owned by root!). So, deal with this ourselves so that the right thing can
# be done
skip_global_compinit=1

##############
# PATH stuff #
##############
# Set up fpath
for fdir in ${HOME}/.zsh_functions; do
    if [[ -d ${fdir} ]]; then
        fpath=(${fdir} "${fpath[@]}")
        # Autoload shell functions with the executable bit on.
        for func in ${fdir}/*(N-.x:t); do
            unhash -f $func 2>/dev/null
            autoload -Uz $func
        done
    fi
done
# Set up path
for dir in /usr/local/{s,}bin /opt/homebrew/bin ~/bin; do
    if [[ -d $dir ]]; then
        pathmunge $dir before
    fi
done

################
# prompt stuff #
################
# Enable substitution in the prompt.
setopt prompt_subst
# enable colors in the prompt
autoload -U colors && colors
# Prompt definition
export PS1='
%(!.%F{red}[ROOT.%F{blue}[)@%m]%f $( git_info )
%F{#fab387}%(3~;../;)%2~ %F{#cdd6f4}%(!.#.>)%f '
export PS2='%F{#cdd6f4}%_>%f '

###########
# Aliases #
###########
# this is for managing my dotfiles; see https://github.com/lackhead/dotfiles
alias dotconf='/usr/bin/git --git-dir=${HOME}/.dotconf/ --work-tree=${HOME}'
alias pwds='gpg --decrypt ~clake/private/passes.gpg | less'
alias rm='rm -i'
alias dig='dig +search +noall +answer $*'
alias ls='ls --color -Fh'
if type bat &>/dev/null; then
    alias cat='bat'
    BAT_THEME="Solarized (dark)"
fi
type thefuck &>/dev/null && eval $(thefuck --alias)
type fdfind &>/dev/null && alias find=fdfind
type fd &>/dev/null && alias find=fd

###########
# HISTORY #
###########
# When sudo'ing, keep all the history in root's .zsh_history file
if [[ $UID == 0 || $EUID == 0 ]]; then
    export HISTFILE=/root/.zsh_history
else
    export HISTFILE=~/.zsh_history
fi
export HISTSIZE=100000    # number of commands to keep in memory (for use by zsh)
export SAVEHIST=100000    # number of commands to keep in the HISTFILE
setopt INC_APPEND_HISTORY # Append history as commands are executed, not when shell exits
setopt EXTENDED_HISTORY   # Write the history file in the ':start:elapsed;command' format.
# setopt SHARE_HISTORY             	# Share history between all sessions.
setopt HIST_IGNORE_DUPS  # Don't enter into history if it duplicates the previous command
setopt HIST_FIND_NO_DUPS # Do not display a previously found event.
setopt HIST_VERIFY       # Do not execute immediately upon history expansion.
setopt APPEND_HISTORY    # append to history file

##################
# Autocompletion #
##################
autoload -U compinit
compinit -C
_comp_options+=(globdots) # match against hidden files
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
# zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false

# Turn off menu if we have fzf
if type fzf &>/dev/null 2>&1; then
    # preview directory's content with eza when completing cd
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
    # NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
    zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
    # To make fzf-tab follow FZF_DEFAULT_OPTS.
    # NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
    zstyle ':fzf-tab:*' use-fzf-default-opts yes
    # switch group using `<` and `>`
    zstyle ':fzf-tab:*' switch-group '<' '>'
    zstyle ':completion:*' menu no
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color -F $realpath'
fi

###########
# Plugins #
###########
if type fzf &>/dev/null 2>&1; then
    zsh_add_plugin "Aloxaf/fzf-tab"
fi
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"

##########
# zoxide #
##########
# use Zoxide for cd if it exists
if type zoxide &>/dev/null; then
    # reset the db if root (particularly in NFS-mounted home dirs)
    if [ "$EUID" = "0" ]; then
        export _ZO_DATA_DIR="/root/.local/share/zoxide"
    fi
    eval "$(zoxide init --cmd cd zsh)"
fi

#######
# FZF #
#######
# integrate with fzf if it exists
if type fzf &>/dev/null; then
    eval "$(fzf --zsh)"
    if type rg &>/dev/null; then
        # use ripgrep
        export FZF_DEFAULT_COMMAND='rg --files --hidden'
    fi
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
if [[ $(hostname -f) == *".sci.utah.edu" ]]; then

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
