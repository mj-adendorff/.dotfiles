#!/usr/bin/env bash
# List GitHub PRs whose title mentions the issue key; Enter opens one in the browser.
# Usage: view-prs.sh <ISSUE_KEY>
set -euo pipefail

cleanup() { rc=$?; [[ $rc -ne 0 ]] && read -r -n1 -p "(exit $rc) press any key..."; }
trap cleanup EXIT

owner=QuicklySign   # GitHub org to search
key=${1:?issue key required}

# gh search matches tokens loosely (QS-6456 also hits QS-6457 bodies), so
# restrict to titles and re-filter for the exact key.
rows=$(gh search prs "$key" --owner "$owner" --match title --limit 50 \
  --json number,title,state,url,isDraft,repository,updatedAt \
  | jq -r --arg k "$key" '
    .[] | select(.title | test("\\b" + $k + "\\b"))
    | [.url, .repository.name, "#\(.number)",
       (.state + (if .isDraft then " (draft)" else "" end)), .updatedAt[:10], .title] | @tsv')

if [[ -z $rows ]]; then
  read -r -n1 -p "No PRs in $owner mention $key in the title. Press any key..."
  exit 0
fi

selected=$(column -t -s$'\t' -o'  ' <<<"$rows" \
  | fzf --with-nth=2.. --prompt="$key PRs > " --header='Enter: open in browser   Esc: back') || exit 0
gh pr view --web "${selected%% *}"
