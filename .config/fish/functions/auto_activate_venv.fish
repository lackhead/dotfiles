function auto_activate_venv --on-variable PWD --description "Activate/deactivate python venvs" 

    # Check if we're currently in a venv
    if set -q VIRTUAL_ENV
        # Get the directory containing the venv
        set -l venv_dir (string replace -r '/venv$|/.venv$' '' $VIRTUAL_ENV)
        
        # If we've left the project directory, deactivate
        if not string match -q "$venv_dir*" $PWD
            deactivate
            return
        end
    end

    # Try to activate venv if we find one
    if test -f "venv/bin/activate.fish"
        source venv/bin/activate.fish
    else if test -f ".venv/bin/activate.fish"
        source .venv/bin/activate.fish
    end

end
