#!/bin/bash
# monitor-job.sh - Monitora execução do job via API REST

API_URL="http://localhost:8080/job"

echo "🚀 Disparando execução do job..."
curl -X POST $API_URL -H "Content-Type: application/json"

echo "📊 Consultando métricas..."
curl -s $API_URL/status | jq .
