#!/usr/bin/env bash
set -e

# Purge a secret from the repository history using git-filter-repo.
# WARNING: This rewrites history. Coordinate with collaborators. Back up your repo first.
# Usage: ./scripts/purge-secret.sh "<secret-to-remove>"

if [ -z "$1" ]; then
  echo "Usage: $0 '<secret-to-remove>'"
  exit 1
fi

SECRET="$1"

if ! command -v git-filter-repo >/dev/null 2>&1; then
  echo "git-filter-repo is not installed. Install it: https://github.com/newren/git-filter-repo#installation"
  exit 1
fi

cat > /tmp/replacements.txt <<EOF
# Replacements format: <old>==<new>
$SECRET==[REDACTED]
EOF

# Run filter-repo to replace secret across history
git filter-repo --replace-text /tmp/replacements.txt

rm -f /tmp/replacements.txt

echo "Secret replacement complete. Review history, then force-push cleaned branches (e.g. 'git push --force origin main')."
