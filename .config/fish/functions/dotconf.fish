function dotconf --wraps='git' --description 'personal dot file management with git'
   git --git-dir=$HOME/.dotconf/ --work-tree=$HOME $argv
end
