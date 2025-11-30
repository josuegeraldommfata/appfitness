# 🔑 Como Criar o Arquivo .env do Backend

## ✅ **JÁ CRIADO!**

O arquivo `backend/.env` já foi criado automaticamente com todas as chaves reais!

## 📍 **Localização:**
```
backend/.env
```

## 🔐 **Chaves Configuradas:**

✅ **Stripe Secret Key**: `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`

✅ **Mercado Pago Access Token**: `APP_USR-962011830720089-111415-bcffcdf3b9ab0b8982cd406d845391f0-2991374520`

✅ **Mercado Pago Public Key**: `APP_USR-d766e8e8-fa64-4265-b19a-5295dc6a0a7f`

✅ **MongoDB URI**: `mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge`

## 🚀 **Para Testar:**

1. **Inicie o backend:**
   ```bash
   cd backend
   npm start
   ```

2. **As chaves já estão configuradas!**

## ⚠️ **IMPORTANTE:**

- O arquivo `.env` está no `.gitignore` (não vai pro GitHub) ✅
- As chaves públicas estão no código Dart (seguro) ✅
- As chaves secretas estão apenas no `.env` local ✅

## 📝 **Se Precisar Recriar:**

Execute este comando na pasta `backend/`:

```powershell
@"
MONGODB_URI=mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge?retryWrites=true&w=majority
PORT=3000
NODE_ENV=development
STRIPE_SECRET_KEY=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
MERCADOPAGO_ACCESS_TOKEN=APP_USR-962011830720089-111415-bcffcdf3b9ab0b8982cd406d845391f0-2991374520
MERCADOPAGO_PUBLIC_KEY=APP_USR-d766e8e8-fa64-4265-b19a-5295dc6a0a7f
"@ | Out-File -FilePath .env -Encoding utf8
```

---

**✅ Pronto! Agora você pode testar tudo!**

