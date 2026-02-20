# remap

alias cls='clear'
alias gerp='grep'

alias l='ls -CF'
alias ll='ls -alF'
alias la='ls -A'
alias mv='mv -i'

alias op='open 2>/dev/null'

alias lz='eza'
complete -F _eza lz

alias vim='nvim'
alias bt='bluetoothctl'
alias py='python3'
alias sch='mit-scheme --quiet'
alias scf='scheme-format -i'

# utils

alias source-bashrc='source ~/.bashrc'

alias uuapt='sudo apt update && sudo apt upgrade -y'

alias dotfiles='ls -d .??*'

alias rm-cores='rm core.* vgcore.*'

alias http-server='python3 -m http.server -b 127.0.0.1'

alias tree='eza -T --git-ignore --group-directories-first --all'

alias ccp='xclip -selection clipboard'
alias cpt='xclip -selection clipboard -o'

alias cnow='date +"%H:%M" | xclip -selection clipboard'
alias today='date +"%d-%m-%Y" | xclip -selection clipboard'
