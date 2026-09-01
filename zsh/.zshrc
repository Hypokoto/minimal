# ===========================================================================
#  ZSH CONFIGURATION — Minimal Shell Workspace
#  Blisteringly fast, zero-framework, native Zsh productivity.
#  Core Dependencies: zsh >= 5.8, git, starship, zoxide, atuin
# ===========================================================================

# ---------------------------------------------------------------------------
#  §1  SHELL CORE PERFORMANCE & HISTORY
# ---------------------------------------------------------------------------

HISTFILE="${HOME}/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

# History behavior — maximum utility, zero noise.
setopt APPEND_HISTORY        # Append, never overwrite.
setopt SHARE_HISTORY         # Share history across concurrent sessions.
setopt EXTENDED_HISTORY      # Save timestamps with each command.
setopt HIST_IGNORE_ALL_DUPS  # Deduplicate: keep only the latest entry.
setopt HIST_REDUCE_BLANKS    # Strip superfluous whitespace.
setopt HIST_IGNORE_SPACE     # Prefix command with space to exclude from history.
setopt HIST_VERIFY           # Show expanded history command before executing.

# ---------------------------------------------------------------------------
#  §2  SHELL OPTIONS — Ergonomics & Agent Safety
# ---------------------------------------------------------------------------

setopt AUTO_CD               # Type a directory name to cd into it.
setopt AUTO_PUSHD            # Push directories onto the stack automatically.
setopt PUSHD_IGNORE_DUPS     # No duplicate entries in the dir stack.
setopt PUSHD_SILENT          # Don't print the dir stack after pushd/popd.
setopt CORRECT               # Offer spelling correction for commands.
setopt NO_BEEP               # Silence the terminal bell globally.
setopt INTERACTIVE_COMMENTS  # Allow # comments in interactive shell.
setopt PROMPT_SUBST          # Enable parameter expansion in prompts.

# Idle timeout disabled for interactive desktop ergonomics (override TMOUT if required)
# TMOUT=900

# Agent Safety: Bracketed paste protection.
# Multi-line commands pasted by external AI coding agents (Aider, Claude Code, OpenCode)
# drop into the active buffer as editable text without auto-executing.
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

# ---------------------------------------------------------------------------
#  §3  COMPLETION ENGINE — Fast, Case-Insensitive, Minimal-Styled
# ---------------------------------------------------------------------------

ZSH_PLUGIN_DIR="${HOME}/.zsh/plugins"
[[ -d "${ZSH_PLUGIN_DIR}" ]] || mkdir -p "${ZSH_PLUGIN_DIR}"

autoload -Uz compinit
compinit -C

zmodload zsh/complist
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list \
    'm:{a-zA-Z}={A-Za-z}' \
    'r:|[._-]=* r:|=*' \
    'l:|=* r:|=*'

zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:*:*:*:descriptions' format '%F{#5B8CFF}-- %d --%f'
zstyle ':completion:*:messages' format '%F{#A05CFF}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{#FF5470}-- no matches --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${HOME}/.zsh/cache"

# ---------------------------------------------------------------------------
#  §4  PLUGIN MANAGEMENT — Ultralight, No Framework
# ---------------------------------------------------------------------------

# --- zsh-autosuggestions ---
_plugin_autosug=""
if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    _plugin_autosug="/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    _plugin_autosug="/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
else
    _plugin_autosug_dir="${ZSH_PLUGIN_DIR}/zsh-autosuggestions"
    [[ ! -d "${_plugin_autosug_dir}" ]] && git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "${_plugin_autosug_dir}" 2>/dev/null
    _plugin_autosug="${_plugin_autosug_dir}/zsh-autosuggestions.zsh"
fi
if [[ -f "${_plugin_autosug}" ]]; then
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#8D95B3'
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=50
    source "${_plugin_autosug}"
fi

# --- fzf-tab ---
_plugin_fzftab="${ZSH_PLUGIN_DIR}/fzf-tab"
if [[ ! -d "${_plugin_fzftab}" ]]; then
    git clone --depth=1 https://github.com/Aloxaf/fzf-tab "${_plugin_fzftab}" 2>/dev/null
fi
if [[ -f "${_plugin_fzftab}/fzf-tab.plugin.zsh" ]]; then
    source "${_plugin_fzftab}/fzf-tab.plugin.zsh"
    zstyle ':fzf-tab:*' fzf-command fzf
    zstyle ':fzf-tab:*' fzf-flags \
        '--color=bg:#0A0C12,bg+:#11141D,fg:#F2F6FF,fg+:#F2F6FF' \
        '--color=hl:#00D9FF,hl+:#61E6FF,info:#8D95B3,marker:#4DFF91' \
        '--color=prompt:#5B8CFF,spinner:#A05CFF,pointer:#00D9FF' \
        '--color=header:#5B8CFF,border:#1C2230' \
        '--border=rounded' '--layout=reverse'
    zstyle ':fzf-tab:*' switch-group Tab Shift-Tab
    zstyle ':fzf-tab:complete:cd:*' fzf-preview \
        'eza --tree --level=2 --color=always --icons=auto $realpath 2>/dev/null || ls -la $realpath'
    zstyle ':fzf-tab:complete:nvim:*' fzf-preview \
        'bat --style=numbers --color=always --line-range :200 $realpath 2>/dev/null || cat $realpath'
fi

# --- zsh-syntax-highlighting ---
_plugin_syntax_hl=""
if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    _plugin_syntax_hl="/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
elif [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    _plugin_syntax_hl="/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
else
    _plugin_syntax_hl_dir="${ZSH_PLUGIN_DIR}/zsh-syntax-highlighting"
    [[ ! -d "${_plugin_syntax_hl_dir}" ]] && git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting "${_plugin_syntax_hl_dir}" 2>/dev/null
    _plugin_syntax_hl="${_plugin_syntax_hl_dir}/zsh-syntax-highlighting.zsh"
fi
if [[ -f "${_plugin_syntax_hl}" ]]; then
    _load_syntax_hl() {
        add-zsh-hook -d precmd _load_syntax_hl
        source "${_plugin_syntax_hl}"
        typeset -A ZSH_HIGHLIGHT_STYLES
        ZSH_HIGHLIGHT_STYLES[command]='fg=#4DFF91'
        ZSH_HIGHLIGHT_STYLES[builtin]='fg=#61E6FF'
        ZSH_HIGHLIGHT_STYLES[alias]='fg=#5B8CFF'
        ZSH_HIGHLIGHT_STYLES[function]='fg=#00D9FF'
        ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#FF5470'
        ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#A05CFF'
        ZSH_HIGHLIGHT_STYLES[path]='fg=#F2F6FF,underline'
        ZSH_HIGHLIGHT_STYLES[globbing]='fg=#61E6FF'
        ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#4DFF91'
        ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#4DFF91'
        ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#4DFF91'
        ZSH_HIGHLIGHT_STYLES[comment]='fg=#8D95B3'
        ZSH_HIGHLIGHT_STYLES[arg0]='fg=#5B8CFF'
        ZSH_HIGHLIGHT_STYLES[default]='fg=#F2F6FF'
        ZSH_HIGHLIGHT_STYLES[precommand]='fg=#A05CFF'
        ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#FF5470'
        ZSH_HIGHLIGHT_STYLES[redirection]='fg=#61E6FF'
        ZSH_HIGHLIGHT_STYLES[assign]='fg=#F2F6FF'
    }
    autoload -Uz add-zsh-hook
    add-zsh-hook precmd _load_syntax_hl
fi

# ---------------------------------------------------------------------------
#  §5  KEY BINDINGS
# ---------------------------------------------------------------------------

bindkey -e
bindkey '^F' forward-word
bindkey -s '^B' 'ff\n'

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^P'   up-line-or-beginning-search
bindkey '^N'   down-line-or-beginning-search

bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^H' backward-kill-word
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

bindkey -M menuselect '^[' send-break
bindkey -M menuselect 'h' backward-char
bindkey -M menuselect 'l' forward-char
bindkey -M menuselect 'j' down-line-or-history
bindkey -M menuselect 'k' up-line-or-history

if [[ -n "$terminfo[kcbt]" ]]; then
    bindkey "$terminfo[kcbt]" reverse-menu-complete
    bindkey -M menuselect "$terminfo[kcbt]" reverse-menu-complete
fi
bindkey '^[[Z' reverse-menu-complete
bindkey -M menuselect '^[[Z' reverse-menu-complete

# ---------------------------------------------------------------------------
#  §6  PROMPT — Starship Prompt Engine
# ---------------------------------------------------------------------------

if command -v starship >/dev/null 2>&1; then
    _starship_cache="${HOME}/.zsh/cache/starship-init.zsh"
    if [[ ! -f "$_starship_cache" || "$(command -v starship)" -nt "$_starship_cache" ]]; then
        starship init zsh >| "$_starship_cache" 2>/dev/null
    fi
    source "$_starship_cache"
else
    PROMPT='%F{#00D9FF}%~%f %F{#61E6FF}λ%f '
    RPROMPT='%(?.%F{#8D95B3}.%F{#FF5470}%? ↵%f)'
fi

# ---------------------------------------------------------------------------
#  §7  MODULAR ALIASES
# ---------------------------------------------------------------------------

# Load defensive guarded aliases module
if [[ -f "${HOME}/.config/zsh/aliases.zsh" ]]; then
    source "${HOME}/.config/zsh/aliases.zsh"
elif [[ -f "${HOME}/minimal/zsh/aliases.zsh" ]]; then
    source "${HOME}/minimal/zsh/aliases.zsh"
fi

# Load security & networking aliases module
if [[ -f "${HOME}/.config/zsh/sec.zsh" ]]; then
    source "${HOME}/.config/zsh/sec.zsh"
elif [[ -f "${HOME}/minimal/zsh/sec.zsh" ]]; then
    source "${HOME}/minimal/zsh/sec.zsh"
fi

# ---------------------------------------------------------------------------
#  §8  UTILITY FUNCTIONS
# ---------------------------------------------------------------------------

zbench() {
    local n="${1:-10}"
    echo "Benchmarking zsh startup time (${n} iterations)..."
    local total=0 elapsed ms
    for i in {1..$n}; do
        elapsed=$({ TIMEFORMAT='%R'; time zsh -i -c exit; } 2>&1)
        ms=$(printf '%.0f' $(( elapsed * 1000 )))
        echo "  Run $i: ${elapsed}s (${ms}ms)"
        (( total += ms ))
    done
    printf '\n  Average: %dms\n' $(( total / n ))
}

mkcd() { mkdir -p "$1" && cd "$1"; }

extract() {
    if [[ ! -f "$1" ]]; then
        echo "'$1' is not a valid file"
        return 1
    fi
    case "$1" in
        *.tar.bz2) tar xjf "$1"        ;;
        *.tar.gz)  tar xzf "$1"        ;;
        *.tar.xz)  tar xJf "$1"        ;;
        *.tar.zst) tar --zstd -xf "$1" ;;
        *.bz2)     bunzip2 "$1"        ;;
        *.gz)      gunzip "$1"         ;;
        *.tar)     tar xf "$1"         ;;
        *.tbz2)    tar xjf "$1"        ;;
        *.tgz)     tar xzf "$1"        ;;
        *.zip)     unzip "$1"          ;;
        *.7z)      7z x "$1"           ;;
        *.xz)      unxz "$1"           ;;
        *.zst)     zstd -d "$1"        ;;
        *.rar)     unrar x "$1"        ;;
        *)         echo "'$1' — unknown archive format" ;;
    esac
}

