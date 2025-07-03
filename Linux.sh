#!/bin/bash
echo "==============================="
echo "  BIODIVERSITY DASHBOARD SETUP"
echo "==============================="
echo ""

# Check for Docker
if ! command -v docker &> /dev/null
then
    echo "Docker Desktop is not installed or not in PATH!"
    echo "Please install and start Docker Desktop before continuing."
    echo "Download here: https://www.docker.com/products/docker-desktop/"
    read -p "Press enter to exit."
    exit 1
fi

# Check if Docker daemon is running (docker ps should succeed)
docker info > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Docker does not seem to be running."
    echo "Attempting to start Docker Desktop..."
    # Try to start Docker Desktop (Mac only; Linux might need 'sudo systemctl start docker')
    if [[ "$OSTYPE" == "darwin"* ]]; then
        open -a "Docker"
        echo "Waiting 10 seconds for Docker Desktop to start..."
        sleep 10
    fi
    # Wait for Docker to be ready
    until docker info > /dev/null 2>&1; do
        echo "Waiting for Docker to be ready..."
        sleep 5
    done
fi

echo "Starting dashboard services..."
docker compose up -d

echo ""
echo "Dashboard services are starting!"
echo "Opening dashboard homepage..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    open "index.html"
else
    xdg-open "index.html"
fi
echo ""
echo "If the dashboard doesn't open automatically:"
echo "- Open 'index.html' in this folder"
echo "- Or open http://localhost:1880/ui/  (CSV upload)"
echo "- Or open http://localhost:3000/     (Grafana dashboard)"
echo ""

read -p "Press enter to exit."
