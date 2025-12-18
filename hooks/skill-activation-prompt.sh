#!/bin/bash
# Skill Auto-Activation Hook
# Triggers on UserPromptSubmit to suggest relevant skills based on keywords

set -e

SKILLS_DIR="$HOME/.claude/skills"
RULES_FILE="$SKILLS_DIR/skill-rules.json"

# Read input from stdin
INPUT=$(cat)

# Extract prompt from input JSON
PROMPT=$(echo "$INPUT" | jq -r '.prompt // empty' 2>/dev/null)

# If no prompt or rules file missing, exit silently
if [ -z "$PROMPT" ] || [ ! -f "$RULES_FILE" ]; then
    exit 0
fi

# Convert prompt to lowercase for matching
PROMPT_LOWER=$(echo "$PROMPT" | tr '[:upper:]' '[:lower:]')

# Function to check if any keyword matches
check_keywords() {
    local skill_name="$1"
    local keywords_json="$2"

    # Extract keywords array and check each
    echo "$keywords_json" | jq -r '.[]' 2>/dev/null | while read -r keyword; do
        keyword_lower=$(echo "$keyword" | tr '[:upper:]' '[:lower:]')
        if echo "$PROMPT_LOWER" | grep -qi "$keyword_lower"; then
            echo "$skill_name"
            return 0
        fi
    done
}

# Find matching skills
MATCHED_SKILLS=""

# Read skills from rules file
SKILLS_COUNT=$(jq '.skills | length' "$RULES_FILE" 2>/dev/null)

for i in $(seq 0 $((SKILLS_COUNT - 1))); do
    SKILL_NAME=$(jq -r ".skills[$i].name" "$RULES_FILE")
    SKILL_DESC=$(jq -r ".skills[$i].description" "$RULES_FILE")
    KEYWORDS=$(jq ".skills[$i].triggers.keywords" "$RULES_FILE")

    # Check each keyword
    while IFS= read -r keyword; do
        keyword_clean=$(echo "$keyword" | tr -d '"')
        keyword_lower=$(echo "$keyword_clean" | tr '[:upper:]' '[:lower:]')

        if [ -n "$keyword_lower" ] && echo "$PROMPT_LOWER" | grep -qi "$keyword_lower"; then
            if [ -z "$MATCHED_SKILLS" ]; then
                MATCHED_SKILLS="$SKILL_NAME"
            else
                # Avoid duplicates
                if ! echo "$MATCHED_SKILLS" | grep -q "$SKILL_NAME"; then
                    MATCHED_SKILLS="$MATCHED_SKILLS,$SKILL_NAME"
                fi
            fi
            break
        fi
    done < <(echo "$KEYWORDS" | jq -r '.[]' 2>/dev/null)
done

# If skills matched, output suggestion
if [ -n "$MATCHED_SKILLS" ]; then
    # Format as comma-separated list for display
    SKILL_LIST=$(echo "$MATCHED_SKILLS" | tr ',' '\n' | while read -r s; do
        desc=$(jq -r ".skills[] | select(.name == \"$s\") | .description" "$RULES_FILE")
        echo "  • $s: $desc"
    done)

    # Output as JSON message to be displayed
    cat << EOF
{
  "result": "continue",
  "message": "💡 检测到相关 Skill:\n$SKILL_LIST\n\n提示: 我会参考对应的 Skill 指南来回答。"
}
EOF
fi
