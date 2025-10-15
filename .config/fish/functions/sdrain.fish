function sdrain --wraps=squeue --description 'Slurm: show nodes that are in the DRAIN state why they are there'
    sinfo -N -o "%N %T %E" -t drain,draining,drained
end
