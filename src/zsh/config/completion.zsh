# --- Completion System ---
autoload -Uz compinit
compinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# Use arrow keys in the completion menu
zstyle ':completion:*' menu select




# --- Auto-suggestions ---
if [[ -n "$AUTOSUGGEST_SRC" ]]; then
    source "$AUTOSUGGEST_SRC"
fi

# Use Right-Arrow to accept the ghost text
bindkey '^[[C' forward-char