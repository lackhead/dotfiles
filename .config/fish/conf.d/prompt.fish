# 
# prompt.fish: set the prompt
#
if status is-interactive

    function fish_prompt

        # show any error code from previous command
        set -l last_status $status
        # Prompt status only if it's not 0
        set -l stat
        if test $last_status -ne 0
            echo (set_color $fish_color_error)"ERROR code: $last_status"(set_color normal)
        end

        # create space between commands
        echo

        # hostname
        set_color $fish_color_host
        printf "(fish) [@%s]\n" (prompt_hostname)
  
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
