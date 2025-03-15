# Simple git alias
function gcomm --wraps git --description 'alias gcomm=git commit'
    git commit $argv
end  
