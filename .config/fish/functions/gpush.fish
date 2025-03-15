# Simple git alias
function gpush --wraps git --description 'alias gpush=git commit'
    git push $argv
end  
