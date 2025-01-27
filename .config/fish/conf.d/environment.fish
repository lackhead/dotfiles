# 
# environment.fish: set environment variables
#

# less options
set -x LESS "-qeRiFX"

# default editor
for ed in subl nvim vim vi
    if type -q $ed
        set -x EDITOR (which $ed)
        break
    end
end

# use rg for fzf if installed
if type -q rg
    set -x FZF_DEFAULT_COMMAND 'rg --files --hidden'
end

