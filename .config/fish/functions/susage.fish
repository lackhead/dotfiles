function susage --description 'Slurm: show last 4wks usage report'
    sreport cluster UserUtilizationByAccount -t hours Start='now-4weeks'
end
