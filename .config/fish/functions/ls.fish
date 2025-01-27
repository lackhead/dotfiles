function ls --wraps 'ls'
    command ls --color=auto -Fh $argv
end
