# dotfiles Location

$HOME/dotfiles

*Attention must be bare!!!*

git init --bare $HOME/.dotfiles

# use config instead of git command

dgit command setup:

In .zshrc:
```
alias dgit="git --git-dir=$HOME/dotfiles.git --work-tree=$HOME"
```

adding a file to the repository:

dgit add .config/some-config-file
dgit commit -m "Add some-config-file"
```
