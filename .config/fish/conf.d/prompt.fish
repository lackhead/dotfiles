# 
# prompt.fish: set the prompt
#
if status is-interactive

    function fish_prompt

        # configuration options
        set -gx fish_prompt_pwd_dir_length 2
        set -gx fish_prompt_pwd_full_dirs 2
        set -gx __fish_git_prompt_show_informative_status 1
        set -gx __fish_git_prompt_color $fish_color_host_remote

        # show any error code from previous command
        set -l last_status $status
        # Prompt status only if it's not 0
        set -l stat
        if test $last_status -ne 0
            echo (set_color $fish_color_error)"ERROR code: $last_status"(set_color normal)
        end

        # create space between commands
        echo

        # hostname and possibly git info
        set_color $fish_color_host
        printf "(fish) [@%s] " (prompt_hostname)
        set_color normal
        # git info
        echo (fish_git_prompt)
  
        # actual prompt depends on whether we're root or not
        if fish_is_root_user
            set_color $fish_color_error
            set prompt_char "#"
        else
            set_color $fish_color_end
            set prompt_char ">"
        end
        printf "%s %s " (prompt_pwd) $prompt_char
        set_color normal
    end

end
