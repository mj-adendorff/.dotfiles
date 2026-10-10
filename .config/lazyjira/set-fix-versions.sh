#!/usr/bin/env bash
# Replace an issue's fix versions with an fzf multi-selection.
# Usage: set-fix-versions.sh <PROJECT_KEY> <ISSUE_KEY>
#   Tab marks/unmarks versions; Enter applies the marked set; Esc aborts.
#   Versions currently on the issue are shown with a leading '*'.
set -euo pipefail

cleanup() { rc=$?; [[ $rc -ne 0 ]] && read -r -n1 -p "(exit $rc) press any key..."; }
trap cleanup EXIT

source "$(dirname "$(readlink -f "$0")")/_jira-common.sh"

project=${1:?project key required}
key=${2:?issue key required}

_jira_load_auth

current=$(curl -sS "${auth[@]}" "$host/rest/api/$api/issue/$key?fields=fixVersions" \
  | jq -r '.fields.fixVersions[]?.id')

# Unarchived versions, unreleased first, newest first within each group.
choices=$(curl -sS "${auth[@]}" "$host/rest/api/$api/project/$project/versions" \
  | jq -r --arg cur "$current" '
      ($cur | split("\n")) as $set
      | map(select(.archived == false))
      | sort_by(.released, (.releaseDate // "" | explode | map(-.)))
      | .[] | "\(.id)\t\(if IN(.id; $set[]) then "*" else " " end) \(.name)\(if .released then "  (released)" else "" end)"')

selected=$(fzf --multi --with-nth=2.. --delimiter='\t' --prompt="$key fix versions > " \
  --header='Tab: mark   Enter: apply marked set   Esc: abort' <<<"$choices") || { echo "Aborted."; exit 0; }

ids=$(cut -f1 <<<"$selected" | jq -R . | jq -s 'map({id: .})')
payload=$(jq -n --argjson v "$ids" '{fields:{fixVersions:$v}}')
resp=$(curl -sS -w '\n%{http_code}' "${auth[@]}" -X PUT \
  "$host/rest/api/$api/issue/$key" \
  -H 'Content-Type: application/json' -d "$payload")
code=$(tail -n1 <<<"$resp"); body=$(sed '$d' <<<"$resp")

if [[ $code == 2* ]]; then
  echo "$key fix versions set to:"; cut -f2 <<<"$selected" | sed 's/^[* ] /  /'
else
  echo "Failed (HTTP $code):"
  jq -r '.errorMessages[]?, (.errors // {} | to_entries[] | "\(.key): \(.value)")' <<<"$body" 2>/dev/null \
    || echo "$body"
fi
read -r -n1 -p "Press any key to return to lazyjira..."
