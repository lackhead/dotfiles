#
# configure for zoxide 
#
if command -q zoxide && status is-interactive
    zoxide init --cmd cd fish | source
end
