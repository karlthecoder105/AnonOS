# AnonOS - Hacker Bash Configuration
# "The quieter you become, the more you can hear."

export EDITOR=nvim
export VISUAL=nvim
export BROWSER=firefox
export TERMINAL=kitty

export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/go/bin:$PATH"

# Hacker prompt with starship
eval "$(starship init bash)"

# Zoxide for smarter cd
eval "$(zoxide init bash)"

# Fzf
eval "$(fzf --bash)"
export FZF_DEFAULT_OPTS="--color=fg:#00ff00,bg:#000000,hl:#00ff00,fg+:#00ff00,bg+:#003300,hl+:#00ff00,info:#00ff00,prompt:#00ff00,pointer:#00ff00,marker:#00ff00,spinner:#00ff00,header:#00ff00"

# Aliases
alias ls='eza --icons -a'
alias ll='eza --icons -la'
alias lt='eza --icons --tree -a'
alias cat='bat --theme=base16 --style=plain'
alias grep='rg'
alias find='fd'
alias top='btop'
alias ps='procs'
alias df='duf'
alias du='dust'
alias ping='gping'
alias diff='difft'
alias help='tldr'
alias neo='fastfetch'
alias hi='fastfetch'
alias cm='cmatrix -b -C green'
alias hack='hollywood'
alias matrix='cmatrix -b -C green'
alias clr='clear'
alias update='sudo pacman -Syu && yay -Syu'
alias install='sudo pacman -S'
alias uninstall='sudo pacman -Rs'
alias search='pacman -Ss'
alias aur='yay -S'
alias aurs='yay -Ss'
alias sysinfo='fastfetch'
alias ports='ss -tulanp'
alias myip='curl -s ifconfig.me'
alias weather='curl wttr.in'
alias cheat='curl cheat.sh'

# Welcome message
fastfetch --logo-color-1 00ff00 --logo-color-2 005500 --logo-color-3 00aa00

# Set up shell integration
test -f ~/.config/bspwm/scripts/shell.sh && source ~/.config/bspwm/scripts/shell.sh
