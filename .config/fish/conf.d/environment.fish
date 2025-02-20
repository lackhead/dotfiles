# 
# environment.fish: set environment variables
#

# less options
set -x LESS "-qeRiFX"

# default editor
for ed in subl nvim vim vi
    if type -q $ed
        set -gx EDITOR (command -v $ed)
        break
    end
end

# use rg for fzf if installed
if type -q rg
    set -x FZF_DEFAULT_COMMAND 'rg --files --hidden'
end

# What is the default pager
set -gx PAGER less
for pager in bat batcat
    if type -q $pager
        set -gx PAGER (command -v $pager) -p
        break
    end
end

# bat isn't always bat but damn well should be
if not command -q bat && command -q batcat
    abbr --position command bat batcat
end

# set up pyenv
if type -q pyenv
   pyenv init - fish | source
end
