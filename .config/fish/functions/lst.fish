function lst --description "List most recently modified things in a given directory(-ies)"

    # configuration variables
    set NUMSHOW 10

    # if first arg is a digit, that's the number of top things to show
    if string match -qr '^\d+$' $argv[1]
        set NUMSHOW $argv[1]
        set argv $argv[2..]
    end

    # default is current dir
    if [ (count $argv) -eq 0 ]
        echo ">>>" $( pwd ) "<<<"
        command ls -ltAFh . | tail -n +2 | head -$NUMSHOW
    else
       for item in $argv
           echo ">>> " (realpath $item) " <<< " 
           command ls -ltAFh $item | tail -n +2 | head -$NUMSHOW
           echo
       end
    end

end
