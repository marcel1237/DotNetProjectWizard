#!/bin/bash
# help.sh - Lista e explica os comandos disponíveis no projeto Spring Batch Job

echo "📖 Comandos disponíveis no Makefile e scripts:"
echo
echo "make create-project   → Cria a estrutura inicial do projeto Java usando 01-create-project.sh"
echo "make validate         → Valida o CSV (usuarios.csv) garantindo formato correto (id,nome,email)"
echo "make test             → Executa testes unitários e de integração com Maven"
echo "make monitor          → Dispara o job via API REST e consulta métricas de execução"
echo "make deploy           → Gera JAR, constrói imagem Docker e sobe container na porta 8080"
echo "make parallel         → Dispara múltiplos jobs em paralelo para testar escalabilidade"
echo "make clean            → Limpa compilações antigas com Maven"
echo "make dashboard        → Abre o dashboard web em http://localhost:8080/"
echo "make h2console        → Abre o console gráfico do H2 em http://localhost:8080/h2-console"
echo
echo "📂 Scripts auxiliares diretos:"
echo "./run-tests.sh        → Executa testes Maven"
echo "./validate-csv.sh     → Valida o arquivo CSV antes do job"
echo "./monitor-job.sh      → Dispara job e mostra métricas JSON"
echo "./build-docker.sh     → Empacota e roda aplicação em Docker"
echo "./parallel-run.sh     → Executa múltiplos disparos do job em paralelo"
echo "./01-create-project.sh→ Cria estrutura inicial do projeto Spring Batch"
echo
echo "✅ Dica: use 'make <alvo>' para automatizar o fluxo ou rode os scripts diretamente."
