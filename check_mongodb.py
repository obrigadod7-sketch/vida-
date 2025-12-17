#!/usr/bin/env python3
"""
Script para testar conexão com MongoDB Atlas
"""

import os
import sys
import asyncio
from pathlib import Path

def print_step(emoji, text):
    print(f"{emoji} {text}")

async def main():
    print("\n" + "="*60)
    print("  🔍 TESTANDO CONEXÃO MONGODB")
    print("="*60 + "\n")
    
    # Carregar .env
    env_file = Path('/app/backend/.env')
    if env_file.exists():
        from dotenv import load_dotenv
        load_dotenv(env_file)
        print_step("✅", "Arquivo .env carregado")
    else:
        print_step("❌", "Arquivo .env não encontrado!")
        print("   Crie o arquivo: /app/backend/.env")
        return 1
    
    mongo_url = os.environ.get('MONGO_URL')
    
    if not mongo_url:
        print_step("❌", "MONGO_URL não configurado no .env")
        print("\n📝 Configure assim:")
        print("   MONGO_URL=mongodb+srv://user:senha@cluster.mongodb.net/watizat_db")
        return 1
    
    # Esconder senha na exibição
    safe_url = mongo_url
    if '@' in mongo_url:
        parts = mongo_url.split('@')
        if ':' in parts[0]:
            user_part = parts[0].split(':')[0]
            safe_url = f"{user_part}:***@{parts[1]}"
    
    print_step("📋", f"MONGO_URL: {safe_url}")
    
    # Detectar tipo
    if 'mongodb+srv://' in mongo_url:
        print_step("☁️", "Tipo: MongoDB Atlas (Cloud)")
    elif 'localhost' in mongo_url or '127.0.0.1' in mongo_url:
        print_step("💻", "Tipo: MongoDB Local")
    else:
        print_step("🌐", "Tipo: MongoDB Remoto")
    
    print("\n" + "-"*60)
    print("  🔌 TESTANDO CONEXÃO...")
    print("-"*60 + "\n")
    
    try:
        from motor.motor_asyncio import AsyncIOMotorClient
        
        print_step("⏳", "Conectando ao MongoDB...")
        client = AsyncIOMotorClient(mongo_url, serverSelectionTimeoutMS=10000)
        
        # Testar conexão
        await client.admin.command('ping')
        print_step("✅", "Conexão bem-sucedida!")
        
        # Informações do servidor
        server_info = await client.admin.command('serverStatus')
        version = server_info.get('version', 'Desconhecida')
        print_step("📊", f"Versão do MongoDB: {version}")
        
        # Listar databases
        dbs = await client.list_database_names()
        print_step("📚", f"Databases encontrados: {len(dbs)}")
        
        # Verificar database watizat_db
        db_name = os.environ.get('DB_NAME', 'watizat_db')
        if db_name in dbs:
            print_step("✅", f"Database '{db_name}' existe")
            
            db = client[db_name]
            collections = await db.list_collection_names()
            print_step("📦", f"Collections: {len(collections)}")
            
            if collections:
                print("   Collections encontradas:")
                for coll in collections:
                    count = await db[coll].count_documents({})
                    print(f"   • {coll}: {count} documentos")
        else:
            print_step("ℹ️", f"Database '{db_name}' será criado automaticamente")
            print("   (Normal para primeira execução)")
        
        client.close()
        
        print("\n" + "="*60)
        print("  🎉 SUCESSO! MongoDB está funcionando perfeitamente!")
        print("="*60)
        
        return 0
        
    except Exception as e:
        error_msg = str(e)
        print_step("❌", "ERRO ao conectar!")
        print(f"\n📋 Detalhes do erro:\n   {error_msg}\n")
        
        # Sugestões baseadas no erro
        print("💡 Possíveis soluções:\n")
        
        if "Authentication failed" in error_msg or "auth" in error_msg.lower():
            print("   1. Verifique se substituiu <password> pela senha real")
            print("   2. Certifique-se que usuário/senha estão corretos")
            print("   3. Senha com caracteres especiais? Use URL encoding")
            
        elif "Connection refused" in error_msg:
            print("   1. MongoDB local não está rodando")
            print("      Execute: sudo supervisorctl start mongodb")
            print("   2. Ou use MongoDB Atlas (cloud) - mais fácil!")
            
        elif "timeout" in error_msg.lower():
            print("   1. Verifique conexão com internet")
            print("   2. Libere IP 0.0.0.0/0 no MongoDB Atlas Network Access")
            print("   3. Aguarde alguns minutos (cluster pode estar iniciando)")
            
        elif "hostname" in error_msg.lower() or "resolve" in error_msg.lower():
            print("   1. Verifique se a URL está correta")
            print("   2. Formato: mongodb+srv://user:pass@cluster.mongodb.net/db")
            
        else:
            print("   1. Verifique se MONGO_URL está no formato correto")
            print("   2. MongoDB Atlas: mongodb+srv://...")
            print("   3. MongoDB Local: mongodb://localhost:27017/watizat_db")
        
        print("\n📚 Veja o guia completo: MONGODB_ATLAS_SIMPLES.md")
        
        return 1

if __name__ == "__main__":
    sys.exit(asyncio.run(main()))
