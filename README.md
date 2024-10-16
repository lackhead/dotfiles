# Chad's Linux Config files

This is my collection of dotfiles I use to configure my personal linux(-ish) environment. The general concept I follow is a pretty common one– using a bare git repo (stored in `~/.dotconf`) with the work tree pointed at my home directory. I find this pretty easy to use- no special tools/scripts (just an alias), no symlinks to manage, version control, and easy replication. You can also edit any dot file directly on whatever box you may be using and can easily merge it back into this repo using standard `git` commands (using the one alias), if desired. 

## The Initial Repo Build
Here are the commands I used to create this repo: 
```
# create the initial repo locally
git init --bare ${HOME}/.dotconf

# set up an alias for ease of use
alias dotconf='/usr/bin/git --git-dir=${HOME}/.dotconf/ --work-tree=${HOME}'

# make sure it doesn't freak out abou everything else in my home directory
dotconf config status.showUntrackedFiles no

# make sure git doesn't suck up its own directory
echo ".dotconf" >> .gitignore
```
Then, for each dot file: 
```
dotconf add <filename>
```
And then to push it up to Github:
```
# commit
dotconf commit -m "Initial setup from existing files"

# configure the origin
dotconf remote add origin git@github.com:lackhead/dotfiles

# push
dotconf push -u origin main
```
Note that I do have the `dotconf` alias in my `.zshenv` file- this is just to make standard `git` things easy (e.g. `dotconf status`).


## To Get Dotfiles on a New Machine
If you want to get started using this on a new machine somewhere, the general ideas is to clone the repo, copy the files into place, then remove the working directory (the `~/.dotconf` directory, which git uses, remains): 
```
# clone the repo into a temporary directory (assuming ~/dotfile_temp is not already in use!)
git clone --separate-git-dir=${HOME}/.dotconf git@github.com:lackhead/dotfiles ${HOME}/dotfiles_temp

# copy over the files
rsync --recursive --verbose --exclude '.git' --exclude README.md --exclude LICENSE dotfiles_temp/ ${HOME}/

# remove the temp directory
rm -rf ${HOME}/dotfiles_temp

# set up the alias (could also just restart the shell or source .zshenv)
alias dotconf='/usr/bin/git --git-dir=${HOME}/.dotconf/ --work-tree=${HOME}'

# make sure it doesn't freak out abou everything else in my home directory
dotconf config status.showUntrackedFiles no
```

## General Usage
Go ahead and update dotfiles as you see fit on whatever box you happen to be working on and use standard `git` techniques to manage the canonical copies in the repo. If you want to add more files, just do the same `dotconf add <filename>` and commit/push as above. 
