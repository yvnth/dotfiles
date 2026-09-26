export PATH="$HOME/.cargo/bin:$HOME/.config/scripts:$PATH"

export GOPATH="$HOME/.local/share/go"
export PATH="$PATH:$GOPATH/bin"

export EDITOR="nvim"
export VISUAL="$EDITOR"
export SUDO_EDITOR="$EDITOR"
export SYSTEMD_EDITOR="$EDITOR"

export MANPAGER="nvim +Man!"

export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/bash/history"
mkdir -p "$(dirname "$HISTFILE")"

HISTSIZE=100000
HISTFILESIZE=100000

shopt -s histappend cmdhist lithist

source ~/.config/shell/aliases

eval "$(starship init bash)"
eval "$(fzf --bash)"
eval "$(zoxide init bash --cmd cd)"
eval "$(direnv hook bash)"

pokego --random 1-8