duh() {
    local target="${1:-.}"
    if command -v eza >/dev/null 2>&1; then
        eza --tree --level="${2:-2}" --icons=auto --group-directories-first "$target"
    else
        du -sh "${target}"/* 2>/dev/null | sort -rh | head -20
    fi
}

y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

tm() {
    local session="${1:-main}"
    tmux attach-session -t "$session" 2>/dev/null || tmux new-session -s "$session"
}

# ---------------------------------------------------------------------------
#  §9  SHELL HISTORY ENGINE & TOOL INITIALIZATION
# ---------------------------------------------------------------------------

# Initialize Atuin SQLite history engine if available
if command -v atuin >/dev/null 2>&1; then
    _atuin_cache="${HOME}/.zsh/cache/atuin-init.zsh"
    if [[ ! -f "$_atuin_cache" || "$(command -v atuin)" -nt "$_atuin_cache" ]]; then
        atuin init zsh >| "$_atuin_cache" 2>/dev/null
    fi
    source "$_atuin_cache"
fi

# Initialize Zoxide directory frecent jump
if command -v zoxide >/dev/null 2>&1; then
    _zoxide_cache="${HOME}/.zsh/cache/zoxide-init.zsh"
    if [[ ! -f "$_zoxide_cache" || "$(command -v zoxide)" -nt "$_zoxide_cache" ]]; then
        zoxide init zsh --cmd cd >| "$_zoxide_cache" 2>/dev/null
    fi
    source "$_zoxide_cache"
fi

# ---------------------------------------------------------------------------
#  §10  ENVIRONMENT & PATH
# ---------------------------------------------------------------------------

if command -v nvim >/dev/null 2>&1; then
    export EDITOR='nvim'
    export VISUAL='nvim'
else
    export EDITOR='vim'
    export VISUAL='vim'
fi

export LESS_TERMCAP_mb=$'\e[1;35m'
export LESS_TERMCAP_md=$'\e[1;36m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[1;44;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;32m'

export MANROFFOPT="-c"
if command -v bat >/dev/null 2>&1; then
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
elif command -v batcat >/dev/null 2>&1; then
    export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
else
    export MANPAGER="less -s -M +Gg"
fi

export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

# Auto-compile .zshrc for speed
{
    local f
    for f in "${HOME}/.zshrc" "${HOME}/.zcompdump"; do
        if [[ -f "$f" && ( ! -f "${f}.zwc" || "$f" -nt "${f}.zwc" ) ]]; then
            zcompile "$f" 2>/dev/null
        fi
    done
} &!

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
. $HOME/export-esp.sh
