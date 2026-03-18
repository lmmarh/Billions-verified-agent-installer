#!/bin/bash

# Verified Agent Identity Installer for IMMADEFI
# Customized installation script with user input

set -e

echo "=========================================="
echo "Installing Verified Agent for IMMADEFI"
echo "=========================================="
echo ""

# Ask user for agent details
read -p "Enter your Agent Name: " AGENT_NAME
read -p "Enter your Agent Description: " AGENT_DESCRIPTION

echo ""
echo "Agent Name: $AGENT_NAME"
echo "Agent Description: $AGENT_DESCRIPTION"
echo ""

# Step 1: Install Node.js and Git (if not already present)
if ! command -v node &> /dev/null; then
    echo "Installing Node.js..."
    pkg update && pkg upgrade -y
    pkg install -y nodejs
fi

if ! command -v git &> /dev/null; then
    echo "Installing Git..."
    pkg install -y git
fi

# Verify installations
echo "Node.js version: $(node -v)"
echo "Git version: $(git -v)"

# Step 2: Clone the Repository
echo "Cloning verified-agent-identity repository..."
git clone https://github.com/BillionsNetwork/verified-agent-identity
cd verified-agent-identity

# Step 3: Install Dependencies
echo "Installing dependencies..."
npx clawhub@latest install verified-agent-identity

# Step 4: Install Common Missing Modules
echo "Installing missing modules..."
npm install shell-quote @iden3/js-iden3-auth ethers@6 uuid

# Step 5: Create Agent Ethereum Identity
echo "Creating Agent Ethereum Identity..."
node scripts/createNewEthereumIdentity.js

# Step 6: Link Human Identity with Agent
echo "Linking Human Identity with Agent..."
node scripts/manualLinkHumanToAgent.js --challenge "{\"name\":\"$AGENT_NAME\",\"description\":\"$AGENT_DESCRIPTION\"}"

echo "=========================================="
echo "Setup Complete for $AGENT_NAME!"
echo "=========================================="
echo "Your agent is now linked to Billions Network!"
