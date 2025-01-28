#
# ci() - a quick and curt wrapper for RCS's check in to make sure the 
#        proper username is recorded when sudo'd
#
function ci --wraps ci 

    set fish_trace on

    # make sure ci exists
    if not type -q -f ci
        echo "ERROR: ci executable not found" >&2 && return 1
    end 

    # just use the normal ci if we're not root
    if not fish_is_root_user && set -q $SUDO_USER
         command ci $argv && return $status
    end

    # If a -w<username> arg is already given, don't do anything. Otherwise
    # add in a flag to make sure the right username is included in the logs
    for arg in $argv
        if string match -r "^-w"
            # nothing to do 
            command ci $argv && return $status
        end
    end

    # Add the flag and go
    command ci "-w$SUDO_USER" $argv && return $status

end
