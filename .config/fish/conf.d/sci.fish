# 
# SCI specific configurations
#
if string match -q "*sci.utah.edu" (hostname -f)

    # use root's GPG config
    if fish_is_root_user
        set -gx GNUPGHOME /root/.gnupg
    end
    
    # babylon host specific
    if test (hostname) = "babylon" 
       and not fish_is_root_user
       and status is-interactive
        # Assuming kch is a custom function for ssh-agent
        kch
    end
    
    # SCI specific paths
    for dir in /local/{,s}bin /sci-it/{s,}bin /local/ansible/{s,}bin
        if test -d $dir
            fish_add_path --path $dir
        end
    end

end
