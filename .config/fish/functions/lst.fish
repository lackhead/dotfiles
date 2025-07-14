function lst --description "List most recently modified things in a given directory(-ies)"

    # configuration variables
    set NUMSHOW 10
    set LSARGS "-ltFh"

    # process args
    argparse 'a/all' 'h/help' 'n/num=' 'r/reverse' -- $argv
       or return
    # handle -all
    if set -q _flag_all
        set LSARGS (printf "%s%s" $LSARGS "A")
    end
    # handle --help
    if set -q _flag_help
        echo "lst - list by modification time"
        echo
        echo "Arguments:"
        echo "    -a/--all     Show hidden files as well"
        echo "    -h/--help    What you see here"
        echo "    -n/--num     How many items to show (defult: $NUMSHOW)"
        echo "    -r/--reverse Show in oldest->newest order"
        return 0
    end
    # handle --num
    if set -q _flag_num
        set NUMSHOW $_flag_num
    end
    # handle --reverse
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
