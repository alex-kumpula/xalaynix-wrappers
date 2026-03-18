# --- Completion System ---
autoload -Uz compinit
compinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# Use arrow keys in the completion menu
zstyle ':completion:*' menu select