# 🚀 MongoDB Atlas - Guia Super Simples (5 minutos)

## Passo 1: Criar Conta (2 min)

1. Abra: **https://www.mongodb.com/cloud/atlas/register**

2. Preencha:
   - Email: `seu_email@gmail.com`
   - Senha: `sua_senha_forte`
   
3. Clique em **"Create your Atlas account"**

4. **Confirme seu email** (verifique a caixa de entrada)

---

## Passo 2: Criar Cluster GRATUITO (2 min)

1. Após login, clique em **"+ Create"** ou **"Build a Database"**

2. Escolha: **"M0 - FREE"** (plano gratuito)
   - ✅ 512 MB storage (suficiente!)
   - ✅ Shared cluster
   - ✅ Grátis para sempre

3. Configurações:
   - **Provider**: AWS (deixe selecionado)
   - **Region**: Escolha o mais próximo (ex: São Paulo ou Frankfurt)
   - **Cluster Name**: `WatizatCluster` (ou deixe padrão)

4. Clique em **"Create Cluster"**

⏱️ Aguarde 1-3 minutos (o cluster está sendo criado)

---

## Passo 3: Criar Usuário do Banco (1 min)

Vai aparecer uma tela pedindo para criar usuário:

1. **Username**: `watizat_user`
2. **Password**: Clique em "Autogenerate Secure Password" 
   - 📋 **COPIE E SALVE** essa senha em algum lugar seguro!
   - Exemplo: `Xa8kL2mP9nQ5r`

3. Clique em **"Create User"**

---

## Passo 4: Liberar Acesso (30 seg)

1. Na mesma tela ou vá em **"Network Access"**

2. Clique em **"Add IP Address"**

3. Escolha: **"Allow Access from Anywhere"** (0.0.0.0/0)
   - Para desenvolvimento/teste, isso é OK
   - Para produção, use IPs específicos

4. Clique em **"Confirm"**

---

## Passo 5: Obter Connection String (30 seg)

1. Volte para **"Database"** (menu lateral)

2. Clique em **"Connect"** no seu cluster

3. Escolha **"Drivers"** (ou "Connect your application")

4. Selecione:
   - **Driver**: Python
   - **Version**: 3.6 or later

5. **COPIE** a Connection String que aparece:

```
mongodb+srv://watizat_user:<password>@cluster0.xxxxx.mongodb.net/?retryWrites=true&w=majority
```

6. **IMPORTANTE**: Substitua `<password>` pela senha que você salvou!

**Exemplo final:**
```
mongodb+srv://watizat_user:Xa8kL2mP9nQ5r@cluster0.abcde.mongodb.net/watizat_db?retryWrites=true&w=majority
```

📋 **COPIE essa string completa!**

---

## ✅ Pronto! Agora use a URL

Você tem duas opções:

### Opção A: Testar Localmente Primeiro

```bash
# Edite o arquivo
nano /app/backend/.env

# Cole sua URL do MongoDB Atlas:
MONGO_URL=mongodb+srv://watizat_user:SUA_SENHA@cluster0.xxxxx.mongodb.net/watizat_db

# Salve (Ctrl+O, Enter, Ctrl+X)

# Reinicie o backend
sudo supervisorctl restart backend
```

### Opção B: Usar Direto no Deploy

Quando fizer deploy no **Render** ou **Railway**, adicione a variável:

**Nome:** `MONGO_URL`  
**Valor:** `mongodb+srv://watizat_user:SUA_SENHA@cluster0.xxxxx.mongodb.net/watizat_db`

---

## 🎉 Fim!

Seu MongoDB Atlas está pronto! 

**Recursos do Plano Gratuito:**
- ✅ 512 MB de storage
- ✅ Ilimitado para sempre
- ✅ Conexões simultâneas: até 500
- ✅ Backups: Não (só em planos pagos)

---

## 🐛 Problemas?

### "Authentication failed"
- ✅ Certifique-se que substituiu `<password>` pela senha real
- ✅ Senha não pode ter caracteres especiais sem encoding

### "Connection timeout"
- ✅ Verifique se liberou IP 0.0.0.0/0 no Network Access
- ✅ Aguarde alguns minutos (cluster pode estar iniciando)

### "No database found"
- ✅ Normal! O database é criado automaticamente ao inserir dados
- ✅ Use o app normalmente que ele cria sozinho

---

## 📞 Precisa de Ajuda?

Execute o verificador:
```bash
python3 /app/check_mongodb.py
```

Vai testar sua conexão automaticamente!

---

**Tempo total: ~5 minutos** ⏱️  
**Custo: R$ 0,00 (Grátis para sempre!)** 💰
