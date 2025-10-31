#!/bin/bash
echo "BIODIVERSITY DASHBOARD SETUP"
echo ""

# Function to check if Docker is ready
is_docker_ready() {
    docker info > /dev/null 2>&1
    return $?
}

# Check for Docker command
if ! command -v docker &> /dev/null
then
    echo "Docker Desktop is not installed."

    # Detect Mac architecture: arm64 = Apple Silicon (M1/M2/M3), x86_64 = Intel
    ARCH=$(uname -m)
    if [[ "$ARCH" == "arm64" ]]; then
        DOCKER_URL="https://desktop.docker.com/mac/main/arm64/Docker.dmg"
        echo "Detected Apple Silicon (M1/M2/M3)."
    elif [[ "$ARCH" == "x86_64" ]]; then
        DOCKER_URL="https://desktop.docker.com/mac/main/amd64/Docker.dmg"
        echo "Detected Intel Mac."
    else
        echo "Unknown architecture: $ARCH"
        echo "Please manually download Docker Desktop: https://www.docker.com/products/docker-desktop/"
        exit
    fi

    echo "Downloading Docker Desktop installer to your Downloads folder..."
    curl -L -o "$HOME/Downloads/Docker.dmg" "$DOCKER_URL"
    echo "Docker Desktop installer has been downloaded to your Downloads folder."
    echo "Please open 'Docker.dmg', install Docker Desktop, then re-run this script."
    read -p "Press enter to exit."
    exit
fi

# Start Docker if it's not running
if ! is_docker_ready; then
    echo "Docker is installed but not running."
    echo "Starting Docker Desktop..."
    open -a Docker
    echo "Waiting 10 seconds for Docker to start..."
    sleep 10
    until is_docker_ready; do
        echo "Still waiting for Docker to initialize..."
        sleep 5
    done
fi

# Final check
if ! is_docker_ready; then
    echo "Docker did not start successfully. Please start it manually and rerun this script."
    read -p "Press enter to exit."
    exit
fi

echo "Starting dashboard services..."
docker compose up -d

echo ""
echo "Dashboard services are starting!"
echo "Opening dashboard homepage..."
open "index.html"
echo ""
echo "If it doesn't open automatically, manually open 'index.html' in this folder."
echo ""

read -p "Press enter to exit."
