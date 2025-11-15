// Mercado Pago Routes
const express = require('express');
const router = express.Router();
const { MercadoPagoConfig, Preference, Payment } = require('mercadopago');

// Configure Mercado Pago - New SDK v2.x
let mercadoPagoClient = null;
let preferenceClient = null;
let paymentClient = null;

// Initialize Mercado Pago clients (only if access token is provided)
if (process.env.MERCADOPAGO_ACCESS_TOKEN) {
  try {
    mercadoPagoClient = new MercadoPagoConfig({
      accessToken: process.env.MERCADOPAGO_ACCESS_TOKEN,
      options: { timeout: 5000 },
    });
    preferenceClient = new Preference(mercadoPagoClient);
    paymentClient = new Payment(mercadoPagoClient);
  } catch (error) {
    console.warn('⚠️  Mercado Pago não configurado:', error.message);
  }
}

// Create Preference
router.post('/create-preference', async (req, res) => {
  try {
    // Check if Mercado Pago is configured
    if (!preferenceClient) {
      return res.status(503).json({
        error: 'Mercado Pago não está configurado',
        message: 'MERCADOPAGO_ACCESS_TOKEN não foi definido',
      });
    }

    const { amount, userId, planType, billingPeriod } = req.body;

    if (!amount || !userId || !planType || !billingPeriod) {
      return res.status(400).json({
        error: 'Missing required fields: amount, userId, planType, billingPeriod',
      });
    }

    // Create preference body - New SDK v2.x format
    const body = {
      items: [
        {
          title: `Plano ${planType} - ${billingPeriod}`,
          quantity: 1,
          unit_price: parseFloat(amount),
          currency_id: 'BRL',
        },
      ],
      payer: {
        email: userId, // You should get user email from database
      },
      metadata: {
        userId: userId,
        planType: planType,
        billingPeriod: billingPeriod,
      },
      back_urls: {
        success: process.env.MERCADOPAGO_SUCCESS_URL || 'https://your-app.com/success',
        failure: process.env.MERCADOPAGO_FAILURE_URL || 'https://your-app.com/failure',
        pending: process.env.MERCADOPAGO_PENDING_URL || 'https://your-app.com/pending',
      },
      auto_return: 'approved',
    };

    const response = await preferenceClient.create({ body });

    res.json({
      preferenceId: response.id,
      initPoint: response.init_point,
      sandboxInitPoint: response.sandbox_init_point,
    });
  } catch (error) {
    console.error('Error creating Mercado Pago preference:', error);
    res.status(500).json({
      error: 'Failed to create Mercado Pago preference',
      message: error.message,
    });
  }
});

// Verify Payment
router.get('/verify-payment', async (req, res) => {
  try {
    // Check if Mercado Pago is configured
    if (!paymentClient) {
      return res.status(503).json({
        error: 'Mercado Pago não está configurado',
        message: 'MERCADOPAGO_ACCESS_TOKEN não foi definido',
      });
    }

    const { payment_id } = req.query;

    if (!payment_id) {
      return res.status(400).json({
        error: 'Missing required field: payment_id',
      });
    }

    // Get payment information - New SDK v2.x format
    const payment = await paymentClient.get({ id: payment_id });

    res.json({
      paymentId: payment.id,
      status: payment.status,
      statusDetail: payment.status_detail,
      transactionAmount: payment.transaction_amount,
      currencyId: payment.currency_id,
    });
  } catch (error) {
    console.error('Error verifying Mercado Pago payment:', error);
    res.status(500).json({
      error: 'Failed to verify Mercado Pago payment',
      message: error.message,
    });
  }
});

// Webhook handler for Mercado Pago events
router.post('/webhook', async (req, res) => {
  try {
    // Check if Mercado Pago is configured
    if (!paymentClient) {
      console.warn('⚠️  Mercado Pago webhook recebido mas não está configurado');
      return res.json({ received: true });
    }

    const { type, data } = req.body;

    if (type === 'payment') {
      const paymentId = data.id;
      console.log('Payment webhook received:', paymentId);

      try {
        // Get payment information - New SDK v2.x format
        const payment = await paymentClient.get({ id: paymentId });

        // Update subscription status in database based on payment status
        if (payment.status === 'approved') {
          console.log('Payment approved:', paymentId);
          // Update subscription status to active
        } else if (payment.status === 'rejected') {
          console.log('Payment rejected:', paymentId);
          // Update subscription status to failed
        }
      } catch (error) {
        console.error('Error getting payment in webhook:', error);
      }
    }

    res.json({ received: true });
  } catch (error) {
    console.error('Error handling Mercado Pago webhook:', error);
    res.status(500).json({
      error: 'Failed to handle webhook',
      message: error.message,
    });
  }
});

module.exports = router;

