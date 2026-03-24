#!/bin/bash

# Colors for better visibility
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🚀 Building Blinko from local source code...${NC}"

# Step 1: Set up environment file
echo -e "${YELLOW}1. 📝 Setting up environment configuration...${NC}"
if [ ! -f ".env" ]; then
    cp .env.example .env
    echo -e "${GREEN}✅ Environment file created from template${NC}"
else
    echo -e "${YELLOW}⚠️  Environment file already exists, skipping creation${NC}"
fi

# Step 2: Check if the network 'blinko-network' already exists
if [ ! "$(docker network ls -q -f name=blinko-network)" ]; then
    echo -e "${YELLOW}Network 'blinko-network' does not exist. Creating network...${NC}"
    docker network create blinko-network

    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to create Docker network. Please check your Docker setup.${NC}"
        exit 1
    fi
    echo -e "${GREEN}Successfully created Docker network: blinko-network${NC}"
else
    echo -e "${YELLOW}Network 'blinko-network' already exists. Skipping network creation.${NC}"
fi

# Step 3: Check if the PostgreSQL container 'blinko-postgres' already exists
if [ "$(docker ps -aq -f name=blinko-postgres)" ]; then
    echo -e "${YELLOW}Container 'blinko-postgres' already exists. Skipping container creation.${NC}"
else
    echo -e "${YELLOW}2. 🐳 Starting PostgreSQL container...${NC}"
    docker run -d \
      --name blinko-postgres \
      --network blinko-network \
      -p 5432:5432 \
      -e POSTGRES_DB=postgres \
      -e POSTGRES_USER=postgres \
      -e POSTGRES_PASSWORD=mysecretpassword \
      -e TZ=Asia/Shanghai \
      --restart always \
      postgres:14

    if [ $? -ne 0 ]; then
      echo -e "${RED}Failed to start PostgreSQL container.${NC}"
      exit 1
    fi
    echo -e "${GREEN}✅ PostgreSQL container is running.${NC}"
fi

# Step 4: Build and run Blinko from local source
echo -e "${YELLOW}3. 🔨 Building Blinko from local source code...${NC}"
docker build -t blinko-local .

if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to build Blinko image.${NC}"
    exit 1
fi

echo -e "${YELLOW}4. 🖥️ Starting Blinko container...${NC}"
docker run -d \
  --name blinko-website \
  --network blinko-network \
  -p 1111:1111 \
  -e NODE_ENV=production \
  -e NEXTAUTH_SECRET=my_ultra_secure_nextauth_secret \
  -e DATABASE_URL=postgresql://postgres:mysecretpassword@blinko-postgres:5432/postgres \
  --env-file .env \
  --restart always \
  blinko-local

if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to start Blinko container.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ All containers are up and running.${NC}"
echo -e "${GREEN}🌐 Blinko is now running on http://localhost:1111${NC}"
echo -e "${GREEN}📊 Database is running on port 5432${NC}"
echo -e "${YELLOW}🤖 AI Features: Pre-configured (replace demo API keys in .env for production)${NC}"
