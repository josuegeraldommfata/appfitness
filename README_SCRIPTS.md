# 📜 Scripts de Automação - Deploy

## 🎯 **Scripts Disponíveis**

Todos os scripts estão na pasta `scripts/` e podem ser executados no PowerShell.

---

## 🚀 **Scripts Principais**

### **1. `deploy_completo.ps1`** ⭐ **COMECE AQUI!**
Script completo que executa todos os passos automáticos.

```powershell
.\scripts\deploy_completo.ps1
```

**O que faz:**
- ✅ Verifica arquivos necessários
- ✅ Inicializa Git (se necessário)
- ✅ Instala dependências
- ✅ Oferece inicializar banco de dados
- ✅ Mostra resumo e próximos passos

---

### **2. `prepare_deploy.ps1`**
Prepara o projeto para deploy.

```powershell
.\scripts\prepare_deploy.ps1
```

**O que faz:**
- ✅ Verifica arquivos necessários
- ✅ Verifica Git
- ✅ Instala dependências do backend
- ✅ Cria arquivo .env (se necessário)

---

### **3. `init_database.ps1`**
Inicializa o banco de dados MongoDB Atlas.

```powershell
.\scripts\init_database.ps1
```

**O que faz:**
- ✅ Cria collections e indexes
- ✅ Cria usuários de teste (admin@test.com / admin123)

---

### **4. `update_app_url.ps1`**
Atualiza a URL do backend no código Flutter.

```powershell
.\scripts\update_app_url.ps1
```

**O que faz:**
- ✅ Solicita URL do Railway
- ✅ Atualiza `lib/config/payment_config.dart`
- ✅ Cria backup do arquivo original

---

### **5. `check_railway_status.ps1`**
Verifica se o backend está funcionando no Railway.

```powershell
.\scripts\check_railway_status.ps1
```

**O que faz:**
- ✅ Testa health check
- ✅ Testa endpoint raiz
- ✅ Testa login
- ✅ Mostra status do deploy

---

## 📋 **Como Usar**

### **Opção 1: Executar Script Completo (Recomendado)**

```powershell
# Na raiz do projeto
.\scripts\deploy_completo.ps1
```

### **Opção 2: Executar Scripts Individualmente**

```powershell
# 1. Preparar projeto
.\scripts\prepare_deploy.ps1

# 2. Inicializar banco (quando quiser)
.\scripts\init_database.ps1

# 3. Depois do deploy no Railway, atualizar URL
.\scripts\update_app_url.ps1

# 4. Verificar se está funcionando
.\scripts\check_railway_status.ps1
```

---

## ⚠️ **Importante**

- Os scripts executam **automaticamente** o que é possível
- **Você ainda precisa** fazer manualmente:
  - Criar conta no GitHub
  - Fazer upload do código para GitHub
  - Criar conta no Railway
  - Fazer deploy no Railway
  - Copiar URL do Railway

---

## 🆘 **Problemas?**

Se algum script não funcionar:

1. Verifique se está executando no PowerShell (não CMD)
2. Verifique se está na raiz do projeto
3. Execute: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`

---

## 📚 **Documentação Completa**

- `COMEÇAR_DEPLOY_AQUI.md` - Guia passo a passo
- `COMO_FAZER_DEPLOY.md` - Guia completo
- `DEPLOY_RAILWAY.md` - Detalhes técnicos

---

**🚀 Comece executando `deploy_completo.ps1`!**

