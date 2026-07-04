# Makefile - Automação do projeto Spring Batch Job

APP_NAME = spring-batch-job
VERSION = 1.0.0

.PHONY: test validate monitor deploy parallel clean dashboard h2console create-project

test:
    @echo "🧪 Rodando testes..."
    ./run-tests.sh

validate:
    @echo "📂 Validando CSV..."
    ./validate-csv.sh

monitor:
    @echo "📊 Monitorando job..."
    ./monitor-job.sh

deploy:
    @echo "🚀 Fazendo deploy em Docker..."
    ./build-docker.sh

parallel:
    @echo "⚡ Rodando jobs em paralelo..."
    ./parallel-run.sh

clean:
    @echo "🧹 Limpando build..."
    mvn clean

dashboard:
    @echo "🌐 Abrindo dashboard no navegador..."
    xdg-open http://localhost:8080/

h2console:
    @echo "🗄️ Abrindo console H2 no navegador..."
    xdg-open http://localhost:8080/h2-console

create-project:
    @echo "📂 Criando estrutura inicial do projeto..."
    ./01-create-project.sh
