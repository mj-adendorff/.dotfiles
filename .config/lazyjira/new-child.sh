#!/usr/bin/env bash
# Create a child issue under a parent, prompting for summary and description.
# Usage: new-child.sh <PROJECT_KEY> <PARENT_KEY> <ISSUE_TYPE> [--no-desc]
#   --no-desc  skip the $EDITOR description step (summary only)
set -euo pipefail

# Keep any failure on screen; the TUI redraws over it otherwise.
tmp=""
cleanup() { rc=$?; [[ -n $tmp ]] && rm -f "$tmp"; [[ $rc -ne 0 ]] && read -r -n1 -p "(exit $rc) press any key..."; }
trap cleanup EXIT

source "$(dirname "$(readlink -f "$0")")/_jira-common.sh"

project=${1:?project key required}
parent=${2:?parent key required}
itype=${3:?issue type required}
want_desc=1
[[ ${4:-} == --no-desc ]] && want_desc=0

_jira_load_auth

echo "New $itype under $parent"
read -r -p "Summary: " summary
[[ -n $summary ]] || { echo "Aborted: empty summary"; exit 1; }

# Description via $EDITOR, unless --no-desc. Save empty to skip it.
desc=""
if (( want_desc )); then
  tmp=$(mktemp --suffix=.md)
  cat > "$tmp" <<TPL

# Lines starting with '#' are ignored.
# Write the description for: $summary
# Save an otherwise empty file to create the $itype with no description.
TPL
  "${VISUAL:-${EDITOR:-vi}}" "$tmp"
  desc=$(grep -v '^#' "$tmp" | sed -e '/./,$!d')   # strip comments and leading blank lines
fi

payload=$(jq -n --arg p "$project" --arg par "$parent" --arg t "$itype" --arg s "$summary" \
  '{fields:{project:{key:$p},parent:{key:$par},issuetype:{name:$t},summary:$s}}')

if [[ -n ${desc//[[:space:]]/} ]]; then
  if [[ $api == 3 ]]; then
    adf=$(jq -Rs '{type:"doc",version:1,
                   content:( split("\n\n")
                             | map(sub("^\\s+";"") | sub("\\s+$";""))
                             | map(select(length > 0))
                             | map({type:"paragraph",content:[{type:"text",text:.}]}) )}' <<<"$desc")
    payload=$(jq --argjson d "$adf" '.fields.description = $d' <<<"$payload")
  else
    payload=$(jq --arg d "$desc" '.fields.description = $d' <<<"$payload")
  fi
fi

resp=$(curl -sS "${auth[@]}" -X POST "$host/rest/api/$api/issue" \
  -H 'Content-Type: application/json' -d "$payload")

if key=$(jq -er '.key' <<<"$resp" 2>/dev/null); then
  echo "Created $key  ->  $host/browse/$key"
else
  echo "Failed:"; jq . <<<"$resp" 2>/dev/null || echo "$resp"
fi
read -r -n1 -p "Press any key to return to lazyjira..."
