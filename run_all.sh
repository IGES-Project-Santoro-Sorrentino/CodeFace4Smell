#!/usr/bin/env bash
set -euo pipefail

CODEFACE_CONF="codeface.conf"
RESULTS_DIR="results"
GIT_DIR="git-repos"

./start_server.sh

for CONF in conf/*.conf; do
  # Estrai la dir del repo dal .conf (riga 'repo: <dir>')
  REPO_DIR=$(awk -F': *' '/^[[:space:]]*repo[[:space:]]*:/ {print $2; exit}' "$CONF" | sed 's/#.*//' | xargs)

  if [[ -z "${REPO_DIR:-}" ]]; then
    echo "⚠️  Skip $CONF: campo 'repo:' mancante."
    continue
  fi

  if [[ ! -d "$GIT_DIR/$REPO_DIR/.git" ]]; then
    echo "⚠️  Skip $CONF: repo '$GIT_DIR/$REPO_DIR' non è un git repo (manca .git)."
    echo "    Clona prima:  git clone <URL> $GIT_DIR/$REPO_DIR"
    continue
  fi

  echo "▶️  Analizzo $CONF (repo: $REPO_DIR)..."
  codeface -j8 run -c "$CODEFACE_CONF" -p "$CONF" "$RESULTS_DIR" "$GIT_DIR"
done

./deploy-shiny-nginx.sh
