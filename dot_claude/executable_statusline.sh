#!/usr/bin/env bash
# Claude Code status line: directory on the left, git branch and state on the right,
# then a second row with the context used and the subscription limits.
export LC_ALL=C.UTF-8 # ${#var} counts ↑ and ↓ as one column
esc=$'\033'
input=$(cat)
dir=$(jq -r '.workspace.current_dir' <<<"$input")
path=${dir/#$HOME/\~}

# Account palette: perso is blue and magenta, pro (see ~/.claude-profiles.zsh) amber and coral.
path_color=34 branch_color=35
if [[ ${CLAUDE_CONFIG_DIR%/} == "$HOME/.claude-pro" ]]; then
  path_color='38;5;214' branch_color='38;5;209'
fi

# Each value is rounded, or "-" while Claude Code does not report it yet.
read -r context tokens size five five_reset week week_reset <<<"$(jq -r '
  [.context_window.used_percentage, .context_window.total_input_tokens, .context_window.context_window_size,
   .rate_limits.five_hour.used_percentage, .rate_limits.five_hour.resets_at,
   .rate_limits.seven_day.used_percentage, .rate_limits.seven_day.resets_at]
  | map(if . == null then "-" else round | tostring end) | join(" ")' <<<"$input")"
token_count() {
  if (($1 >= 1000000)); then printf '%dM' $(($1 / 1000000)); else printf '%dk' $(($1 / 1000)); fi
}
until_reset() {
  local left=$(($1 - EPOCHSECONDS))
  ((left < 0)) && left=0
  if ((left >= 86400)); then printf '%dj%dh' $((left / 86400)) $((left % 86400 / 3600))
  elif ((left >= 3600)); then printf '%dh%02dm' $((left / 3600)) $((left % 3600 / 60))
  else printf '%dm' $((left / 60)); fi
}
usage=
usage_segment() { # label, then an 8-cell gauge and the value green, amber past half or red past 80%, then an optional note
  local color=32 gauge= i
  (($1 >= 50)) && color=33
  (($1 >= 80)) && color=31
  for ((i = 0; i < 8; i++)); do
    if ((i < ($1 * 8 + 50) / 100)); then gauge+=▰; else gauge+=▱; fi
  done
  usage+="${usage:+ $esc[90m·$esc[0m }$2 $esc[${color}m$gauge $3$esc[0m${4:+ $4}"
}
[[ $context != - ]] && usage_segment "$context" contexte "$(token_count "$tokens")/$(token_count "$size")"
[[ $five != - ]] && usage_segment "$five" 5h "$five%" "↻$(until_reset "$five_reset")"
[[ $week != - ]] && usage_segment "$week" 7j "$week%" "↻$(until_reset "$week_reset")"
usage_row=${usage:+$'\n'$usage}

if ! status=$(git -C "$dir" --no-optional-locks status --porcelain=v2 --branch 2>/dev/null); then
  printf '%s%s' "$esc[${path_color}m$path$esc[0m" "$usage_row"
  exit 0
fi

ahead=0 behind=0 staged=0 modified=0 untracked=0 conflicts=0
while read -r kind a b c _; do
  case $kind in
    '#')
      case $a in
        branch.oid) oid=$b ;;
        branch.head) branch=$b ;;
        branch.ab) ahead=${b#+} behind=${c#-} ;;
      esac ;;
    1 | 2)
      [[ ${a:0:1} != . ]] && staged=$((staged + 1))
      [[ ${a:1:1} != . ]] && modified=$((modified + 1)) ;;
    u) conflicts=$((conflicts + 1)) ;;
    '?') untracked=$((untracked + 1)) ;;
  esac
done <<<"$status"
[[ $branch == '(detached)' ]] && branch=${oid:0:8}

# Plain text measures the gap; the colored copy is what gets printed.
right=$branch
colored="$esc[${branch_color}m$branch$esc[0m"
segment() {
  right+=" $2"
  colored+=" $esc[$1m$2$esc[0m"
}
((ahead)) && segment 36 "↑$ahead"
((behind)) && segment 36 "↓$behind"
((conflicts)) && segment 31 "!$conflicts"
((staged)) && segment 32 "+$staged"
((modified)) && segment 33 "~$modified"
((untracked)) && segment 90 "?$untracked"

# Claude Code sets COLUMNS; keep a margin for the row's built-in spacing.
gap=$((${COLUMNS:-80} - 4 - ${#path} - ${#right}))
((gap < 1)) && gap=1
printf '%s%*s%s%s' "$esc[${path_color}m$path$esc[0m" "$gap" "" "$colored" "$usage_row"
