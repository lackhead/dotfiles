# 
# SCI specific configurations
#
if string match -q "*sci.utah.edu" (hostname -f)

    # use root's GPG config
    if fish_is_root_user
        set -gx GNUPGHOME /root/.gnupg
    end
    
    # babylon host specific
    if test (hostname) = "babylon" && not fish_is_root_user
        # Assuming kch is a custom function for ssh-agent
        kch
    end
    
    # SCI specific paths
    for dir in /sci-it/{s,}bin /sci-it/ansible/{s,}bin
        if test -d $dir
            fish_add_path --path $dir
        end
    end

end
