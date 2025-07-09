function lst --description "List most recently modified things in a given directory(-ies)"

    # configuration variables
    set NUMSHOW 10
    set LSARGS "-ltAFh"

    # process args
    argparse 'h/help' 'n/num=' 'r/reverse' -- $argv
       or return
    if set -q _flag_help
        echo "lst - list by modification time"
        echo
        echo "Arguments:"
        echo "    -h/--help    What you see here"
        echo "    -n/--num     How many items to show (defult: $NUMSHOW)"
        echo "    -r/--reverse Show in oldest->newest order"
        return 0
    end
    if set -q _flag_num
        set NUMSHOW $_flag_num
    end
    if set -q _flag_reverse
        set LSARGS (printf "%s%s" $LSARGS "r")
    end
    

    # if first arg is a digit, that's the number of top things to show
    if string match -qr '^\d+$' $argv[1]
        set NUMSHOW $argv[1]
        set argv $argv[2..]
    end

    # default is current dir
    if [ (count $argv) -eq 0 ]
        echo ">>>" $( pwd ) "<<<"
        command ls $LSARGS . | tail -n +2 | head -$NUMSHOW
    else
       for item in $argv
           echo ">>> " (realpath $item) " <<< " 
           command ls $LSARGS $item | tail -n +2 | head -$NUMSHOW
           echo
       end
    end

end
