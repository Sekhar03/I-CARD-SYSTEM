#!/bin/bash

# East Coast Railway I-Card System Deployment Script
# This script helps deploy the application to various platforms

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if required tools are installed
check_requirements() {
    print_status "Checking requirements..."
    
    if ! command -v node &> /dev/null; then
        print_error "Node.js is not installed. Please install Node.js 14 or higher."
        exit 1
    fi
    
    if ! command -v npm &> /dev/null; then
        print_error "npm is not installed. Please install npm."
        exit 1
    fi
    
    if ! command -v git &> /dev/null; then
        print_error "Git is not installed. Please install Git."
        exit 1
    fi
    
    print_success "All requirements are met!"
}

# Install dependencies
install_dependencies() {
    print_status "Installing dependencies..."
    npm install
    print_success "Dependencies installed successfully!"
}

# Setup environment
setup_environment() {
    print_status "Setting up environment..."
    
    if [ ! -f .env ]; then
        if [ -f env.example ]; then
            cp env.example .env
            print_warning "Created .env file from template. Please update with your configuration."
        else
            print_error "No .env.example file found. Please create a .env file manually."
            exit 1
        fi
    else
        print_status ".env file already exists."
    fi
}

# Build the application
build_app() {
    print_status "Building application..."
    npm run build 2>/dev/null || print_warning "No build script found, skipping build step."
    print_success "Application built successfully!"
}

# Start the application
start_app() {
    print_status "Starting application..."
    
    if [ "$1" = "dev" ]; then
        npm run dev &
    else
        npm start &
    fi
    
    APP_PID=$!
    print_success "Application started with PID: $APP_PID"
    print_status "Application is running on http://localhost:3000"
}

# Docker deployment
deploy_docker() {
    print_status "Deploying with Docker..."
    
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker."
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose is not installed. Please install Docker Compose."
        exit 1
    fi
    
    docker-compose up -d
    print_success "Application deployed with Docker!"
    print_status "Application is running on http://localhost:3000"
}

# PM2 deployment
deploy_pm2() {
    print_status "Deploying with PM2..."
    
    if ! command -v pm2 &> /dev/null; then
        print_status "Installing PM2..."
        npm install -g pm2
    fi
    
    pm2 start server.js --name "icard-system"
    pm2 save
    pm2 startup
    print_success "Application deployed with PM2!"
}

# Create uploads directory
create_uploads_dir() {
    print_status "Creating uploads directory..."
    mkdir -p public/uploads
    touch public/uploads/.gitkeep
    print_success "Uploads directory created!"
}

# Main deployment function
deploy() {
    local deployment_type=$1
    
    print_status "Starting deployment process..."
    
    check_requirements
    install_dependencies
    setup_environment
    create_uploads_dir
    
    case $deployment_type in
        "local")
            start_app
            ;;
        "dev")
            start_app "dev"
            ;;
        "docker")
            deploy_docker
            ;;
        "pm2")
            deploy_pm2
            ;;
        *)
            print_error "Invalid deployment type. Use: local, dev, docker, or pm2"
            exit 1
            ;;
    esac
    
    print_success "Deployment completed successfully!"
}

# Show help
show_help() {
    echo "East Coast Railway I-Card System Deployment Script"
    echo ""
    echo "Usage: $0 [OPTION]"
    echo ""
    echo "Options:"
    echo "  local    Deploy locally with npm start"
    echo "  dev      Deploy in development mode with npm run dev"
    echo "  docker   Deploy using Docker Compose"
    echo "  pm2      Deploy using PM2 process manager"
    echo "  help     Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 local    # Deploy locally"
    echo "  $0 docker   # Deploy with Docker"
    echo "  $0 pm2      # Deploy with PM2"
}

# Main script logic
case "${1:-help}" in
    "local"|"dev"|"docker"|"pm2")
        deploy "$1"
        ;;
    "help"|"--help"|"-h")
        show_help
        ;;
    *)
        print_error "Invalid option. Use 'help' to see available options."
        exit 1
        ;;
esac 