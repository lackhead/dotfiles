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
bindkey -e                           # emacs keybindings
bindkey '^p' history-search-backward # Helpful when searching through history
bindkey '^n' history-search-forward
export LESS="-qeRiFX" # Make less case-insensitive
# On Ubuntu systems, setting this variable will skip the automatic compinit
# load (in /etc/zsh/zshrc).  While this means we will have to do so our own
# damn self, it does mean that we can do so with the -u flag to skip insecure
# directory checks when using sudo (it will complain that /home/clake is not
# owned by root!). So, deal with this ourselves so that the right thing can
# be done
skip_global_compinit=1

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

fi

# For accessing SCI from off campus
alias sci-ssh='ssh -A -J ssh://shell.sci.utah.edu:5522 $*'

# Profiling (see top of file)
# zprof
