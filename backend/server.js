// Backend Server for NUDGE App
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const bodyParser = require('body-parser');
require('dotenv').config();

// Backend APENAS para: Pagamentos (Stripe/Mercado Pago) e ChatGPT
const stripeRoutes = require('./routes/stripe');
const mercadoPagoRoutes = require('./routes/mercadoPago');
const chatgptRoutes = require('./routes/chatgpt');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(helmet()); // Security headers

// CORS - Configurar para produção
// Em desenvolvimento, permite todas as origens
// Em produção, permite mobile apps e origens específicas
app.use(cors({
  origin: function (origin, callback) {
    // Permitir requisições sem origin (mobile apps, Postman, curl, etc.)
    // Mobile apps não enviam origin header, então sempre permitir
    if (!origin) return callback(null, true);
    
    // Em desenvolvimento, permitir tudo
    if (process.env.NODE_ENV !== 'production') {
      return callback(null, true);
    }
    
    // Em produção, permitir origens específicas se necessário
    // Para mobile apps, sempre permitir (sem origin header)
    callback(null, true);
  },
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));

app.use(morgan('dev')); // Logging
app.use(bodyParser.json()); // Parse JSON bodies
app.use(bodyParser.urlencoded({ extended: true })); // Parse URL-encoded bodies

// Routes
app.get('/', (req, res) => {
  res.json({
    message: 'NUDGE Backend API',
    version: '1.0.0',
    status: 'running',
  });
});

app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
  });
});

// API Routes - APENAS Pagamentos e ChatGPT
app.use('/api/stripe', stripeRoutes);
app.use('/api/mercado-pago', mercadoPagoRoutes);
app.use('/api/chatgpt', chatgptRoutes);

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('Error:', err);
  res.status(err.status || 500).json({
    error: {
      message: err.message || 'Internal Server Error',
      status: err.status || 500,
    },
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    error: {
      message: 'Route not found',
      status: 404,
    },
  });
});

// Start server
const startServer = async () => {
  try {
    // Backend não precisa de MongoDB - apenas para pagamentos e ChatGPT
    // Firebase é usado no app para autenticação e dados

    // Start server
    // Listen on 0.0.0.0 to accept connections from any IP (needed for Railway, Render, etc.)
    app.listen(PORT, '0.0.0.0', () => {
      console.log(`🚀 Backend running on port ${PORT}`);
      console.log(`📍 Environment: ${process.env.NODE_ENV || 'development'}`);
      console.log(`💳 Routes: Stripe, Mercado Pago, ChatGPT`);
      const apiUrl = process.env.RAILWAY_PUBLIC_DOMAIN 
        ? `https://${process.env.RAILWAY_PUBLIC_DOMAIN}`
        : `http://localhost:${PORT}`;
      console.log(`🌐 API URL: ${apiUrl}`);
    });
  } catch (error) {
    console.error('❌ Failed to start server:', error);
    process.exit(1);
  }
};

startServer();

module.exports = app;

