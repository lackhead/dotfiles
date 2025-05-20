function sjobs --wraps squeue --description 'Slurm: show job info'
    squeue -Su -o '%8i %10u %20j %4t %5D %20R %15b %3C %7m %11l %11S %11L' $argv
end
