function tma --wraps 'tmux' --description "envoke tmux and attach/create a session and jive with iTerm2"

   # if an arg is given, that's the session to join
   if set -q argv[1] 
      command tmux -CC attach -t $argv[1]
   else
      # By default, use a session named "Main" and attach/create as appropriate
      command tmux -CC new-session -A -s Main
   end

end
