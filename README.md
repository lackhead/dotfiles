# Chad's Linux Config files

This is my collection of the dotfiles I used for configuring my personal linux environment.  The general philosophy is that this repo can be cloned anywhere you like within your filesystem and then linked in with stow. 

## To Get Dotfiles on a New Machine

```
git clone git@github.com:lackhead/dotfiles ${HOME}/.dotfiles
stow -n -v .dotfiles -t ~
```

If you have existing dotfiles that conflict with any of these, just copy
them out of the way (or better yet, remove them if you're feeling confident) 
and re-run stow. 

