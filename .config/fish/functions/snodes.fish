function snodes --wraps sinfo --description 'Slurm: show node info'
    sinfo -o '%16P %12n %.6t %.4c %.8z %.6m %12G %10l %11L' --sort=P,n $argv
end
