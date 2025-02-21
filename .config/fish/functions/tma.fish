function tma --wraps 'tmux' --description "envoke tmux and attach/create a session and jive with iTerm2"

   set sessionname "Main"

   # if an arg is given, that's the session to join
   if set -q argv[1] 
      set sessionname $argv[1]
   end

   command tmux -CC new-session -A -s $sessionname

end
