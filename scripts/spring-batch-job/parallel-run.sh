#!/bin/bash
# parallel-run.sh - Executa múltiplos disparos do job em paralelo

API_URL="http://localhost:8080/job"

echo "⚡ Disparando jobs em paralelo..."
for i in {1..5}; do
  curl -X POST $API_URL -H "Content-Type: application/json" &
done

wait
echo "✅ Execuções concluídas!"
