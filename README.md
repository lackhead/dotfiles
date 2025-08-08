# Chad's Linux/Mac Config files

This is my collection of dotfiles I use to configure my personal linux(-ish) environment, along with some generic scripts I've written to create my personal working environment. The general concept I follow is a pretty common one– using a bare git repo (stored in `~/.dotconf`) with the work tree pointed at my home directory. I find this pretty easy to use- no special tools/scripts (just an alias), no symlinks to manage, version control, and easy replication. You can also edit any dot file directly on whatever box you may be using and can easily merge it back into this repo using standard `git` commands (using the one alias), if desired. 

## The Initial Repo Build
Here are the commands I used to create this repo: 
```
git init --bare $HOME/.dotconf
alias dotconf='/usr/bin/git --git-dir=$HOME/.dotconf/ --work-tree=$HOME'
dotconf config status.showUntrackedFiles no
echo ".dotconf" >> .gitignore
```
Then, for each dot file: 
```
dotconf add <filename>
```
And then to push it up to Github:
```
dotconf commit -m "Initial setup from existing files"
dotconf remote add origin git@github.com:lackhead/dotfiles
dotconf push -u origin main
```
Note that I do have the `dotconf` alias in my `.zshrc` file- this is just to make standard `git` things easy (e.g. `dotconf status`).


## To Get Dotfiles on a New Machine
If you want to get started using this on a new machine somewhere, the general ideas is to clone the repo, copy the files into place, then remove the working directory (the `~/.dotconf` directory, which git uses, remains): 
```
git clone --separate-git-dir=$HOME/.dotconf https://github.com/lackhead/dotfiles $HOME/dotfiles_temp
rsync --recursive --verbose --exclude '.git' --exclude README.md --exclude LICENSE dotfiles_temp/ $HOME/
rm -rf $HOME/dotfiles_temp
alias dotconf='/usr/bin/git --git-dir=$HOME/.dotconf/ --work-tree=$HOME'
dotconf config status.showUntrackedFiles no
dotconf update-index --assume-unchanged README.md
dotconf update-index --assume-unchanged LICENSE
```
Additionally, to avoid pulling down README/LICENSE files, run `dotconf config core.sparsecheckout true` and then add `README.md` and `LICENSE` to the file `.dotconf/info/sparse-checkout`.

## General Usage
Go ahead and update dotfiles as you see fit on whatever box you happen to be working on and use standard `git` techniques to manage the canonical copies in the repo. If you want to add more files, just do the same `dotconf add <filename>` and commit/push as above. 
