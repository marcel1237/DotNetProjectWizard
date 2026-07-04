#!/bin/bash
# build-docker.sh - Empacota aplicação em container Docker

APP_NAME="spring-batch-job"
VERSION="1.0.0"

echo "📦 Gerando JAR..."
mvn clean package -DskipTests

echo "🐳 Construindo imagem Docker..."
docker build -t $APP_NAME:$VERSION .

echo "🚀 Rodando container..."
docker run -d -p 8080:8080 $APP_NAME:$VERSION
