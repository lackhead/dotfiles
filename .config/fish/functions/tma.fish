#
# tma()
#
function tma --wraps 'tmux' --description "envoke tmux and attach/create a session and jive with iTerm2"

   set sessionname "Main"

    function __help -d "show help for tma()"

        echo
        echo "usage: tma [-h|--help]"
        echo "       tma ls"
        echo "       tma [session]"
        echo 
        echo "arguments:"
        echo "  -h, --help          show this help message and exit"
        echo "  ls                  list available sessions"
        echo "  [session]           start named session, or $sessionname if none given"
        echo

    end

    # Parse arguments
    argparse 'h/help' -- $argv || return 1

    # Show help
    set -q _flag_help && __help && return 0

    if set -q argv[1] 
       if [ "$argv[1]" = "ls" ]
           command tmux list-sessions && return 0
       end   
       set sessionname $argv[1]
    end
 
    command tmux -CC new-session -A -s $sessionname
 
end
