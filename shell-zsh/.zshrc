#use zinit
source ~/.zinit/bin/zinit.zsh

#use autosuggestions
zinit ice lucid wait="0" atload='_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

#use highlighting
zinit ice lucid wait='0' atinit='zpcompinit'
zinit light zdharma/fast-syntax-highlighting

#use theme pure
zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure

#use completions
zinit ice blockf
zinit light zsh-users/zsh-completions

zinit light zdharma/history-search-multi-word
zinit ice from"gh-r" as"program"
zinit load junegunn/fzf-bin

#use omz
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit cdclear -q

zinit ice svn
zinit snippet OMZ::plugins/z
zinit snippet OMZP::command-not-found
zinit snippet OMZP::cp
zinit snippet OMZP::rand-quote
zinit ice svn
zinit snippet OMZ::plugins/sudo


zinit light zsh-users/zsh-history-substring-search

HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="bg=none,fg=1,bold"
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="bg=none,fg=none,none"

# zinit self-update
#zinit update --all

#alias
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

clear-screen() { echoti clear; precmd; zle redisplay; }
zle -N clear-screen

bindkey '^o' autosuggest-accept
# bindkey '^p' up-line-or-history
# bindkey '^n' down-line-or-history
bindkey '^p' history-substring-search-up
bindkey '^n' history-substring-search-down
#bindkey '^e' history-search-multi-word
bindkey '^w' backward-kill-word
bindkey '^h' backward-char
bindkey '^l' forward-char
bindkey '^u' clear-screen
bindkey '^k' vi-forward-word
bindkey '^j' vi-backward-word

bindkey '^d' end-of-line



#history
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
HISTFILESIZE=20000
# setopt SHARE_HISTORY

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

#env path
export PATH=$PATH:/home/dongzaiq/tools/android-ndk-r18b/:/home/dongzaiq/.yarn/bin:/home/dongzaiq/Android/Sdk/ndk/21.3.6528147/:/snap/bin:
export EDITOR="/usr/bin/vim"

#set core dump
ulimit -c unlimited
#fortune | cowsay -r
fortune | cowsay -f tortoise
