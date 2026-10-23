
#!/usr/bin/env bash
set -euo pipefail

echo "=== Setting up JFrog Agent Plugin ==="

# Require Node.js 22+
if ! command -v node >/dev/null 2>&1; then
  echo "ERROR: Node.js is not installed."
  exit 1
fi

NODE_MAJOR="$(node -p 'process.versions.node.split(".")[0]')"
if [ "$NODE_MAJOR" -lt 22 ]; then
  echo "ERROR: Node.js 22+ is required by Copilot CLI."
  exit 1
fi

# Install GitHub Copilot CLI if missing
if ! command -v copilot >/dev/null 2>&1; then
  npm install -g @github/copilot
fi

# Register the official JFrog plugin marketplace
if ! copilot plugin marketplace list 2>/dev/null \
  | grep -Fq 'jfrog-agent-plugins'; then
  copilot plugin marketplace add jfrog/vscode-plugin
fi

# Install the JFrog plugin if missing
if ! copilot plugin list 2>/dev/null \
  | grep -Fq 'jfrog'; then
  copilot plugin install jfrog@jfrog-agent-plugins
fi

echo "=== Installed Copilot plugins ==="
copilot plugin list
echo "=== JFrog setup check completed ==="
