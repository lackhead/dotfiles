# 
# path: set up PATH
#
for dir in ~/.local/bin /usr/local/{s,}bin /opt/homebrew/bin ~/bin
#    fish_add_path -p -m $dir
    fish_add_path -p -g $dir
end
