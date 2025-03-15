# Simple git alias
function gstat --wraps git --description 'alias gstat=git status'
    git status $argv
end  
