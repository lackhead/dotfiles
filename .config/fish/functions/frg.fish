#
# frg: use ripgrep and fzf to quickly find/edit files
#
function frg --wraps rg --description "rg with fzf"

    if not command -q rg || not command -q fzf 
        echo "ERROR: one or more missing compents (rg, fzf)" && return 1
    end

    rg --ignore-case --color=always --line-number --no-heading $argv |
       fzf --ansi \
           --delimiter ':' \
           --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
           --bind "enter:become($EDITOR +{2} {1})"

end
