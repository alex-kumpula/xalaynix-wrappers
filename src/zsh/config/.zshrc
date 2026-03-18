# --- History Configuration ---
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
# Share history between different terminals
setopt SHARE_HISTORY
# Don't record duplicates
setopt HIST_IGNORE_ALL_DUPS
# Remove extra blanks from each command line being added to history
setopt HIST_REDUCE_BLANKS


# --- Basic Keybindings ---
# Use emacs-style keybindings (standard for most)
bindkey -e
# Allow Ctrl+Left/Right to jump words
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# --- Completion System ---
autoload -Uz compinit
compinit
# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# Use arrow keys in the completion menu
zstyle ':completion:*' menu select

# --- Aliases ---
alias ls='eza --icons'   # Assumes you have eza installed
alias ll='eza -lh'
alias la='eza -a'
alias grep='grep --color=auto'
alias ..='cd ..'

# --- Prompt ---
# Initialize Starship if it's in your PATH
# if [[ -x "$WRAPPED_STARSHIP_BIN" ]]; then
#     alias starship="$WRAPPED_STARSHIP_BIN"
#     eval "$($WRAPPED_STARSHIP_BIN init zsh)"
# fi

if [[ -x "$WRAPPED_STARSHIP_BIN" ]]; then
    # 1. Export the config path again just to be absolutely sure
    export STARSHIP_CONFIG="$STARSHIP_CONFIG"

    # 2. Run the init but CAPTURE the output
    # We replace the bare 'starship' command with the absolute path 
    # inside the generated script before eval-ing it.
    eval "$($WRAPPED_STARSHIP_BIN init zsh | sed "s/starship prompt/\"$WRAPPED_STARSHIP_BIN\" prompt/g")"
    
    # 3. Alias as a final fallback
    alias starship="$WRAPPED_STARSHIP_BIN"
fi

# --- Useful Functions ---
# Create a directory and enter it immediately
mkd() {
    mkdir -p "$@" && cd "$@"
}