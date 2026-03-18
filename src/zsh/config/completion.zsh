# --- Completion System ---
autoload -Uz compinit
compinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# Use arrow keys in the completion menu
zstyle ':completion:*' menu select




# --- Auto-suggestions ---

# Look for the plugin in the Nix profile paths
# This finds where Nix placed the 'zsh-autosuggestions' package
if [[ -f "/run/current-system/sw/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "/run/current-system/sw/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif [[ -f "$HOME/.nix-profile/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "$HOME/.nix-profile/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# Customize the suggestion color (e.g., dim gray)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"

# Bind 'Right Arrow' or 'End' to accept the suggestion
bindkey '^[[C' forward-char