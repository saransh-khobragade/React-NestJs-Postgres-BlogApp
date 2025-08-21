#!/usr/bin/env bash
set -euo pipefail

echo "🔧 Setting up environment (macOS)"

# --- Required versions ---
REQUIRED_DOCKER_VERSION="20.10.22"
REQUIRED_COMPOSE_VERSION="2.13.0"
REQUIRED_NODE_VERSION="22.18.0"
REQUIRED_YARN_VERSION="1.22.19"

# --- Helpers ---
have() { command -v "$1" >/dev/null 2>&1; }

check_version() {
	local cmd="$1"
	local expected="$2"
	local actual="$3"
	local name="$4"

	if [[ "$actual" != "$expected" ]]; then
		echo "❌ $name version mismatch: expected $expected, found $actual"
		exit 1
	else
		echo "✅ $name version $actual OK"
	fi
}

# --- Homebrew ---
if ! have brew; then
	echo "📦 Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	eval "$($(brew --prefix)/bin/brew shellenv)"
fi

# --- Docker ---
if ! have docker; then
	echo "📦 Installing Docker Desktop..."
	brew install --cask docker
	echo "👉 Please open Docker Desktop manually after install."
fi

# Wait for Docker to be running
if ! docker info >/dev/null 2>&1; then
	open -a Docker || true
	echo "⌛ Waiting for Docker to start..."
	for i in {1..30}; do
		if docker info >/dev/null 2>&1; then break; fi
		sleep 1
	done
fi

# Check Docker version
docker_ver=$(docker -v | sed -n 's/Docker version \([0-9.]*\),.*/\1/p')
check_version "docker" "$REQUIRED_DOCKER_VERSION" "$docker_ver" "Docker"

# Check Docker Compose version
compose_ver=""
if have docker-compose; then
	compose_ver=$(docker-compose -v 2>/dev/null | sed -n 's/.*[Vv]\([0-9.]*\).*/\1/p')
	echo $compose_ver
else
	echo "❌ docker-compose not installed."
	exit 1
fi
check_version "docker-compose" "$REQUIRED_COMPOSE_VERSION" "$compose_ver" "Docker Compose"

# --- NVM & Node ---
export NVM_DIR="$HOME/.nvm"
if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
	echo "📦 Installing NVM..."
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi
source "$NVM_DIR/nvm.sh"

current_node=$(node -v 2>/dev/null | sed 's/^v//') || current_node=""
if [[ "$current_node" != "$REQUIRED_NODE_VERSION" ]]; then
	echo "📦 Installing Node.js $REQUIRED_NODE_VERSION via nvm..."
	nvm install "$REQUIRED_NODE_VERSION"
	nvm alias default "$REQUIRED_NODE_VERSION"
	nvm use default
fi
check_version "node" "$REQUIRED_NODE_VERSION" "$(node -v | sed 's/^v//')" "Node.js"

# --- Yarn via Corepack ---
if ! have corepack; then
	echo "❌ Corepack not found (should be included with Node $REQUIRED_NODE_VERSION)"
	exit 1
fi
corepack enable >/dev/null 2>&1 || true
corepack prepare "yarn@${REQUIRED_YARN_VERSION}" --activate

yarn_ver=$(yarn -v 2>/dev/null || echo "")
check_version "yarn" "$REQUIRED_YARN_VERSION" "$yarn_ver" "Yarn"

# --- Summary ---
echo ""
echo "✅ All dependencies installed with correct versions:"
echo " - Docker         $(docker -v)"
echo " - Docker Compose $(docker-compose -v)"
echo " - Node.js        $(node -v)"
echo " - Yarn           $(yarn -v)"
echo "Kill terminal and restart to apply changes."
