#!/bin/bash
# Universal PII Filter for Gemini CLI - Hardened Version
# Handles: BeforeAgent (Block), AfterTool (Redact), AfterModel (Redact)

input=$(cat)

# 1. Define sensitive patterns
PATTERNS=(
  'glpat-[a-zA-Z0-9_-]{20,}'
  'xox[bpars]-[0-9A-Za-z-]{10,}'
  '(AKIA|ASIA)[0-9A-Z]{16}'
  'Bearer\s+[a-zA-Z0-9\-\._~+/]+=*'
  # Broad match for sensitive variable assignments (Generic Keywords)
  '\b[a-zA-Z0-9_-]*(key|secret|token|password|passwd|auth|cred|pat|jti)[a-zA-Z0-9_-]*\s*[=:]\s*["\x27]?[a-zA-Z0-9+/=._~:-]{20,}\b'
  # Email Addresses
  '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'
  # Private/certificate keys
  '-----BEGIN (RSA |EC |OPENSSH |DSA |PGP )?PRIVATE KEY-----'
)

scrub() {
  local text="$1"
  for pattern in "${PATTERNS[@]}"; do
    local delim=$'\x01'
    # 'gi' for case-insensitive global match
    text=$(printf "%s" "$text" | perl -0777 -pe "s${delim}${pattern}${delim}[REDACTED]${delim}gi")
  done
  printf "%s" "$text"
}

# 2. Identify Event Type and Extract Content

EVENT=$(echo "$input" | jq -r '.hook_event_name')

if [ "$EVENT" = "BeforeAgent" ]; then
  content=$(echo "$input" | jq -r '.prompt')
  for pattern in "${PATTERNS[@]}"; do
    if echo "$content" | grep -qiE "$pattern"; then
      printf '{"decision":"deny","reason":"[SECURITY] Sensitive pattern detected (Email, Key, or Token). Prompt blocked for safety."}'
      exit 0
    fi
  done
  printf '{"decision":"allow"}'
  exit 0
fi

if [ "$EVENT" = "AfterTool" ]; then
  content=$(echo "$input" | jq -r '.tool_response.llmContent // empty')
  if [ -n "$content" ] && [ "$content" != "null" ]; then
    scrubbed=$(scrub "$content")
    if [ "$content" != "$scrubbed" ]; then
      jq -n --arg res "$scrubbed" '{"decision": "deny", "reason": $res}'
      exit 0
    fi
  fi
  printf '{"decision":"allow"}'
  exit 0
fi

if [ "$EVENT" = "AfterModel" ] || [ "$EVENT" = "AfterAgent" ]; then
  content=$(echo "$input" | jq -r '.llm_response.candidates[0].content.parts[0].text // .content // empty')
  if [ -n "$content" ] && [ "$content" != "null" ]; then
    scrubbed=$(scrub "$content")
    if [ "$content" != "$scrubbed" ]; then
      modified_response=$(echo "$input" | jq --arg res "$scrubbed" '.llm_response | .candidates[0].content.parts[0].text = $res | .candidates[0].content.parts[0].content = $res')
      jq -n --argjson mod "$modified_response" '{"hookSpecificOutput": {"llm_response": $mod}}'
      exit 0
    fi
  fi
  printf '{"decision":"allow"}'
  exit 0
fi

# Fallback
printf '{"decision":"allow"}'
