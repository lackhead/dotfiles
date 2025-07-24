# 
# prompt.fish: set the prompt
#

# Nothing to do if this isn't interactive
if not status is-interactive
    return
end

function fish_prompt --description 'Write out the prompt'

    # configuration options
    set -gx fish_prompt_pwd_dir_length 2
    set -gx fish_prompt_pwd_full_dirs 2

    # show any error code from previous command
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status # Export for __fish_print_pipestatus.
    set -l status_color (set_color $fish_color_status)
    set -l statusb_color (set_color --bold $fish_color_status)
    set -l status_prompt (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)
    # print out the prompt ensuring 1 blank line before the next prompt
    echo $status_prompt
    [ -n "$status_prompt" ] && echo 

    # define how things should look
    set -l prompt_suffix '>'
    set -l prompt_hostline_color $fish_color_host
    set -l prompt_hostline_user ""
    set -l prompt_pathline_color $fish_color_end
    # root gets things a bit differently
    if functions -q fish_is_root_user; and fish_is_root_user
        set prompt_suffix '#'
        set prompt_hostline_color (set_color --bold $fish_color_status)
        set prompt_hostline_user "ROOT"
        set prompt_pathline_color $fish_color_error
    end

    ## DO IT
    # hostname
    set_color $prompt_hostline_color
    printf "[%s@%s] " $prompt_hostline_user (prompt_hostname)
    set_color normal
    # possibly git info
    set -gx __fish_git_prompt_show_informative_status 1
    set -gx __fish_git_prompt_color $fish_color_host_remote
    echo (fish_git_prompt)
    # path and suffix 
    set_color $prompt_pathline_color
    printf "%s %s " (prompt_pwd) $prompt_suffix
    set_color normal

end

