# 📝 MongoDB Atlas - Passo a Passo com Imagens

## 🎯 Objetivo
Criar um banco de dados GRATUITO na nuvem em 5 minutos.

---

## 📋 Checklist Rápido

Siga esta ordem:

1. [ ] Criar conta no MongoDB Atlas
2. [ ] Criar cluster M0 (gratuito)
3. [ ] Criar usuário do banco
4. [ ] Liberar acesso de rede
5. [ ] Copiar connection string
6. [ ] Substituir senha na connection string
7. [ ] Configurar no projeto
8. [ ] Testar conexão

---

## 🚀 PASSO 1: Criar Conta

### O que fazer:
1. Abra seu navegador
2. Vá para: **https://www.mongodb.com/cloud/atlas/register**
3. Preencha o formulário:

```
📧 Email: seu_email@example.com
🔐 Senha: Crie uma senha forte (ex: Mongo@2024!)
✅ Aceite os termos
```

4. Clique em **"Create your Atlas account"**

### O que você verá:
- Tela de boas-vindas
- Email de confirmação enviado

### Ação:
- ✅ Abra seu email
- ✅ Clique no link de confirmação
- ✅ Faça login

**Status:** [ ] Completo

---

## 🗄️ PASSO 2: Criar Cluster (Banco de Dados)

### O que fazer:
Após login, você verá a tela inicial.

1. Clique em **"+ Create"** ou **"Build a Database"**

2. Você verá 3 opções de plano:

```
❌ Serverless    (Pago)
❌ Dedicated     (Pago)
✅ Shared        (GRATUITO) ← ESCOLHA ESTE!
```

3. Clique em **"Create"** abaixo de "Shared"

4. Configurações:

```
☁️ Cloud Provider: AWS (deixe marcado)
📍 Region: Escolha o mais próximo
   • Brazil (São Paulo)
   • Europe (Frankfurt)
   • US East (Virginia)

💰 Cluster Tier: M0 Sandbox (FREE)
   • 512 MB Storage
   • Shared RAM
   • Grátis para sempre!

🏷️ Cluster Name: WatizatCluster (ou deixe padrão)
```

5. Clique em **"Create Cluster"** (botão verde no final)

### O que você verá:
- Mensagem: "Your cluster is being created..."
- Barra de progresso
- ⏱️ Aguarde 1-3 minutos

**Status:** [ ] Completo

---

## 👤 PASSO 3: Criar Usuário do Banco

### O que fazer:
Após o cluster ser criado, aparecerá automaticamente:

**Tela: "Security Quickstart"**

1. Seção: "How would you like to authenticate?"

2. Escolha: **"Username and Password"** (já vem selecionado)

3. Preencha:

```
👤 Username: watizat_user

🔐 Password: 
   [ ] Digite sua própria senha
   [✅] Autogenerate Secure Password ← RECOMENDADO!
```

4. **IMPORTANTE:** Clique em **"Autogenerate Secure Password"**

5. **COPIE A SENHA GERADA!** 📋
   - Exemplo: `Xa8kL2mP9nQ5r`
   - Cole em um bloco de notas
   - Você vai precisar depois!

6. Clique em **"Create User"**

**Status:** [ ] Completo  
**Senha salva:** [ ] Sim

---

## 🌐 PASSO 4: Liberar Acesso de Rede

### O que fazer:
Na mesma tela ou próxima etapa:

**Tela: "Where would you like to connect from?"**

1. Você verá duas opções:

```
[ ] My Local Environment
[✅] Cloud Environment ← Escolha esta
```

2. Ou vá direto e adicione IP:

**Método Mais Fácil:**

```
IP Address: 0.0.0.0/0
Description: Allow from anywhere
```

3. Clique em **"Add Entry"** ou **"Add IP Address"**

4. Clique em **"Finish and Close"**

### Por que 0.0.0.0/0?
- ✅ Permite acesso de qualquer lugar
- ✅ Perfeito para desenvolvimento/teste
- ✅ Funciona com Render/Railway automaticamente

⚠️ **Para produção:** Use IPs específicos (mais seguro)

**Status:** [ ] Completo

---

## 🔗 PASSO 5: Obter Connection String

### O que fazer:

1. Na tela principal, você verá seu cluster (WatizatCluster ou Cluster0)

2. Clique no botão **"Connect"**

3. Escolha: **"Drivers"** (ou "Connect your application")

4. Selecione:
```
Driver: Python
Version: 3.6 or later
```

5. Você verá uma **Connection String** assim:

```
mongodb+srv://watizat_user:<password>@cluster0.xxxxx.mongodb.net/?retryWrites=true&w=majority
```

6. Clique em **"Copy"** 📋

**Status:** [ ] Completo

---

## ✏️ PASSO 6: Substituir Senha

### O que fazer:

