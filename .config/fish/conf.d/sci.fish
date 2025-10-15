# 
# SCI specific configurations
#
if string match -q "*sci.utah.edu" (hostname -f)

    # Some hosts get special treatment
    set admin_hosts babylon babs

    # A couple of rootly things
    if fish_is_root_user
        set -gx GNUPGHOME /root/.gnupg
        if contains (hostname) $admin_hosts 
            eval ( /local/ansible/bin/ansible-agent -i )
            if test $status -eq 0
                set_color $fish_color_error 2>/dev/null; or set_color red
                echo -n "[ROOT ANSIBLE AGENT] "
                set_color $fish_color_comment 2>/dev/null; or set_color green
                echo "loaded and ready for use"
                set_color normal
            else
                set_color $fish_color_error 2>/dev/null; or set_color red
                echo "[SUDO USER CONFIG] FAILED!"
            end
        end 
    end
    
    # load my agent on babylon if appropriate
    if contains (hostname) $admin_hosts
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
    if contains (hostname) $admin_hosts
        # these are only needed on hosts Ansible is run from 
        set -x ANSIBLE_KEEP_REMOTE_FILES 0
        set -x ANSIBLE_REMOTE_TMP_CLEANUP yes
        set -x ANSIBLE_LOCAL_TMP /tmp/ansible-local
    end
   
end
