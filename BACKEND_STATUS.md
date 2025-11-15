# 🚀 Status do Backend

## ✅ **Backend Iniciado!**

O backend está rodando em segundo plano (background).

---

## 📍 **Informações:**

- **URL:** `http://localhost:3000`
- **Status:** ✅ Rodando em background
- **MongoDB:** ✅ Conectado

---

## 🔗 **Endpoints Disponíveis:**

### **Autenticação:**
- `POST /api/auth/login` - Fazer login
- `POST /api/auth/register` - Registrar novo usuário
- `GET /api/auth/verify` - Verificar token
- `POST /api/auth/logout` - Fazer logout

### **Usuários:**
- `GET /api/users/:userId` - Obter usuário
- `PUT /api/users/:userId` - Atualizar usuário

### **Refeições:**
- `GET /api/meals/user/:userId/date/:date` - Obter refeições do dia
- `POST /api/meals` - Criar refeição
- `PUT /api/meals/id/:mealId` - Atualizar refeição
- `DELETE /api/meals/id/:mealId` - Deletar refeição

### **Métricas Corporais:**
- `GET /api/body-metrics/user/:userId` - Obter métricas
- `POST /api/body-metrics` - Criar métricas
- `PUT /api/body-metrics/id/:metricId` - Atualizar métricas
- `DELETE /api/body-metrics/id/:metricId` - Deletar métricas

### **Consumo de Água:**
- `GET /api/water-intake/user/:userId/today` - Obter consumo de hoje
- `POST /api/water-intake` - Adicionar água
- `DELETE /api/water-intake/user/:userId/today` - Resetar consumo de hoje

### **Health Check:**
- `GET /health` - Verificar status
- `GET /` - Informações da API

---

## 👥 **Usuários de Teste Disponíveis:**

### **Admin:**
- Email: `demoadmin@email.com`
- Senha: `admin123`

### **User:**
- Email: `demouser@email.com`
- Senha: `user123`

### **Admin (Original):**
- Email: `admin@test.com`
- Senha: `admin123`

### **User (Original):**
- Email: `user@test.com`
- Senha: `user123`

---

## 🧪 **Testar Backend:**

### **Via Navegador:**
Acesse: `http://localhost:3000`

Deve aparecer:
```json
{
  "message": "NUDGE Backend API",
  "version": "1.0.0",
  "status": "running"
}
```

### **Via curl:**
```bash
# Health check
curl http://localhost:3000/health

# Login
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"demoadmin@email.com\",\"password\":\"admin123\"}"
```

---

## ⚠️ **Importante:**

- O backend está rodando em **background**
- Para **parar** o backend, você precisa fechar o processo ou reiniciar o terminal
- Se você fechar o terminal, o backend **parará**
- Para manter sempre rodando, use um gerenciador de processos como `pm2` ou faça deploy na nuvem (Render/Railway)

---

## 🔄 **Para Parar o Backend:**

1. **Via Terminal (PowerShell):**
   ```powershell
   # Encontrar processo
   Get-Process node
   
   # Parar processo (substitua PID pelo número do processo)
   Stop-Process -Id PID -Force
   ```

2. **Via Task Manager:**
   - Abra o Gerenciador de Tarefas
   - Procure por `node.exe`
   - Clique em "Finalizar tarefa"

---

## 📝 **Próximos Passos:**

1. ✅ Backend está rodando
2. ✅ Usuários demo criados
3. ✅ Pronto para testar login no app!

---

**🚀 Backend está rodando! Teste o login no app agora!**

