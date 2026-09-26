ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "${ZINIT_HOME:h}"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

zinit ice wait"0" lucid
zinit light Aloxaf/fzf-tab

zinit ice wait"0" lucid
zinit light zsh-users/zsh-history-substring-search

zinit ice wait"0" lucid
zinit light zsh-users/zsh-syntax-highlighting

zinit ice wait"0" lucid atload'eval "$(fzf --zsh)"'
zinit light junegunn/fzf

zinit ice wait"0" lucid atload'eval "$(zoxide init --cmd cd zsh)"'
zinit light ajeetdsouza/zoxide

autoload -Uz compinit

zcompdump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompdump"
mkdir -p "${zcompdump:h}"

compinit -C -d "$zcompdump"

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --icons --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --icons --color=always $realpath'

bindkey -v
bindkey '^p' history-substring-search-up
bindkey '^n' history-substring-search-down
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
mkdir -p "${HISTFILE:h}"

HISTSIZE=100000
SAVEHIST=100000

setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt EXTENDED_HISTORY
setopt HIST_SAVE_NO_DUPS

typeset -U path

path=(
  "$HOME/.cargo/bin"
  "$HOME/.config/scripts"
  "$HOME/.local/share/go/bin"
  $path
)

export GOPATH="$HOME/.local/share/go"

export EDITOR="nvim"
export VISUAL="$EDITOR"
export SUDO_EDITOR="$EDITOR"
export SYSTEMD_EDITOR="$EDITOR"

export MANPAGER="nvim +Man!"

export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

source ~/.config/shell/aliases

eval "$(starship init zsh)"
eval "$(direnv hook zsh)"

pokego --random 1-8
