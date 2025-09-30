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

function sshow --description 'Slurm: show job info'
    scontrol show job $argv
end
