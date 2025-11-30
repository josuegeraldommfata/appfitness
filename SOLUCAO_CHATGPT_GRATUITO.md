# 💬 Solução ChatGPT Gratuito para Apresentação

## 🎯 **Problema:**
O cliente não pagou assinatura da OpenAI, então precisamos usar uma alternativa gratuita.

## ✅ **Soluções Disponíveis:**

### **Opção 1: Usar gpt-3.5-turbo (Quase Gratuito)** ⭐ RECOMENDADO
- **Custo:** Muito barato (quase gratuito com créditos iniciais da OpenAI)
- **Qualidade:** Boa para conversas simples
- **Configuração:** Já implementado! ✅
- **Como funciona:**
  - OpenAI dá $5 de crédito grátis na primeira conta
  - gpt-3.5-turbo custa ~$0.0015 por 1K tokens
  - Com $5 você pode fazer ~3.3 milhões de tokens (muitas conversas!)

**Status:** ✅ Já configurado no código (mudei de `gpt-4o-mini` para `gpt-3.5-turbo`)

### **Opção 2: Groq API (100% Gratuito)** 🆓
- **Custo:** TOTALMENTE GRATUITO
- **Qualidade:** Excelente (usa modelos Llama 3)
- **Limite:** 30 requisições/minuto (suficiente para demo)
- **Configuração:** Precisa criar conta e pegar API key

**Como configurar:**
1. Acesse: https://console.groq.com
2. Crie conta gratuita
3. Gere API key
4. Adicione no `.env`: `GROQ_API_KEY=sua_chave_aqui`
5. Atualize `backend/routes/chatgpt.js` para usar Groq

### **Opção 3: Hugging Face (Gratuito com Limites)**
- **Custo:** Gratuito (com limites)
- **Qualidade:** Boa
- **Configuração:** Mais complexa

### **Opção 4: Respostas Pré-definidas (100% Gratuito)**
- **Custo:** ZERO
- **Qualidade:** Limitada (respostas fixas)
- **Configuração:** Simples

---

## 🚀 **RECOMENDAÇÃO PARA APRESENTAÇÃO:**

### **Use gpt-3.5-turbo (Opção 1)** ⭐

**Por quê?**
- ✅ Já está implementado no código
- ✅ Muito barato (quase gratuito)
- ✅ Qualidade boa para demo
- ✅ Funciona imediatamente

**O que fazer:**
1. Criar conta OpenAI (se não tiver): https://platform.openai.com
2. Adicionar método de pagamento (pode ser cartão virtual)
3. OpenAI dá $5 de crédito grátis
4. Usar esses créditos para a apresentação
5. Custo real: ~$0.01 por apresentação (muito barato!)

**Configuração:**
- ✅ Já mudei o modelo para `gpt-3.5-turbo` no código
- ✅ Só precisa adicionar `OPENAI_API_KEY` no `.env` do backend

---

## 📝 **Passo a Passo Rápido:**

### 1. Criar Conta OpenAI (5 min)
1. Acesse: https://platform.openai.com/signup
2. Crie conta
3. Adicione método de pagamento (pode ser cartão virtual)
4. Vá em: https://platform.openai.com/api-keys
5. Crie uma API key
6. Copie a chave

### 2. Configurar Backend (2 min)
1. Abra `backend/.env`
2. Adicione:
   ```
   OPENAI_API_KEY=sk-sua-chave-aqui
   ```
3. Salve

### 3. Testar (1 min)
1. Rode o backend: `cd backend && npm start`
2. Teste o chat no app
3. ✅ Funcionando!

---

## 💡 **Alternativa: Groq (100% Gratuito)**

Se quiser algo 100% gratuito sem precisar de cartão:

### Configurar Groq:

1. **Criar conta:** https://console.groq.com
2. **Gerar API key**
3. **Atualizar `backend/routes/chatgpt.js`:**

```javascript
// Groq Configuration (100% GRATUITO)
const GROQ_API_KEY = process.env.GROQ_API_KEY;
const GROQ_API_URL = 'https://api.groq.com/openai/v1/chat/completions';
const MODEL = 'llama-3.1-70b-versatile'; // Modelo gratuito do Groq

// POST /api/chatgpt/message
router.post('/message', async (req, res) => {
  try {
    const { message } = req.body;

    if (!message) {
      return res.status(400).json({ error: 'Message is required' });
    }

    if (!GROQ_API_KEY) {
      return res.status(500).json({ error: 'Groq API key not configured' });
    }

    // Chamar API do Groq (GRATUITO)
    const response = await axios.post(
      GROQ_API_URL,
      {
        model: MODEL,
        messages: [
          { role: 'system', content: SYSTEM_PROMPT },
          { role: 'user', content: message },
        ],
        max_tokens: 300,
        temperature: 0.7,
      },
      {
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${GROQ_API_KEY}`,
        },
      }
    );

    if (response.data && response.data.choices && response.data.choices.length > 0) {
      const aiResponse = response.data.choices[0].message.content;
      
      res.json({
        success: true,
        response: aiResponse,
      });
    } else {
      res.status(500).json({ error: 'Invalid response from Groq' });
    }
  } catch (error) {
    console.error('Groq error:', error.response?.data || error.message);
    res.status(500).json({
      error: 'Failed to get response from Groq',
      message: error.response?.data?.error?.message || error.message,
    });
  }
});
```

4. **Adicionar no `.env`:**
   ```
   GROQ_API_KEY=sua_chave_groq_aqui
   ```

---

## ✅ **Resumo:**

### Para Apresentação HOJE:
- ✅ **Use gpt-3.5-turbo** (já configurado)
- ✅ Crie conta OpenAI (5 min)
- ✅ Adicione API key no `.env`
- ✅ Custo: ~$0.01 por apresentação

### Se Quiser 100% Gratuito:
- ✅ **Use Groq** (precisa atualizar código)
- ✅ Crie conta Groq (gratuita)
- ✅ Adicione API key
- ✅ Custo: $0 (totalmente gratuito)

---

## 🎯 **Recomendação Final:**

**Para apresentar HOJE:** Use gpt-3.5-turbo (já está configurado, só precisa da API key)

**Para produção depois:** Avalie Groq se quiser economizar, ou continue com gpt-3.5-turbo que é muito barato.

