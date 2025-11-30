# 🔧 Configurar ChatGPT no Backend

## ⚠️ **Problema:**
O ChatGPT está dando erro porque a chave API não está configurada.

**Erro:**
```
Incorrect API key provided: YOUR_OPENAI_API_KEY_HERE
```

## ✅ **Solução:**

### 1. Obter Chave API da OpenAI

1. Acesse: https://platform.openai.com/account/api-keys
2. Faça login na sua conta OpenAI
3. Clique em "Create new secret key"
4. Copie a chave (ela começa com `sk-`)

### 2. Configurar no Backend

Edite o arquivo `backend/.env` e adicione:

```env
OPENAI_API_KEY=sk-sua-chave-aqui
```

**Exemplo:**
```env
OPENAI_API_KEY=sk-proj-abc123def456ghi789jkl012mno345pqr678stu901vwx234yz
```

### 3. Reiniciar Backend

Após configurar, reinicie o backend:

```bash
cd backend
npm start
```

### 4. Testar

Execute o teste:

```bash
cd backend
npm run test-payment-chat
```

Ou teste diretamente:

```bash
curl -X POST http://localhost:3000/api/chatgpt/message \
  -H "Content-Type: application/json" \
  -d '{"message": "Olá, como posso perder peso?"}'
```

---

## 💡 **Nota sobre Pagamento:**

Se a chave API não funcionar, pode ser que:
- A conta OpenAI não tenha créditos
- A chave expirou
- A chave foi revogada

Verifique em: https://platform.openai.com/account/billing

