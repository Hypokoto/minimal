# ==============================================================================
# Minimal zsh/aliases.zsh — Modular & Defensive Shell Aliases
# Every binary alias is wrapped in command -v checks so the shell never breaks
# if a tool is uninstalled or missing.
# ==============================================================================

# --- Interactive Safety Fallbacks & Core Overrides ---
alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'

# --- Navigation Shortcuts ---
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'

# --- Reloader & Quick Dotfile Editing ---
alias reload='source ~/.zshrc && echo "  .zshrc reloaded"'
alias ezsh='${EDITOR:-nvim} ~/.zshrc'
alias ealias='${EDITOR:-nvim} ~/.config/zsh/aliases.zsh'
alias eai='${EDITOR:-nvim} ~/.config/zsh/ai-helper.zsh'
alias etmux='${EDITOR:-nvim} ~/.config/tmux/tmux.conf'
alias ekitty='${EDITOR:-nvim} ~/.config/kitty/kitty.conf'
alias ehypr='${EDITOR:-nvim} ~/.config/hypr/hyprland.conf'

# --- Defensive Modern CLI Replacements ---

# 1. Listing (eza -> ls)
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --color=auto --icons=auto'
    alias ll='eza -lah --icons=auto --git --group-directories-first'
    alias la='eza -a --icons=auto'
    alias l='eza --icons=auto'
    alias lt='eza --tree --level=2 --icons=auto --group-directories-first'
    alias llt='eza --tree --level=3 --icons=auto --group-directories-first --git'
else
    alias ls='ls --color=auto'
    alias ll='ls -lAhF --color=auto'
    alias la='ls -A --color=auto'
    alias l='ls -CF --color=auto'
fi

# 2. File viewing (bat -> cat)
if command -v bat >/dev/null 2>&1; then
    alias cat='bat --style=plain --paging=never'
    alias batp='bat --style=numbers'
elif command -v batcat >/dev/null 2>&1; then
    alias cat='batcat --style=plain --paging=never'
fi

# 3. Disk Usage (duf -> df, dust -> du)
if command -v duf >/dev/null 2>&1; then
    alias df='duf'
else
    alias df='df -h'
fi

if command -v dust >/dev/null 2>&1; then
    alias du='dust'
else
    alias du='du -sh'
fi

# 4. Process Monitor (btop -> top)
if command -v btop >/dev/null 2>&1; then
    alias top='btop'
elif command -v btm >/dev/null 2>&1; then
    alias top='btm'
fi

# 5. Safe Trash Deletion (trash-cli / trash-put)
# POSIX tools tr / cut / sed MUST NOT be aliased — they are used in shell pipelines.
if command -v trash-put >/dev/null 2>&1; then
    alias rm='trash-put'
    alias tp='trash-put'      # trash-put
    alias tl='trash-list'     # trash-list
    alias tre='trash-restore' # trash-restore (NOT tr — would break pipelines)
    alias trm='trash-empty'   # trash-empty
    alias rmf='/bin/rm -iv'   # bypass alias for permanent deletes
elif command -v trash >/dev/null 2>&1; then
    alias rm='trash'
    alias tp='trash'
    alias rmf='/bin/rm -iv'
else
    alias rm='rm -i'
fi

# 6. Search tools (ripgrep)
if command -v rg >/dev/null 2>&1; then
    alias grep='rg'
else
    alias grep='grep --color=auto'
fi

# --- Git Shortcuts ---
alias gs='git status -sb'
alias ga='git add'
alias gc='git commit'
alias gca='git commit --amend --no-edit'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --oneline --graph --decorate -20'
alias gp='git push'
alias gpull='git pull --rebase'
alias gst='git stash'
alias gstp='git stash pop'
alias gco='git checkout'
alias gcb='git checkout -b'

# --- System & Network ---
alias free='free -h'
alias path='echo $PATH | tr ":" "\n"'
alias ports='ss -tulanp'
alias myip='curl -s https://icanhazip.com || curl -s https://ifconfig.me'
alias topcpu='ps aux --sort=-%cpu | head -20'
alias topmem='ps aux --sort=-%mem | head -20'
