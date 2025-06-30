k#!/bin/bash
echo "==============================="
echo "  BIODIVERSITY DASHBOARD SETUP"
echo "==============================="
echo ""

if ! command -v docker &> /dev/null
then
    echo "Docker Desktop is not installed or not in PATH!"
    echo "Please install and start Docker Desktop before continuing."
    echo "Download here: https://www.docker.com/products/docker-desktop/"
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
echo "If the dashboard doesn't open automatically:"
echo "- Open 'index.html' in this folder"
echo "- Or open http://localhost:1880/ui/  (CSV upload)"
echo "- Or open http://localhost:3000/     (Grafana dashboard)"
echo ""

read -p "Press enter to exit."

