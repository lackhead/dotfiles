# 
# Slurm aliases
#

function sjobs --wraps squeue --description 'Slurm: show job info'
    squeue -Su -o '%8i %10u %20j %4t %5D %20R %15b %.3C %.7m %.11l %11S %.11L' $argv
end

function susage --description 'Slurm: show last 4wks usage report'
    sreport cluster UserUtilizationByAccount -t hours Start='now-4weeks'
end

function snodes --wraps sinfo --description 'Slurm: show node info'
    sinfo -o '%16P %12n %.6t %.4c %.8z %.6m %26G %.10l %.11L' --sort=P,n $argv
end

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
    
