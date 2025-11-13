# 
# environment.fish: set environment variables
#

# less options
set -x LESS "-qeRiFX"

# default editor
for ed in nvim vim vi
    if type -q $ed
        set -x EDITOR (command -v $ed)
        set -x SYSTEMD_EDITOR (command -v $ed)
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
        set -x PAGER (command -v $pager) -p
        break
    end
end
