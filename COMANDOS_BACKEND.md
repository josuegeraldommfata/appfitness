# 🚀 Comandos do Backend - Guia Rápido

## 📋 **Comandos Principais:**

### **1. Rodar Backend (Produção):**
```bash
cd backend
npm start
```

### **2. Rodar Backend (Desenvolvimento - com auto-reload):**
```bash
cd backend
npm run dev
```

---

## 📂 **Localização:**

Se você está na raiz do projeto:
```bash
cd "C:\Users\FIREWALL\Pictures\niudge\nudge-main\backend"
npm start
```

Ou simplesmente:
```bash
cd backend
npm start
```

---

## ✅ **O Que Acontece:**

Quando você roda `npm start`, você verá:

```
✅ MongoDB connected successfully
📍 Database: nudge
🌐 Host: ac-xxx-shard-00-01.ixd6wep.mongodb.net
🚀 Server running on port 3000
📍 Environment: development
🌐 API URL: http://localhost:3000
```

---

## 🔍 **Verificar Se Está Rodando:**

Abra um navegador e acesse:
```
http://localhost:3000
```

Deve aparecer:
```json
{
  "message": "NUDGE Backend API",
  "version": "1.0.0",
  "status": "running"
}
```

---

## 📋 **Outros Comandos Úteis:**

### **Inicializar Banco de Dados:**
```bash
cd backend
npm run init-db
```

### **Criar Usuários de Teste:**
```bash
cd backend
npm run create-test-users
```

### **Criar Usuários Demo:**
```bash
cd backend
npm run create-demo-users
```

### **Instalar Dependências (se necessário):**
```bash
cd backend
npm install
```

---

## ⚠️ **Importante:**

- **Deixe o terminal aberto** enquanto o backend está rodando
- **Não feche o terminal** ou o backend para
- Para **parar** o backend: pressione `Ctrl + C` no terminal
- O backend precisa estar rodando para o app funcionar

---

## 🚀 **Para Produção (Deploy na Nuvem):**

Quando você fizer deploy no Render/Railway, eles rodam automaticamente:
```bash
npm start
```

Você não precisa fazer nada - eles executam isso automaticamente!

---

**🚀 Use `cd backend; npm start` para rodar o backend agora!**

