# 
# pyenv setup
# 
if test -d "$HOME/.pyenv" && not fish_is_root_user
    set -Ux PYENV_ROOT $HOME/.pyenv
    if test -d "$PYENV_ROOT/bin"
        fish_add_path --path --prepend "$PYENV_ROOT/bin"
    end
    pyenv init - fish | source
end
