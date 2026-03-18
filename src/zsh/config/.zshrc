# --- Zsh Bootloader ---

# Iterate through all .zsh files in the ZDOTDIR (Nix Store)
# We exclude .zshrc itself to avoid an infinite loop
for file in "$ZDOTDIR"/*.zsh; do
    if [[ -f "$file" && "$file" != *".zshrc" ]]; then
        source "$file"
    fi
done