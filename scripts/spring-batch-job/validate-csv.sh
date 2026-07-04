#!/bin/bash
# validate-csv.sh - Valida formato do CSV antes de rodar o job

CSV_FILE="src/main/resources/usuarios.csv"

echo "📂 Validando arquivo: $CSV_FILE"

if [ ! -f "$CSV_FILE" ]; then
  echo "❌ Arquivo não encontrado!"
  exit 1
fi

# Verifica se cada linha tem exatamente 3 colunas (id,nome,email)
awk -F',' 'NF!=3 {print "Linha inválida:", $0}' "$CSV_FILE"

echo "✅ Validação concluída!"
