# 
# prompt.fish: set the prompt
#

# Nothing to do if this isn't interactive
if not status is-interactive
    return
end

function fish_prompt --description 'Write out the prompt'

    # generic options
    set -gx fish_prompt_pwd_dir_length 2
    set -gx fish_prompt_pwd_full_dirs 2
    # Disable default venv prompt prefix since we're handling it ourselves
    set -gx VIRTUAL_ENV_DISABLE_PROMPT 1

    # show any error code from previous command to wrap up the previous
    # command 
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status # Export for __fish_print_pipestatus.
    set -l status_color (set_color $fish_color_status)
    set -l statusb_color (set_color --bold $fish_color_status)
    set -l status_prompt (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)
    # print out the prompt ensuring 1 blank line before the next prompt
    echo $status_prompt
    [ -n "$status_prompt" ] && echo 

    # define how things should look in the main prompt
    set -l prompt_suffix '>'
    set -l prompt_hostline_user "$USER"
    test "$USER" = "clake" && set -l prompt_hostline_user ""
    set -l prompt_hostline_color $fish_color_host
    set -l prompt_username_color $fish_color_host_remote
    set -l prompt_pathline_color $fish_color_cwd
    set -q fish_color_status
       or set -g fish_color_status red
    # root gets things a bit differently
    if fish_is_root_user
        set prompt_suffix '#'
        set prompt_hostline_user "ROOT"
        set prompt_username_color $fish_color_error
    end

    # show hostname
    set_color $prompt_hostline_color
    printf "["
    set_color $prompt_username_color
    printf $prompt_hostline_user 
    set_color $prompt_hostline_color
    printf "@%s]" (prompt_hostname)
    set_color normal

    # show venv indicator if active
    if set -q VIRTUAL_ENV
       set_color $fish_color_comment
       printf " (venv)"
    end
    set_color normal

    # show possibly git info
    set -gx __fish_git_prompt_show_informative_status 1
    set -gx __fish_git_prompt_color $fish_color_host_remote
    echo (fish_git_prompt)

    # show path and suffix 
    set_color $prompt_pathline_color
    printf "%s %s " (prompt_pwd) $prompt_suffix
    set_color normal

end