Você copiou algo assim:
```
mongodb+srv://watizat_user:<password>@cluster0.xxxxx.mongodb.net/?retryWrites=true&w=majority
```

**IMPORTANTE:** Substitua `<password>` pela senha que você salvou!

### Exemplo:

**ANTES (errado):**
```
mongodb+srv://watizat_user:<password>@cluster0.abcde.mongodb.net/?retryWrites=true&w=majority
```

**DEPOIS (correto):**
```
mongodb+srv://watizat_user:Xa8kL2mP9nQ5r@cluster0.abcde.mongodb.net/watizat_db?retryWrites=true&w=majority
```

**Observações:**
- ✅ Remove os símbolos `<` e `>`
- ✅ Adicione `/watizat_db` antes do `?` (nome do banco)
- ✅ Sem espaços

**Status:** [ ] Completo

---

## ⚙️ PASSO 7: Configurar no Projeto

### Opção A: Testar Localmente (Recomendado)

1. Edite o arquivo `.env`:
```bash
nano /app/backend/.env
```

2. Substitua a linha `MONGO_URL=...` pela sua connection string:
```env
MONGO_URL=mongodb+srv://watizat_user:SUA_SENHA@cluster0.xxxxx.mongodb.net/watizat_db?retryWrites=true&w=majority
```

3. Salve:
   - Pressione `Ctrl + O`
   - Pressione `Enter`
   - Pressione `Ctrl + X`

4. Reinicie o backend:
```bash
sudo supervisorctl restart backend
```

### Opção B: Configurar para Deploy (Render/Railway)

**Render:**
1. Dashboard → Your Service → Environment
2. Clique em "Add Environment Variable"
3. Key: `MONGO_URL`
4. Value: Cole sua connection string completa
5. Salve

**Railway:**
1. Dashboard → Variables
2. Clique em "New Variable"
3. Variable: `MONGO_URL`
4. Value: Cole sua connection string completa
5. Salve

**Status:** [ ] Completo

---

## ✅ PASSO 8: Testar Conexão

### O que fazer:

Execute o script de teste:
```bash
cd /app
python3 check_mongodb.py
```

### O que você deve ver:

```
============================================================
  🔍 TESTANDO CONEXÃO MONGODB
============================================================

✅ Arquivo .env carregado
📋 MONGO_URL: mongodb+srv://watizat_user:***@cluster0...
☁️ Tipo: MongoDB Atlas (Cloud)

------------------------------------------------------------
  🔌 TESTANDO CONEXÃO...
------------------------------------------------------------

⏳ Conectando ao MongoDB...
✅ Conexão bem-sucedida!
📊 Versão do MongoDB: 7.x.x
📚 Databases encontrados: 1
ℹ️ Database 'watizat_db' será criado automaticamente

============================================================
  🎉 SUCESSO! MongoDB está funcionando perfeitamente!
============================================================
```

**Status:** [ ] Completo

---

## 🎉 PARABÉNS!

Se você chegou até aqui com tudo ✅, seu MongoDB Atlas está:

- ✅ Configurado
- ✅ Conectado
- ✅ Funcionando
- ✅ Pronto para usar!

---

## 🐛 Problemas Comuns

### Erro: "Authentication failed"

**Causa:** Senha incorreta

**Solução:**
1. Volte ao MongoDB Atlas
2. Database Access → Edit User
3. Reset Password
4. Copie a nova senha
5. Atualize o `.env`

---

### Erro: "Connection timeout"

**Causa:** IP não liberado

**Solução:**
1. MongoDB Atlas → Network Access
2. Verifique se tem `0.0.0.0/0`
3. Se não tiver, adicione:
   - Click "Add IP Address"
   - "Allow Access from Anywhere"
   - Confirm

---

### Erro: "Cannot connect to server"

**Causa:** URL incorreta

**Solução:**
1. Volte ao cluster
2. Click "Connect" → "Drivers"
3. Copie a URL novamente
4. Certifique-se de substituir `<password>`

---

## 📚 Recursos

- **Atlas Docs:** https://docs.atlas.mongodb.com/
- **Support:** https://support.mongodb.com/
- **Community:** https://community.mongodb.com/

---

## ⏱️ Tempo Total

- Criação de conta: 2 min
- Configuração do cluster: 2 min
- Obter connection string: 1 min
- Configurar no projeto: 30 seg

**Total: ~5 minutos** ⏱️

---

## 💰 Custos

**Plano M0 (Gratuito):**
- ✅ 512 MB storage
- ✅ Compartilhado
- ✅ Até 500 conexões
- ✅ Grátis PARA SEMPRE
- ❌ Sem backups automáticos

**Quando atualizar:**
- Se precisar de mais de 512 MB
- Se precisar de backups
- Se precisar de melhor performance

**Planos pagos começam em $9/mês**

---

**Pronto! Seu MongoDB Atlas está configurado! 🚀**
