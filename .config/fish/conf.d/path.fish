# 
# path: set up PATH
#
for dir in /usr/local/{s,}bin /opt/homebrew/bin ~/bin
    fish_add_path -p -m $dir
end
