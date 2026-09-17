#!/bin/bash

set -e

echo "========================================="
echo "NLUX Project Local Installation"
echo "========================================="

# Find the NLUX directory
NLUX_DIR="$(dirname "$(pwd)")"

# Check prerequisites
echo ""
echo "Checking prerequisites..."
if ! command -v docker &> /dev/null; then
    echo "❌ ERROR: Docker is not installed"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ ERROR: Docker Compose is not installed"
    exit 1
fi

echo "✅ Docker and Docker Compose are available"

# Check if uv is available
if ! command -v uv &> /dev/null; then
    echo "ℹ️  Installing uv (Python package manager)..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    source $HOME/.local/bin/env
    export PATH="$HOME/.local/bin:$PATH"
    pip install hatch
fi

# Find the docker-compose.yml file
DOCKER_COMPOSE_FILE=$(find "$NLUX_DIR" -name "docker-compose.yml" | head -1)

if [ -z "$DOCKER_COMPOSE_FILE" ]; then
    echo "❌ ERROR: docker-compose.yml not found in $NLUX_DIR"
    exit 1
fi

echo "Found docker-compose.yml: $DOCKER_COMPOSE_FILE"

# Start Docker services
echo ""
echo "Starting Docker services..."
docker compose --file "$DOCKER_COMPOSE_FILE" --profile pipeline up -d

echo ""
echo "Waiting for services to be ready..."
sleep 15

# Check service status
echo ""
echo "Checking service status..."
docker compose --file "$DOCKER_COMPOSE_FILE" ps

echo ""
echo "✅ Data Pipeline services are running!"
echo ""
echo "========================================="
echo "Next Steps:"
echo "========================================="
echo ""
echo "1. Access the NLUX UI:"
echo "   http://localhost:8088"
echo ""
echo "2. Access the API docs:"
echo "   http://localhost:8000/docs"
echo ""
echo "3. Install backend dependencies (in the backend folder):"
echo "   cd backend"
echo "   uv sync"
echo ""
echo "4. Start backend API:"
echo "   uv run python app/main.py"
echo ""
echo "5. Load data into the backend:"
echo "   python scripts/load_data.py /path/to/lux_metadata/"
echo ""
echo "========================================="
