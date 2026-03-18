# --- Prompt ---
# Add the wrapped Starship to the PATH 
# (beginning of the path so it takes precedence over any system-wide starship)
if [[ -n "$WRAPPED_STARSHIP_BIN_DIR" ]]; then
    export PATH="$WRAPPED_STARSHIP_BIN_DIR:$PATH"
fi
# Initialize Starship
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi