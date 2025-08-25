#!/bin/bash
echo "BIODIVERSITY DASHBOARD CLEANUP"
echo ""

# Check if docker is available
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed or not available in PATH."
    exit 1
fi

# Check if docker-compose is available (fallback to docker compose)
if command -v docker-compose &> /dev/null; then
    COMPOSE="docker-compose"
else
    COMPOSE="docker compose"
fi

echo "Stopping and removing containers..."
$COMPOSE down --volumes --remove-orphans

echo ""
echo "Removing images built by this project (if any)..."
docker image prune -a -f

echo ""
echo "Removing dangling volumes..."
docker volume prune -f

echo ""
echo "Removing unused Docker networks..."
docker network prune -f

echo ""
echo "Docker cleanup complete."

# Ask to delete current folder
read -p "Do you also want to delete this project folder? (y/N): " confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
    echo "Deleting project directory: $(pwd)"
    cd .. && sudo rm -rf "$(basename "$OLDPWD")"
    echo "Project folder deleted."
else
    echo "Project folder was not deleted."
fi

echo ""
echo "Uninstallation complete."
