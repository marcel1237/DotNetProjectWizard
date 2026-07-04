#!/usr/bin/env bash

###############################################################################
# DotNetProjectWizard
# Laravel User API Template
###############################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/lib/common.sh"

PROJECT_NAME="laravel-user-api"
PROJECT_DIR="$HOME/$PROJECT_NAME"

###############################################################################
# Init
###############################################################################

init_script "Laravel User API Enterprise"

###############################################################################
# Remove projeto anterior
###############################################################################

if [ -d "$PROJECT_DIR" ]; then
    warn "Project already exists."

    rm -rf "$PROJECT_DIR"

    success "Old project removed."
fi

###############################################################################
# Laravel
###############################################################################

info "Creating Laravel project..."

composer create-project laravel/laravel "$PROJECT_DIR"

cd "$PROJECT_DIR"

###############################################################################
# Packages
###############################################################################

info "Installing enterprise packages..."

composer require \
    tymon/jwt-auth \
    darkaonline/l5-swagger \
    predis/predis

composer require --dev \
    pestphp/pest \
    pestphp/pest-plugin-laravel \
    larastan/larastan \
    laravel/pint

###############################################################################
# Pest
###############################################################################

info "Installing Pest..."

php artisan pest:install

###############################################################################
# Environment
###############################################################################

info "Configuring application..."

cp .env.example .env

php artisan key:generate

php artisan jwt:secret

###############################################################################
# Enterprise folders
###############################################################################

info "Creating enterprise folders..."

mkdir -p app/DTO
mkdir -p app/Enums
mkdir -p app/Events
mkdir -p app/Exceptions
mkdir -p app/Interfaces
mkdir -p app/Listeners
mkdir -p app/Notifications
mkdir -p app/Policies
mkdir -p app/Repositories
mkdir -p app/Rules
mkdir -p app/Services
mkdir -p app/Traits

mkdir -p docs
mkdir -p docker
mkdir -p tests/Integration

###############################################################################
# Controllers
###############################################################################

info "Generating controllers..."

php artisan make:controller Api/AuthController --api

php artisan make:controller Api/UserController --api

###############################################################################
# Requests
###############################################################################

info "Generating requests..."

php artisan make:request LoginRequest

php artisan make:request RegisterRequest

php artisan make:request StoreUserRequest

php artisan make:request UpdateUserRequest

###############################################################################
# Resource
###############################################################################

php artisan make:resource UserResource

###############################################################################
# Events
###############################################################################

php artisan make:event UserCreated

###############################################################################
# Listener
###############################################################################

php artisan make:listener SendWelcomeEmail

###############################################################################
# Notification
###############################################################################

php artisan make:notification WelcomeNotification

###############################################################################
# Policy
###############################################################################

php artisan make:policy UserPolicy

###############################################################################
# Dockerfile
###############################################################################

info "Creating Dockerfile..."

cat > Dockerfile <<EOF
FROM php:8.3-fpm

RUN docker-php-ext-install pdo pdo_mysql

WORKDIR /var/www/html

COPY . .

EXPOSE 8000

CMD ["php","artisan","serve","--host=0.0.0.0","--port=8000"]
EOF

###############################################################################
# Docker Compose
###############################################################################

info "Creating docker-compose..."

cat > docker-compose.yml <<EOF
version: "3.9"

services:

  app:

    build: .

    container_name: laravel-user-api

    working_dir: /var/www/html

    volumes:
      - .:/var/www/html

    ports:
      - "8000:8000"

    depends_on:
      - mysql
      - redis

  mysql:

    image: mysql:8

    restart: always

    environment:

      MYSQL_ROOT_PASSWORD: root

      MYSQL_DATABASE: laravel

    ports:

      - "3306:3306"

  redis:

    image: redis:7

    ports:

      - "6379:6379"
EOF

###############################################################################
# Git Ignore
###############################################################################

info "Updating .gitignore..."

cat >> .gitignore <<EOF

docker-data/
vendor/
EOF

###############################################################################
# README
###############################################################################

info "Creating README..."

cat > README.md <<EOF
# Laravel User API

Generated by DotNetProjectWizard

## Stack

- PHP 8
- Laravel
- JWT
- Swagger
- Redis
- Docker
- Pest
- PHPUnit

## Start

docker compose up -d

php artisan migrate

php artisan serve
EOF

###############################################################################
# Git
###############################################################################

info "Initializing Git..."

git init

git add .

git commit -m "Initial Laravel User API generated by DotNetProjectWizard"

###############################################################################
# Finish
###############################################################################

success "Laravel User API successfully generated."

echo
echo "Project:"
echo "$PROJECT_DIR"
echo
echo "Next steps:"
echo
echo "cd $PROJECT_DIR"
echo "docker compose up -d"
echo "php artisan migrate"
echo "php artisan serve"
echo