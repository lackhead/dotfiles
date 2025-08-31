# 
# SCI specific configurations
#
if string match -q "*sci.utah.edu" (hostname -f)

    # A couple of rootly things
    if fish_is_root_user
        set -gx GNUPGHOME /root/.gnupg
        if test (hostname) = "babylon"
           eval ( /local/ansible/bin/ansible-agent -i )
        end 
    end
    
    # load my agent on babylon if appropriate
    if test (hostname) = "babylon" 
       and not fish_is_root_user
       and status is-interactive
        # Assuming kch is a custom function for ssh-agent
        kch
    end
    
    # SCI specific paths
    for dir in /local/{,s}bin /sci-it/{s,}bin /local/ansible/{s,}bin
        if test -d $dir
            fish_add_path --global $dir
        end
    end

    # Ansible
    set ANSIBLE_KEEP_REMOTE_FILES 0
    set ANSIBLE_REMOTE_TMP_CLEANUP yes
    set ANSIBLE_LOCAL_TMP /tmp/ansible-local
   
end
