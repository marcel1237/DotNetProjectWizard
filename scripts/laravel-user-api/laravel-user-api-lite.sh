#!/usr/bin/env bash

set -e

PROJECT_NAME="laravel-user-api"
PROJECT_DIR="$HOME/$PROJECT_NAME"

echo "=============================================="
echo " DotNetProjectWizard - Laravel User API"
echo "=============================================="

install_if_missing() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "📦 Instalando $1..."
        sudo apt update
        shift
        sudo apt install -y "$@"
    fi
}

install_if_missing git git
install_if_missing curl curl
install_if_missing unzip unzip

if ! command -v php >/dev/null 2>&1; then
    echo "📦 Instalando PHP..."
    sudo apt update
    sudo apt install -y \
        php-cli \
        php-mysql \
        php-xml \
        php-curl \
        php-mbstring \
        php-zip \
        php-bcmath \
        php-intl
fi

if ! command -v composer >/dev/null 2>&1; then
    echo "📦 Instalando Composer..."
    sudo apt install -y composer
fi

if [ -d "$PROJECT_DIR" ]; then
    echo "🗑️ Removendo projeto anterior..."
    rm -rf "$PROJECT_DIR"
fi

echo "🚀 Criando Laravel..."

composer create-project laravel/laravel "$PROJECT_DIR"

cd "$PROJECT_DIR"

echo "📦 Instalando dependências..."

composer require \
tymon/jwt-auth \
darkaonline/l5-swagger \
predis/predis

composer require --dev \
pestphp/pest \
pestphp/pest-plugin-laravel \
larastan/larastan \
laravel/pint

php artisan pest:install

cp .env.example .env

php artisan key:generate

php artisan jwt:secret

echo "📁 Criando estrutura..."

mkdir -p app/{DTO,Services,Repositories,Interfaces}
mkdir -p app/{Enums,Traits,Exceptions}
mkdir -p app/{Events,Listeners,Policies,Notifications}
mkdir -p app/Rules
mkdir -p docs docker tests/Integration

echo "⚙️ Gerando código..."

php artisan make:controller Api/AuthController --api
php artisan make:controller Api/UserController --api

php artisan make:request LoginRequest
php artisan make:request RegisterRequest
php artisan make:request StoreUserRequest
php artisan make:request UpdateUserRequest

php artisan make:resource UserResource

php artisan make:event UserCreated
php artisan make:listener SendWelcomeEmail
php artisan make:notification WelcomeNotification
php artisan make:policy UserPolicy

cat > Dockerfile <<EOF
FROM php:8.3-fpm

RUN docker-php-ext-install pdo pdo_mysql

WORKDIR /var/www/html

COPY . .

CMD ["php-fpm"]
EOF

cat > docker-compose.yml <<EOF
version: "3.9"

services:

  app:
    build: .
    working_dir: /var/www/html
    command: php artisan serve --host=0.0.0.0
    volumes:
      - .:/var/www/html
    ports:
      - "8000:8000"

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

cat > README.md <<EOF
# Laravel User API

Projeto gerado automaticamente pelo DotNetProjectWizard.

## Stack

- PHP 8
- Laravel
- JWT
- Swagger
- MySQL
- Redis
- Docker
- Pest
- PHPUnit

## Executar

docker compose up -d

php artisan migrate

php artisan serve
EOF

echo
echo "=============================================="
echo "✅ Projeto criado com sucesso!"
echo "=============================================="
echo
echo "Local:"
echo "  $PROJECT_DIR"
echo
echo "Para iniciar:"
echo
echo "cd $PROJECT_DIR"
echo "docker compose up -d"
echo "php artisan migrate"
echo "php artisan serve"
echo