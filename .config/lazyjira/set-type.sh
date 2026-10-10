#!/usr/bin/env bash
# Change an issue's type.
# Usage: set-type.sh <ISSUE_KEY> <NEW_TYPE> [OTHER_TYPE]
#   With OTHER_TYPE, acts as a toggle: if the issue is already NEW_TYPE it
#   becomes OTHER_TYPE, and vice versa.
set -euo pipefail

cleanup() { rc=$?; [[ $rc -ne 0 ]] && read -r -n1 -p "(exit $rc) press any key..."; }
trap cleanup EXIT

source "$(dirname "$(readlink -f "$0")")/_jira-common.sh"

key=${1:?issue key required}
target=${2:?target issue type required}
other=${3:-}

_jira_load_auth

issue=$(curl -sS "${auth[@]}" "$host/rest/api/$api/issue/$key?fields=summary,issuetype,parent")
if ! current=$(jq -er '.fields.issuetype.name' <<<"$issue" 2>/dev/null); then
  echo "Could not read $key:"; jq . <<<"$issue" 2>/dev/null || echo "$issue"; exit 1
fi
summary=$(jq -r '.fields.summary // ""' <<<"$issue")

# Toggle mode: flip to the other type when already on the target.
if [[ -n $other && $current == "$target" ]]; then
  target=$other
fi

if [[ $current == "$target" ]]; then
  echo "$key is already a $current — nothing to do."
  read -r -n1 -p "Press any key to return to lazyjira..."
  exit 0
fi

echo "$key  $summary"
echo "  $current  ->  $target"
read -r -n1 -p "Change type? [y/N] " reply; echo
[[ $reply == [yY] ]] || { echo "Aborted."; exit 0; }

payload=$(jq -n --arg t "$target" '{fields:{issuetype:{name:$t}}}')
resp=$(curl -sS -w '\n%{http_code}' "${auth[@]}" -X PUT \
  "$host/rest/api/$api/issue/$key" \
  -H 'Content-Type: application/json' -d "$payload")
code=$(tail -n1 <<<"$resp"); body=$(sed '$d' <<<"$resp")

if [[ $code == 2* ]]; then
  echo "$key is now a $target"
else
  echo "Failed (HTTP $code):"
  jq -r '.errorMessages[]?, (.errors // {} | to_entries[] | "\(.key): \(.value)")' <<<"$body" 2>/dev/null \
    || echo "$body"
fi
read -r -n1 -p "Press any key to return to lazyjira..."
