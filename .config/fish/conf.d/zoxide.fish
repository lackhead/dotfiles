#
# configure for zoxide 
#
if command -q zoxide && not status is-interactive
    zoxide init --cmd cd fish | source
end
