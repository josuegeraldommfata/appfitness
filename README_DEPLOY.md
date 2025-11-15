# 🚀 Guia de Deploy - NUDGE App

## 📋 **O Que Você Precisa Saber**

### ✅ **MongoDB Atlas**
- **Já está 24/7 na nuvem!** ✅
- **Não precisa fazer nada!**
- Funciona automaticamente

### ⚠️ **Backend Node.js**
- **Precisa hospedar em algum lugar 24/7**
- **Recomendado:** Railway (fácil e grátis para começar)
- **Tempo:** ~30 minutos para fazer deploy

### ⚠️ **App Flutter**
- **Precisa atualizar URL** após deploy do backend
- **Não pode usar `localhost`** na Play Store
- **Precisa URL HTTPS pública**

---

## 🎯 **O Que Acontece Quando Publicar na Play Store**

```
┌─────────────────┐
│ App na Play     │
│ Store           │
│ (Dispositivo)   │
└────────┬────────┘
         │
         │ HTTPS
         │ https://seu-backend.railway.app
         ▼
┌─────────────────┐
│ Backend Railway │ ← PRECISA ESTAR AQUI!
│ (24/7 na nuvem) │    (Você faz deploy)
└────────┬────────┘
         │
         │ MongoDB URI
         │ mongodb+srv://...
         ▼
┌─────────────────┐
│ MongoDB Atlas   │ ← JÁ ESTÁ AQUI!
│ (24/7 na nuvem) │    (Já configurado ✅)
└─────────────────┘
```

---

## 🚀 **Guia Rápido:**

1. **Leia:** `GUIA_DEPLOY_SIMPLES.md` (5 passos)
2. **Ou leia:** `COMO_FAZER_DEPLOY.md` (guia completo)
3. **Referência:** `DEPLOY_RAILWAY.md` (detalhes técnicos)

---

## ⏱️ **Tempo Estimado:**

- **Preparação:** 10 min (GitHub)
- **Deploy Railway:** 10 min
- **Configuração:** 5 min
- **Testes:** 5 min
- **Total:** ~30 minutos

---

## 💰 **Custo:**

- **Gratuito:** $0/mês (MongoDB Atlas Free + Railway créditos)
- **Básico:** $5/mês (Railway pago)

---

**🚀 Comece pelo `GUIA_DEPLOY_SIMPLES.md` ou `COMO_FAZER_DEPLOY.md`!**

