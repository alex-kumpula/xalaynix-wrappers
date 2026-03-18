# --- History Configuration ---
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Share history between different terminals
setopt SHARE_HISTORY
# Don't record duplicates
setopt HIST_IGNORE_ALL_DUPS
# Remove extra blanks from each command line
setopt HIST_REDUCE_BLANKS