# Simple git alias
function gadd --wraps git --description 'alias gadd=git add'
    git add $argv
end
