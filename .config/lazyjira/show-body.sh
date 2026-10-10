#!/usr/bin/env bash
# Render an issue's description in mcat.
# Usage: show-body.sh <ISSUE_KEY>
set -euo pipefail

here=$(dirname "$(readlink -f "$0")")
tmp=""
cleanup() { rc=$?; [[ -n $tmp ]] && rm -f "$tmp"; [[ $rc -ne 0 ]] && read -r -n1 -p "(exit $rc) press any key..."; }
trap cleanup EXIT

source "$here/_jira-common.sh"

key=${1:?issue key required}
_jira_load_auth

issue=$(curl -sS "${auth[@]}" \
  "$host/rest/api/$api/issue/$key?fields=summary,description,issuetype,status,assignee,parent")

if ! summary=$(jq -er '.fields.summary' <<<"$issue" 2>/dev/null); then
  echo "Could not read $key:"; jq . <<<"$issue" 2>/dev/null || echo "$issue"; exit 1
fi

itype=$(jq -r '.fields.issuetype.name // "?"'      <<<"$issue")
status=$(jq -r '.fields.status.name // "?"'        <<<"$issue")
who=$(jq -r '.fields.assignee.displayName // "Unassigned"' <<<"$issue")
parent=$(jq -r '.fields.parent.key // ""'          <<<"$issue")

tmp=$(mktemp --suffix=.md)
{
  echo "# $key — $summary"
  echo
  printf '`%s`  ·  `%s`  ·  %s' "$itype" "$status" "$who"
  [[ -n $parent ]] && printf '  ·  parent %s' "$parent"
  echo; echo; echo "---"; echo
  jq -c '.fields.description' <<<"$issue" | python3 "$here/adf2md.py"
} > "$tmp"

mcat -p "$tmp"
