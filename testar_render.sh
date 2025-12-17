#!/bin/bash

# Script para testar se o deploy no Render vai funcionar

echo "╔════════════════════════════════════════════════════════════╗"
echo "║   🔍 DIAGNÓSTICO RENDER - Watizat                         ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Função para mostrar status
show_ok() {
    echo "✅ $1"
}

show_error() {
    echo "❌ $1"
}

show_info() {
    echo "ℹ️  $1"
}

show_warn() {
    echo "⚠️  $1"
}

# Pedir URLs do Render
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Insira as URLs do seu deploy no Render"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

read -p "URL do Backend (ex: https://watizat-backend.onrender.com): " BACKEND_URL
read -p "URL do Frontend (ex: https://watizat-frontend.onrender.com): " FRONTEND_URL

# Remover barra do final se tiver
BACKEND_URL=${BACKEND_URL%/}
FRONTEND_URL=${FRONTEND_URL%/}

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  🧪 TESTANDO BACKEND"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Teste 1: Backend raiz
echo "Teste 1: Health Check Raiz"
response=$(curl -s -o /dev/null -w "%{http_code}" "$BACKEND_URL/" 2>/dev/null)

if [ "$response" = "200" ]; then
    show_ok "Backend responde na raiz ($response)"
else
    show_error "Backend não responde ($response)"
    show_info "Aguarde 30-60s se service estava dormindo"
fi

# Teste 2: API endpoint
echo ""
echo "Teste 2: API Endpoint"
response=$(curl -s -o /dev/null -w "%{http_code}" "$BACKEND_URL/api" 2>/dev/null)

if [ "$response" = "200" ]; then
    show_ok "API /api responde ($response)"
    # Mostrar resposta
    api_response=$(curl -s "$BACKEND_URL/api" 2>/dev/null)
    echo "   Resposta: $api_response"
else
    show_error "API /api não responde ($response)"
fi

# Teste 3: Health check
echo ""
echo "Teste 3: Database Health"
health_response=$(curl -s "$BACKEND_URL/health" 2>/dev/null)

if echo "$health_response" | grep -q "healthy"; then
    show_ok "MongoDB conectado"
    echo "   Status: $health_response"
elif echo "$health_response" | grep -q "unhealthy"; then
    show_error "MongoDB desconectado"
    echo "   Status: $health_response"
    show_warn "Verifique MONGO_URL no Render"
else
    show_warn "Health check não respondeu"
fi

# Teste 4: CORS
echo ""
echo "Teste 4: CORS Headers"
cors_headers=$(curl -s -I "$BACKEND_URL/api" 2>/dev/null | grep -i "access-control")

if [ ! -z "$cors_headers" ]; then
    show_ok "CORS configurado"
else
    show_warn "CORS headers não detectados"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  🎨 TESTANDO FRONTEND"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Teste 5: Frontend carrega
echo "Teste 5: Frontend Carrega"
response=$(curl -s -o /dev/null -w "%{http_code}" "$FRONTEND_URL" 2>/dev/null)

if [ "$response" = "200" ]; then
    show_ok "Frontend responde ($response)"
else
    show_error "Frontend não responde ($response)"
fi

# Teste 6: Verificar se tem REACT_APP_BACKEND_URL
echo ""
echo "Teste 6: Configuração Frontend"
frontend_html=$(curl -s "$FRONTEND_URL" 2>/dev/null)

if echo "$frontend_html" | grep -q "react"; then
    show_ok "React app detectado"
else
    show_warn "HTML não parece ser React"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  📊 RESUMO"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "Backend: $BACKEND_URL"
echo "Frontend: $FRONTEND_URL"
echo ""

echo "📋 PRÓXIMOS PASSOS:"
echo ""

# Verificar se backend está ok
if [ "$response" = "200" ]; then
    echo "✅ Backend: FUNCIONANDO"
else
    echo "❌ Backend: COM PROBLEMAS"
    echo ""
    echo "   🔧 Soluções:"
    echo "   1. Verifique MONGO_URL no Render"
    echo "   2. Formato: mongodb+srv://user:SENHA@cluster.mongodb.net/watizat_db"
    echo "   3. Libere IP 0.0.0.0/0 no MongoDB Atlas"
    echo "   4. Reinicie o service no Render"
fi

echo ""
echo "📚 Guia completo: /app/RESOLVER_ERRO_RENDER.md"
echo ""

# Gerar comando para configurar frontend
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ⚙️  CONFIGURAÇÃO RENDER"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "No Render Dashboard, configure:"
echo ""
echo "Frontend Environment:"
echo "  REACT_APP_BACKEND_URL=$BACKEND_URL"
echo ""
echo "Backend Environment:"
echo "  MONGO_URL=mongodb+srv://user:senha@cluster.mongodb.net/watizat_db"
echo "  JWT_SECRET=seu_secret_seguro"
echo "  EMERGENT_LLM_KEY=sk-emergent-b8cEdA5822d14C0638"
echo ""
