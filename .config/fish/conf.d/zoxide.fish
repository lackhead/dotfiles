#
# configure for zoxide 
#
if command -q zoxide
    zoxide init --cmd cd fish | source
end
