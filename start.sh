#!/bin/bash

echo "🚀 Iniciando Watizat Application..."

# Verificar se MongoDB está acessível
echo "📊 Verificando conexão com MongoDB..."
if ! timeout 5 bash -c "cat < /dev/null > /dev/tcp/localhost/27017" 2>/dev/null; then
    echo "⚠️  MongoDB não está rodando localmente. Certifique-se de configurar MONGO_URL no .env"
    echo "💡 Para MongoDB Atlas: https://www.mongodb.com/cloud/atlas"
fi

# Instalar dependências do backend se necessário
if [ ! -d "/app/backend/__pycache__" ]; then
    echo "📦 Instalando dependências do backend..."
    cd /app/backend && pip install -r requirements.txt
fi

# Instalar dependências do frontend se necessário
if [ ! -d "/app/frontend/node_modules" ]; then
    echo "📦 Instalando dependências do frontend..."
    cd /app/frontend && yarn install
fi

# Criar diretórios de log se não existirem
mkdir -p /var/log/supervisor

# Iniciar supervisord
echo "✅ Iniciando serviços..."
supervisord -c /app/supervisord.conf
