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
bindkey '^R' history-incremental-search-backward

# Fix tab completion http://stackoverflow.com/questions/564648/zsh-tab-completion-for-cd
zstyle ':completion:*' special-dirs true

# History
export HISTSIZE=100000
export HISTFILESIZE=100000
export SAVEHIST=100000
export HISTFILE=~/.zsh_history
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt EXTENDED_HISTORY
