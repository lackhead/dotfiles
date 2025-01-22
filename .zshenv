####################################################
#                                                  #
# This is Chad Lake's .zshenv file:                #
#                                                  #
# This file is executed by every shell             #
#                                                  #
####################################################

##############################################
# Set up environment (variables and options) #
##############################################
setopt nonomatch       # hide error message if there is no match for the pattern
setopt notify          # report the status of background jobs immediately
setopt numericglobsort # sort filenames numerically when it makes sense
setopt magicequalsubst # enable filename expansion for arguments of the form
                       # ‘anything=expression’
for ed in subl nvim vim vi; do
    if type $ed &>/dev/null; then
        export EDITOR=$(which $ed)
        break
    fi
done

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

    # Get SCI specific directories
    for dir in /sci-it/{,s}bin /sci-it/ansible/bin; do
        if [[ -d $dir ]]; then
            pathmunge $dir before
        fi
    done

fi
