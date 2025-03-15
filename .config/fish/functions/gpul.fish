# Simple git alias
function gcom --wraps git --description 'alias gcom=git commit'
    git commit $argv
end  
