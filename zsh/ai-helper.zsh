# ==============================================================================
# Minimal zsh/ai-helper.zsh — AI Natural Language Shell Translator
# Bridges plain-English requests to Zsh commands using sgpt or local Ollama.
# Inserts the generated command into $BUFFER without auto-executing.
# ==============================================================================

ai_helper() {
    local user_prompt=""
    
    # Use current line buffer as prompt if not empty, otherwise read from prompt
    if [[ -n "$BUFFER" ]]; then
        user_prompt="$BUFFER"
    else
        # Prompt user interactively if buffer is empty
        vared -p "🤖 AI Shell Prompt: " -c user_prompt
    fi

    if [[ -z "$user_prompt" ]]; then
        zle redisplay
        return 0
    fi

    local generated_cmd=""

    # 1. Try local Ollama API first (qwen2.5-coder / llama3) — no data leaves the box
    if curl -s --connect-timeout 1 http://localhost:11434/api/tags >/dev/null 2>&1; then
        local sys_prompt="You are a Linux Zsh CLI command generator. Translate the natural language request into a single executable Zsh command. Return ONLY the exact command string. Do not include markdown code blocks, backticks, or extra explanation."
        local full_prompt="${sys_prompt}

Request: ${user_prompt}"
        local payload=""
        if command -v jq >/dev/null 2>&1; then
            payload=$(jq -n --arg model "qwen2.5-coder" --arg prompt "$full_prompt" '{model: $model, prompt: $prompt, stream: false}')
        fi

        if [[ -n "$payload" ]]; then
            local response
            response=$(curl -s -X POST http://localhost:11434/api/generate \
                -H "Content-Type: application/json" \
                -d "$payload" 2>/dev/null)

            if command -v jq >/dev/null 2>&1; then
                generated_cmd=$(echo "$response" | jq -r '.response // empty' 2>/dev/null)
            fi
        fi

    # 2. Fallback to sgpt (Shell-GPT) — external API, only if Ollama unavailable
    elif command -v sgpt >/dev/null 2>&1; then
        generated_cmd=$(sgpt --shell --no-md "$user_prompt" 2>/dev/null)
    fi

    # Unified sanitization: strip ANSI escapes, backtick fences, CRs, and surrounding whitespace.
    # Uses only POSIX sed and tr — no external binaries.
    if [[ -n "$generated_cmd" ]]; then
        generated_cmd=$(echo "$generated_cmd" \
            | sed -E 's/\x1B\[[0-9;]*[a-zA-Z]//g' \
            | sed 's/^```[a-z]*//; s/^```//; s/```$//' \
            | sed 's/^`//; s/`$//; s/^bash //; s/^zsh //' \
            | tr -d '\r' \
            | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    fi

    if [[ -n "$generated_cmd" ]]; then
        BUFFER="$generated_cmd"
        CURSOR=${#BUFFER}
    else
        # Inform user cleanly if no AI backend is available
        BUFFER="# AI Helper: Install sgpt (aur/shell-gpt) or run Ollama locally on port 11434"
        CURSOR=${#BUFFER}
    fi

    zle redisplay
}

zle -N ai_helper

# Bind Alt+E (\ee) and Ctrl+G (^G) to AI shell helper
bindkey '\ee' ai_helper
bindkey '^G'  ai_helper
