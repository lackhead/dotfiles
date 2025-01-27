function sci-ssh --wraps='ssh' --description 'SSH to SCI through jump host'
  ssh -A -J ssh://shell.sci.utah.edu:5522 $argv
end
