// ChatGPT Route - Backend para processar mensagens do ChatGPT
const express = require('express');
const router = express.Router();
const axios = require('axios');

// ChatGPT Configuration
// Usando modelo gratuito/barato: gpt-3.5-turbo (muito mais barato que gpt-4o-mini)
// Alternativa: Se não tiver chave OpenAI, pode usar Hugging Face ou Groq (gratuito)
const OPENAI_API_KEY = process.env.OPENAI_API_KEY;
const OPENAI_API_URL = 'https://api.openai.com/v1/chat/completions';
const MODEL = 'gpt-3.5-turbo'; // Modelo mais barato (quase gratuito com créditos iniciais)

// System prompt para o assistente fitness
const SYSTEM_PROMPT = 'You are a helpful fitness coach for the NUDGE app. Provide personalized advice on diet, exercise, water intake, and progress tracking. Keep responses concise, encouraging, and in Portuguese.';

// POST /api/chatgpt/message - Enviar mensagem para ChatGPT
router.post('/message', async (req, res) => {
  try {
    const { message } = req.body;

    if (!message) {
      return res.status(400).json({
        error: 'Message is required',
      });
    }

    if (!OPENAI_API_KEY) {
      return res.status(500).json({
        error: 'OpenAI API key not configured',
      });
    }

    // Chamar API do OpenAI
    const response = await axios.post(
      OPENAI_API_URL,
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
          'Authorization': `Bearer ${OPENAI_API_KEY}`,
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
      res.status(500).json({
        error: 'Invalid response from OpenAI',
      });
    }
  } catch (error) {
    console.error('ChatGPT error:', error.response?.data || error.message);
    res.status(500).json({
      error: 'Failed to get response from ChatGPT',
      message: error.response?.data?.error?.message || error.message,
    });
  }
});

module.exports = router;

