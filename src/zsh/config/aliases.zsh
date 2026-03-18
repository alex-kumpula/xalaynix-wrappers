# --- Aliases ---
alias ls='eza --icons'
alias ll='eza -lh'
alias la='eza -a'
alias grep='grep --color=auto'
alias ..='cd ..'

# --- Useful Functions ---
mkd() {
    mkdir -p "$@" && cd "$@"
}