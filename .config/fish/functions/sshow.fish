function sshow --description 'Slurm: show job/node/partition info'
    if test (count $argv) -eq 0
        echo "Usage: scontrol_show <job_id_or_node_or_partition>"
        return 1
    end
    
    # process each arg as a possibly job/node/partition
    for arg in $argv

        # Check if the argument starts with a digit
        if string match -qr '^\d' -- $arg
            # Treat as job ID
            scontrol show job $arg
        else
            # Check if it's a valid node name
            if scontrol show node $arg &>/dev/null
                scontrol show node $arg
            # Otherwise, try as partition
            else if scontrol show partition $arg &>/dev/null
                scontrol show partition $arg
            else
                echo "Error: '$arg' is not a valid job ID, node name, or partition name"
                return 1
            end
        end

        # make it easy to visually parse
        if test (count $argv) -gt 1
            echo ""
            echo "----------------------------------------"
            echo ""
        end

    end

end
