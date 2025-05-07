if status is-interactive
   and test -d ~/.pyenv
   fish_add_path -p -m ~/.pyenv
   source (pyenv init --path | psub)
end
