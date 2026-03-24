#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to check command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        echo "windows"
    else
        echo "unknown"
    fi
}

# Function to open browser
open_browser() {
    local url=$1
    local os=$(detect_os)
    
    case $os in
        "macos")
            open "$url"
            ;;
        "linux")
            xdg-open "$url" >/dev/null 2>&1 || echo "Could not open browser. Please visit: $url"
            ;;
        "windows")
            start "$url"
            ;;
        *)
            echo "Please visit: $url"
            ;;
    esac
}

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   Blinko - One Click Setup${NC}"
echo -e "${BLUE}========================================${NC}"
echo

# Check if Docker is installed and running
if ! command_exists docker; then
    echo -e "${RED}ERROR: Docker is not installed!${NC}"
    echo "Please install Docker Desktop:"
    echo "  • Mac: https://docs.docker.com/docker-for-mac/"
    echo "  • Linux: https://docs.docker.com/engine/install/"
    echo "  • Windows: https://docs.docker.com/docker-for-windows/"
    echo
    echo "After installing Docker, run this script again."
    exit 1
fi

# Check if Docker daemon is running
if ! docker info >/dev/null 2>&1; then
    echo -e "${RED}ERROR: Docker is not running!${NC}"
    echo "Please start Docker Desktop and wait for it to fully load."
    echo "Then run this script again."
    exit 1
fi

echo -e "${GREEN}✓ Docker found and running${NC}"
echo

# Step 1: Create environment file
echo -e "${YELLOW}[1/4] Setting up environment configuration...${NC}"
if [ ! -f ".env" ]; then
    cp .env.example .env
    echo -e "${GREEN}   ✓ Environment file created${NC}"
else
    echo -e "${YELLOW}   ✓ Environment file already exists${NC}"
fi

# Step 2: Setup Docker network
echo -e "${YELLOW}[2/4] Setting up Docker network...${NC}"
if ! docker network ls | grep -q blinko-network; then
    docker network create blinko-network
    echo -e "${GREEN}   ✓ Network created${NC}"
else
    echo -e "${YELLOW}   ✓ Network already exists${NC}"
fi

# Step 3: Start PostgreSQL
echo -e "${YELLOW}[3/4] Starting PostgreSQL database...${NC}"
if ! docker ps -a | grep -q blinko-postgres; then
    docker run -d \
      --name blinko-postgres \
      --network blinko-network \
      -p 5432:5432 \
      -e POSTGRES_DB=postgres \
      -e POSTGRES_USER=postgres \
      -e POSTGRES_PASSWORD=mysecretpassword \
      --restart always \
      postgres:14 >/dev/null 2>&1
    echo -e "${GREEN}   ✓ PostgreSQL started${NC}"
else
    if ! docker ps | grep -q blinko-postgres; then
        docker start blinko-postgres >/dev/null 2>&1
        echo -e "${GREEN}   ✓ PostgreSQL restarted${NC}"
    else
        echo -e "${YELLOW}   ✓ PostgreSQL already running${NC}"
    fi
fi

# Step 4: Build and run Blinko
echo -e "${YELLOW}[4/4] Building and starting Blinko...${NC}"
echo -e "${YELLOW}   Building Docker image (this may take a few minutes)...${NC}"

if ! docker build -t blinko-local . >/dev/null 2>&1; then
    echo -e "${RED}ERROR: Failed to build Blinko image${NC}"
    echo "Please check the error messages above and try again."
    exit 1
fi

echo -e "${GREEN}   ✓ Build completed${NC}"

# Stop and remove existing container
docker stop blinko-website >/dev/null 2>&1
docker rm blinko-website >/dev/null 2>&1

# Start new container
docker run -d \
  --name blinko-website \
  --network blinko-network \
  -p 1111:1111 \
  -e NODE_ENV=production \
  -e NEXTAUTH_SECRET=my_ultra_secure_nextauth_secret \
  -e DATABASE_URL=postgresql://postgres:mysecretpassword@blinko-postgres:5432/postgres \
  --env-file .env \
  --restart always \
  blinko-local >/dev/null 2>&1

if [ $? -ne 0 ]; then
    echo -e "${RED}ERROR: Failed to start Blinko container${NC}"
    exit 1
fi

echo -e "${GREEN}   ✓ Blinko started${NC}"

# Wait for application to be ready
echo -e "${YELLOW}Waiting for Blinko to be ready...${NC}"
for i in {1..30}; do
    if curl -s http://localhost:1111 >/dev/null 2>&1; then
        echo -e "${GREEN}   ✓ Blinko is ready!${NC}"
        break
    fi
    echo -n "."
    sleep 2
done
echo

echo
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}   SETUP COMPLETE! 🎉${NC}"
echo -e "${BLUE}========================================${NC}"
echo
echo -e "${GREEN}Application is now running at:${NC}"
echo -e "${BLUE}http://localhost:1111${NC}"
echo
echo -e "${GREEN}Features:${NC}"
echo -e "  ✓ AI Chat (pre-configured)"
echo -e "  ✓ AI Embedding"
echo -e "  ✓ AI Tools"
echo -e "  ✓ Web Search"
echo -e "  ✓ Database ready"
echo

# Ask to open browser
echo -n "Open Blinko in browser? (y/n): "
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    open_browser "http://localhost:1111"
fi

echo
echo -e "${YELLOW}Note: Replace demo API keys in .env file for production use${NC}"
echo -e "${GREEN}Enjoy using Blinko!${NC}"
