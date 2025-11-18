# 
# path: set up PATH
#
for dir in ~/.local/bin /usr/local/{s,}bin /opt/homebrew/bin ~/bin
#    fish_add_path -p -m $dir
    fish_add_path -p -g $dir
end

# Get my personal stuff if root 
if fish_is_root_user
    fish_add_path -g ~clake/bin 
end
