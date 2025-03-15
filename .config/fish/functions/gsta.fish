# Simple git alias
function gsta --wraps git --description 'alias gsta=git status'
    git status $argv
end  
