# dotfiles
Chad's linux dot files

# add to zshrc
alias dotconf='/usr/bin/git --git-dir=${HOME}/.dotconf/ --work-tree=${HOME}'

# initial setup
git init --bare ${HOME}/.dotconf
dotconf config status.showUntrackedFiles no
echo ".dotconf" >> .gitignore
# for each file
dotconf add <file>
dotconf commit -m "Initial setup from existing files"
# push to Github
dotconf remote add origin git@github.com:lackhead/dotfiles
dotconf push -u origin main

# To setup on new machine
git clone --separate-git-dir=${HOME}/.dotconf git@github.com:lackhead/dotfiles dotfiles_temp
rsync --recursive --verbose --exclude '.git' --exclude README.md --exclude LICENSE dotfiles_temp/ ${HOME}/
rm -r dotfiles_temp
alias dotconf='/usr/bin/git --git-dir=${HOME}/.dotconf/ --work-tree=${HOME}'
dotconf config status.showUntrackedFiles no
