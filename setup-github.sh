#!/bin/bash

# GitHub Repository Setup Script for I-Card System
# This script initializes a GitHub repository and pushes the code

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

# Check if Git is installed
check_git() {
    if ! command -v git &> /dev/null; then
        print_error "Git is not installed. Please install Git first."
        exit 1
    fi
    print_success "Git is installed"
}

# Initialize Git repository
init_git() {
    print_status "Initializing Git repository..."
    
    if [ -d ".git" ]; then
        print_warning "Git repository already exists"
        return
    fi
    
    git init
    print_success "Git repository initialized"
}

# Create initial commit
create_initial_commit() {
    print_status "Creating initial commit..."
    
    # Add all files
    git add .
    
    # Create commit
    git commit -m "Initial commit: East Coast Railway I-Card System

- Complete I-Card management system
- Support for Gazetted and Non-Gazetted applications
- Admin panel with comprehensive features
- PDF generation with QR codes
- Docker and Kubernetes deployment support
- CI/CD pipeline with GitHub Actions
- Comprehensive documentation and deployment scripts"
    
    print_success "Initial commit created"
}

# Create GitHub repository
create_github_repo() {
    local repo_name=$1
    local description="East Coast Railway I-Card Management System - A comprehensive web-based identity card management system for railway employees"
    
    print_status "Creating GitHub repository: $repo_name"
    
    # Check if GitHub CLI is installed
    if command -v gh &> /dev/null; then
        print_status "Using GitHub CLI to create repository..."
        
        # Create repository using GitHub CLI
        gh repo create "$repo_name" \
            --description "$description" \
            --public \
            --source=. \
            --remote=origin \
            --push
        
        print_success "GitHub repository created and code pushed!"
    else
        print_warning "GitHub CLI not found. Please create the repository manually:"
        echo "1. Go to https://github.com/new"
        echo "2. Repository name: $repo_name"
        echo "3. Description: $description"
        echo "4. Make it public"
        echo "5. Don't initialize with README (we already have one)"
        echo ""
        echo "Then run:"
        echo "git remote add origin https://github.com/YOUR_USERNAME/$repo_name.git"
        echo "git branch -M main"
        echo "git push -u origin main"
    fi
}

# Setup branch protection
setup_branch_protection() {
    print_status "Setting up branch protection rules..."
    
    if command -v gh &> /dev/null; then
        # Enable branch protection for main branch
        gh api repos/:owner/:repo/branches/main/protection \
            --method PUT \
            --field required_status_checks='{"strict":true,"contexts":["test","build"]}' \
            --field enforce_admins=true \
            --field required_pull_request_reviews='{"required_approving_review_count":1}' \
            --field restrictions=null
        
        print_success "Branch protection rules configured"
    else
        print_warning "GitHub CLI not found. Please set up branch protection manually:"
        echo "1. Go to repository Settings > Branches"
        echo "2. Add rule for 'main' branch"
        echo "3. Enable: Require pull request reviews before merging"
        echo "4. Enable: Require status checks to pass before merging"
        echo "5. Enable: Require branches to be up to date before merging"
    fi
}

# Setup GitHub Actions secrets
setup_secrets() {
    print_status "Setting up GitHub Actions secrets..."
    
    if command -v gh &> /dev/null; then
        print_warning "Please add the following secrets to your repository:"
        echo "DOCKER_USERNAME - Your Docker Hub username"
        echo "DOCKER_PASSWORD - Your Docker Hub password/token"
        echo "SNYK_TOKEN - Your Snyk security token (optional)"
        
        # You can add secrets programmatically if needed
        # gh secret set DOCKER_USERNAME --body "your-username"
        # gh secret set DOCKER_PASSWORD --body "your-password"
    else
        print_warning "Please add the following secrets manually:"
        echo "1. Go to repository Settings > Secrets and variables > Actions"
        echo "2. Add the following secrets:"
        echo "   - DOCKER_USERNAME"
        echo "   - DOCKER_PASSWORD"
        echo "   - SNYK_TOKEN (optional)"
    fi
}

# Create releases
create_release() {
    local version=$1
    
    print_status "Creating release v$version..."
    
    if command -v gh &> /dev/null; then
        gh release create "v$version" \
            --title "Release v$version" \
            --notes "## What's New in v$version

### Features
- Complete I-Card management system
- Support for Gazetted and Non-Gazetted applications
- Admin panel with comprehensive features
- PDF generation with QR codes
- Docker and Kubernetes deployment support
- CI/CD pipeline with GitHub Actions

### Technical Details
- Node.js backend with Express.js
- MongoDB database with Mongoose ODM
- Bootstrap 5 frontend
- PDF generation with PDFKit
- QR code generation
- File upload handling
- Security features (Helmet, CORS, Rate limiting)

### Deployment
- Docker containerization
- Kubernetes deployment manifests
- GitHub Actions CI/CD pipeline
- Comprehensive documentation

### Installation
\`\`\`bash
git clone https://github.com/YOUR_USERNAME/icard-system.git
cd icard-system
npm install
cp env.example .env
# Update .env with your configuration
npm start
\`\`\`"
        
        print_success "Release v$version created!"
    else
        print_warning "GitHub CLI not found. Please create release manually:"
        echo "1. Go to repository Releases"
        echo "2. Create new release with tag v$version"
        echo "3. Add release notes"
    fi
}

# Main function
main() {
    local repo_name=${1:-"icard-system"}
    local version=${2:-"1.0.0"}
    
    print_status "Setting up GitHub repository for I-Card System..."
    
    check_git
    init_git
    create_initial_commit
    create_github_repo "$repo_name"
    setup_branch_protection
    setup_secrets
    create_release "$version"
    
    print_success "GitHub repository setup completed!"
    print_status "Your repository is now available at: https://github.com/YOUR_USERNAME/$repo_name"
    print_status "Next steps:"
    echo "1. Update the repository URL in README.md"
    echo "2. Configure GitHub Actions secrets"
    echo "3. Set up deployment environments"
    echo "4. Test the CI/CD pipeline"
}

# Show help
show_help() {
    echo "GitHub Repository Setup Script for I-Card System"
    echo ""
    echo "Usage: $0 [REPO_NAME] [VERSION]"
    echo ""
    echo "Arguments:"
    echo "  REPO_NAME    GitHub repository name (default: icard-system)"
    echo "  VERSION      Initial version tag (default: 1.0.0)"
    echo ""
    echo "Examples:"
    echo "  $0                    # Use defaults"
    echo "  $0 my-icard-system   # Custom repository name"
    echo "  $0 icard-system 2.0.0 # Custom name and version"
}

# Script logic
case "${1:-help}" in
    "help"|"--help"|"-h")
        show_help
        ;;
    *)
        main "$@"
        ;;
esac 