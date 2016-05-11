setopt auto_cd

# Prompt
export CLICOLOR=1
autoload -Uz promptinit
promptinit

export PS1="%F{blue}%n@%m %B%F{green}%120<...<%~
%}%F{white} %# %b%f%k"

export PATH=$HOME/bin:$HOME/dotfiles/bin:/usr/local/bin:$PATH

# Keybinds
bindkey -e
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line

# Fix tab completion http://stackoverflow.com/questions/564648/zsh-tab-completion-for-cd
zstyle ':completion:*' special-dirs true

export HISTFILESIZE=10000000
export HISTSIZE=10000000
