#!/bin/bash
# run-tests.sh - Executa testes unitários e de integração

echo "🔍 Limpando build antigo..."
mvn clean

echo "🧪 Rodando testes automatizados..."
mvn test

echo "✅ Testes concluídos!"
