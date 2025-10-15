# 
# pyenv setup
# 
if test -d "$HOME/.pyenv" && not fish_is_root_user
    set -x PYENV_ROOT $HOME/.pyenv
    if test -d "$PYENV_ROOT/bin"
        fish_add_path --global --prepend "$PYENV_ROOT/bin"
    end
    pyenv init - fish | source
    set -x LD_LIBRARY_PATH $PYENV_ROOT/versions/(pyenv version-name)/lib $LD_LIBRARY_PATH
end
