@echo off
setlocal enabledelayedexpansion

echo ========================================
echo    Blinko - One Click Setup
echo ========================================
echo.

REM Check if Docker is running
docker --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Docker is not installed or not running!
    echo Please install Docker Desktop from https://docker.com
    echo Then run this script again.
    pause
    exit /b 1
)

echo Docker found: Starting setup...
echo.

REM Step 1: Create environment file
if not exist ".env" (
    echo [1/4] Creating environment configuration...
    copy ".env.example" ".env" >nul
    echo    Environment file created successfully
) else (
    echo [1/4] Environment file already exists, skipping...
)

REM Step 2: Setup Docker network
echo [2/4] Setting up Docker network...
docker network inspect blinko-network >nul 2>&1
if errorlevel 1 (
    docker network create blinko-network
    echo    Network created successfully
) else (
    echo    Network already exists
)

REM Step 3: Start PostgreSQL
echo [3/4] Starting PostgreSQL database...
docker inspect blinko-postgres >nul 2>&1
if errorlevel 1 (
    docker run -d ^
      --name blinko-postgres ^
      --network blinko-network ^
      -p 5432:5432 ^
      -e POSTGRES_DB=postgres ^
      -e POSTGRES_USER=postgres ^
      -e POSTGRES_PASSWORD=mysecretpassword ^
      --restart always ^
      postgres:14
    echo    PostgreSQL started successfully
) else (
    echo    PostgreSQL already running
)

REM Step 4: Build and run Blinko
echo [4/4] Building and starting Blinko...
docker build -t blinko-local .
if errorlevel 1 (
    echo ERROR: Failed to build Blinko image
    pause
    exit /b 1
)

REM Stop existing container if running
docker stop blinko-website >nul 2>&1
docker rm blinko-website >nul 2>&1

docker run -d ^
  --name blinko-website ^
  --network blinko-network ^
  -p 1111:1111 ^
  -e NODE_ENV=production ^
  -e NEXTAUTH_SECRET=my_ultra_secure_nextauth_secret ^
  -e DATABASE_URL=postgresql://postgres:mysecretpassword@blinko-postgres:5432/postgres ^
  --env-file .env ^
  --restart always ^
  blinko-local

if errorlevel 1 (
    echo ERROR: Failed to start Blinko container
    pause
    exit /b 1
)

echo.
echo ========================================
echo    SETUP COMPLETE!
echo ========================================
echo.
echo Application is now running at:
echo http://localhost:1111
echo.
echo AI Features: Pre-configured
echo Database: Running on port 5432
echo.
echo Press any key to open Blinko in your browser...
pause >nul

REM Open browser
start http://localhost:1111

echo.
echo Enjoy using Blinko! 🎉
echo.
echo Note: Replace demo API keys in .env file for production use
pause
