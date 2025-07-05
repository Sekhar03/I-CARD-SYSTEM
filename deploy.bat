@echo off
REM East Coast Railway I-Card System Deployment Script for Windows
REM This script helps deploy the application to various platforms

setlocal enabledelayedexpansion

REM Colors for output (Windows compatible)
set "RED=[91m"
set "GREEN=[92m"
set "YELLOW=[93m"
set "BLUE=[94m"
set "NC=[0m"

REM Function to print colored output
:print_status
echo %BLUE%[INFO]%NC% %~1
goto :eof

:print_success
echo %GREEN%[SUCCESS]%NC% %~1
goto :eof

:print_warning
echo %YELLOW%[WARNING]%NC% %~1
goto :eof

:print_error
echo %RED%[ERROR]%NC% %~1
goto :eof

REM Check if required tools are installed
:check_requirements
call :print_status "Checking requirements..."

where node >nul 2>&1
if %errorlevel% neq 0 (
    call :print_error "Node.js is not installed. Please install Node.js 14 or higher."
    exit /b 1
)

where npm >nul 2>&1
if %errorlevel% neq 0 (
    call :print_error "npm is not installed. Please install npm."
    exit /b 1
)

where git >nul 2>&1
if %errorlevel% neq 0 (
    call :print_error "Git is not installed. Please install Git."
    exit /b 1
)

call :print_success "All requirements are met!"
goto :eof

REM Install dependencies
:install_dependencies
call :print_status "Installing dependencies..."
npm install
if %errorlevel% neq 0 (
    call :print_error "Failed to install dependencies"
    exit /b 1
)
call :print_success "Dependencies installed successfully!"
goto :eof

REM Setup environment
:setup_environment
call :print_status "Setting up environment..."

if not exist ".env" (
    if exist "env.example" (
        copy env.example .env >nul
        call :print_warning "Created .env file from template. Please update with your configuration."
    ) else (
        call :print_error "No .env.example file found. Please create a .env file manually."
        exit /b 1
    )
) else (
    call :print_status ".env file already exists."
)
goto :eof

REM Create uploads directory
:create_uploads_dir
call :print_status "Creating uploads directory..."
if not exist "public\uploads" mkdir "public\uploads"
echo. > "public\uploads\.gitkeep"
call :print_success "Uploads directory created!"
goto :eof

REM Start the application
:start_app
call :print_status "Starting application..."

if "%1"=="dev" (
    start "I-Card System Dev" cmd /c "npm run dev"
) else (
    start "I-Card System" cmd /c "npm start"
)

call :print_success "Application started!"
call :print_status "Application is running on http://localhost:3000"
goto :eof

REM Docker deployment
:deploy_docker
call :print_status "Deploying with Docker..."

where docker >nul 2>&1
if %errorlevel% neq 0 (
    call :print_error "Docker is not installed. Please install Docker Desktop."
    exit /b 1
)

where docker-compose >nul 2>&1
if %errorlevel% neq 0 (
    call :print_error "Docker Compose is not installed. Please install Docker Compose."
    exit /b 1
)

docker-compose up -d
if %errorlevel% neq 0 (
    call :print_error "Failed to start Docker containers"
    exit /b 1
)

call :print_success "Application deployed with Docker!"
call :print_status "Application is running on http://localhost:3000"
goto :eof

REM PM2 deployment
:deploy_pm2
call :print_status "Deploying with PM2..."

where pm2 >nul 2>&1
if %errorlevel% neq 0 (
    call :print_status "Installing PM2..."
    npm install -g pm2
)

pm2 start server.js --name "icard-system"
if %errorlevel% neq 0 (
    call :print_error "Failed to start PM2 process"
    exit /b 1
)

pm2 save
pm2 startup
call :print_success "Application deployed with PM2!"
goto :eof

REM Main deployment function
:deploy
set "deployment_type=%~1"

call :print_status "Starting deployment process..."

call :check_requirements
if %errorlevel% neq 0 exit /b 1

call :install_dependencies
if %errorlevel% neq 0 exit /b 1

call :setup_environment
if %errorlevel% neq 0 exit /b 1

call :create_uploads_dir
if %errorlevel% neq 0 exit /b 1

if "%deployment_type%"=="local" (
    call :start_app
) else if "%deployment_type%"=="dev" (
    call :start_app dev
) else if "%deployment_type%"=="docker" (
    call :deploy_docker
) else if "%deployment_type%"=="pm2" (
    call :deploy_pm2
) else (
    call :print_error "Invalid deployment type. Use: local, dev, docker, or pm2"
    exit /b 1
)

call :print_success "Deployment completed successfully!"
goto :eof

REM Show help
:show_help
echo East Coast Railway I-Card System Deployment Script
echo.
echo Usage: %0 [OPTION]
echo.
echo Options:
echo   local    Deploy locally with npm start
echo   dev      Deploy in development mode with npm run dev
echo   docker   Deploy using Docker Compose
echo   pm2      Deploy using PM2 process manager
echo   help     Show this help message
echo.
echo Examples:
echo   %0 local    # Deploy locally
echo   %0 docker   # Deploy with Docker
echo   %0 pm2      # Deploy with PM2
goto :eof

REM Main script logic
if "%1"=="" goto show_help
if "%1"=="help" goto show_help
if "%1"=="--help" goto show_help
if "%1"=="-h" goto show_help

if "%1"=="local" goto deploy_local
if "%1"=="dev" goto deploy_dev
if "%1"=="docker" goto deploy_docker
if "%1"=="pm2" goto deploy_pm2

call :print_error "Invalid option. Use 'help' to see available options."
exit /b 1

:deploy_local
call :deploy local
goto :eof

:deploy_dev
call :deploy dev
goto :eof

:deploy_docker
call :deploy docker
goto :eof

:deploy_pm2
call :deploy pm2
goto :eof 