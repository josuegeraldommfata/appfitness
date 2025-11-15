# 🚀 Deploy do Backend NUDGE

## 📋 **Resumo:**

Este backend precisa estar hospedado em um serviço de nuvem (Railway, Render, etc.) para funcionar quando o app estiver publicado na Play Store.

**MongoDB Atlas:** ✅ Já está 24/7 na nuvem - não precisa fazer nada!

**Backend:** ⚠️ Precisa fazer deploy - siga o guia abaixo!

---

## 🚀 **Deploy Rápido - Railway (Recomendado):**

### **1. Pré-requisitos:**
- Conta no GitHub
- Backend funcionando localmente

### **2. Passos:**
1. Acesse: https://railway.app
2. Login com GitHub
3. "New Project" → "Deploy from GitHub repo"
4. Selecione o repositório e pasta `backend`
5. Configure variáveis de ambiente:
   ```
   NODE_ENV=production
   MONGODB_URI=mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge?retryWrites=true&w=majority
   ```
6. Aguarde deploy (2-5 minutos)
7. Copie a URL gerada (ex: `https://nudge-backend.railway.app`)
8. Atualize `lib/config/payment_config.dart` no app Flutter

### **3. Inicializar Banco:**
```bash
railway run npm run init-db
railway run npm run create-test-users
```

### **4. Pronto!**
Backend está rodando 24/7! 🎉

---

## 📚 **Documentação Completa:**
- Veja `DEPLOY_PRODUCAO.md` para explicação detalhada
- Veja `DEPLOY_RAILWAY.md` para guia passo a passo do Railway

---

## 💰 **Custos:**
- **Grátis:** $5 créditos/mês (Railway)
- **Pago:** $5/mês para uso contínuo
- **MongoDB:** Grátis (tier M0) ou $9/mês

---

**Tempo estimado:** 30 minutos para ter tudo funcionando!

