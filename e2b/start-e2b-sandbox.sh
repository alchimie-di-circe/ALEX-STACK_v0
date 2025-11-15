#!/bin/bash

# Start E2B Sandbox Script
# This script provides an easy way to start the E2B sandbox with GitHub Copilot CLI

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}E2B Sandbox Launcher${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed${NC}"
    echo "Please install Docker first: https://docs.docker.com/get-docker/"
    exit 1
fi

# Detect script directory and project root
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"

# Check if the image exists, if not build it
if ! docker image inspect alex-stack-e2b:latest &> /dev/null; then
    echo -e "${YELLOW}Docker image not found. Building...${NC}"
    (cd "$SCRIPT_DIR" && docker build -f Dockerfile.e2b -t alex-stack-e2b:latest .)
    echo -e "${GREEN}Build complete!${NC}"
    echo ""
else
    # Check if Dockerfile is newer than the image
    if [[ "$SCRIPT_DIR/Dockerfile.e2b" -nt $(docker image inspect -f '{{.Created}}' alex-stack-e2b:latest) ]]; then
        echo -e "${YELLOW}Dockerfile.e2b has been updated. Consider rebuilding the image with 'docker build -f e2b/Dockerfile.e2b -t alex-stack-e2b:latest .'${NC}"
        echo ""
    fi
fi

# Check for environment variables
ENV_ARGS=""
if [ -n "$GITHUB_TOKEN" ]; then
    ENV_ARGS="$ENV_ARGS -e GITHUB_TOKEN=$GITHUB_TOKEN"
    echo -e "${GREEN}✓${NC} GITHUB_TOKEN found"
else
    echo -e "${YELLOW}⚠${NC}  GITHUB_TOKEN not set"
fi

if [ -n "$JINA_API_KEY" ]; then
    ENV_ARGS="$ENV_ARGS -e JINA_API_KEY=$JINA_API_KEY"
    echo -e "${GREEN}✓${NC} JINA_API_KEY found"
else
    echo -e "${YELLOW}⚠${NC}  JINA_API_KEY not set (optional)"
fi

echo ""
echo -e "${GREEN}Starting E2B sandbox...${NC}"
echo ""

# Run the container
docker run -it --rm \
    -v "$(pwd):/workspace" \
    $ENV_ARGS \
    -p 8080:8080 \
    -p 8081:8081 \
    --name alex-copilot-sandbox \
    alex-stack-e2b:latest

echo ""
echo -e "${GREEN}Sandbox stopped${NC}"
