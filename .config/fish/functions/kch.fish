# 
# ksh: get ssh-agent running via keychain and keys loaded
#

function kch 

    # Only run this if we aren't root
    fish_is_root_user && return 

    # make sure we have keychain
    if not type -q keychain
        echo "ERROR: keychain executable not found" >&2
        return -1
    end

    # Start agent if necessary 
    #  - keychain will find existing agent
    #  - no need for agent management on Mac
    if not test (command uname) = "Darwin" 
        set HOST (hostname -s)
        command keychain --host $HOST
        test -f ~/.keychain/$HOST-fish && source ~/.keychain/$HOST-fish
    end

    # Add any missing identity files
    set idlist (ssh-add -l) 
    for id in (sed 's/#.*//' $HOME/.ssh/config | grep IdentityFile | string trim | string split ' ' -f2)
        # get filename expansion
        set id (eval echo $id) 
        set -l fp (ssh-keygen -l -f $id)
        if not contains $fp $idlist 
            ssh-add $id
            # avoid duplicates
            set idlist (ssh-add -l) 
        end
    end

end
