# Sourced by lazyjira custom-command scripts. Not executable on its own.
# Sets: host, email, token, stype, api, and the `auth` array for curl.

_jira_load_auth() {
  local AUTH="${LAZYJIRA_CONFIG_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/lazyjira}/auth.json"

  # Env vars win; otherwise fall back to lazyjira's auth.json.
  if [[ -r $AUTH ]]; then
    host=${JIRA_HOST:-$(jq -r '.host // empty' "$AUTH")}
    email=${JIRA_EMAIL:-$(jq -r '.email // empty' "$AUTH")}
    token=${JIRA_API_TOKEN:-$(jq -r '.token // empty' "$AUTH")}
    stype=${JIRA_SERVER_TYPE:-$(jq -r '.server_type // "cloud"' "$AUTH")}
  else
    host=${JIRA_HOST:-} email=${JIRA_EMAIL:-} token=${JIRA_API_TOKEN:-} stype=${JIRA_SERVER_TYPE:-cloud}
  fi

  [[ -n $host  ]] || { echo "No Jira host: set JIRA_HOST or check $AUTH"; return 1; }
  [[ -n $token ]] || { echo "No API token: set JIRA_API_TOKEN or check $AUTH"; return 1; }
  host=${host%/}

  # Cloud uses REST v3 + Basic auth + ADF; Server/DC uses v2 + Bearer + plain text.
  if [[ $stype == cloud ]]; then
    api=3; auth=(-u "$email:$token")
  else
    api=2; auth=(-H "Authorization: Bearer $token")
  fi
}
