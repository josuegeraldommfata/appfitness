// Stripe Routes
const express = require('express');
const router = express.Router();
const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);

// Create Payment Intent
router.post('/create-payment-intent', async (req, res) => {
  try {
    const { amount, currency, userId, planType, billingPeriod } = req.body;

    if (!amount || !currency || !userId || !planType || !billingPeriod) {
      return res.status(400).json({
        error: 'Missing required fields: amount, currency, userId, planType, billingPeriod',
      });
    }

    // Create payment intent
    // amount vem em reais do frontend (ex: 19.90), converter para centavos
    const amountInCents = Math.round(amount * 100);
    
    const paymentIntent = await stripe.paymentIntents.create({
      amount: amountInCents,
      currency: currency.toLowerCase(),
      metadata: {
        userId: userId,
        planType: planType,
        billingPeriod: billingPeriod,
      },
      automatic_payment_methods: {
        enabled: true,
      },
    });

    res.json({
      clientSecret: paymentIntent.client_secret,
      paymentIntentId: paymentIntent.id,
    });
  } catch (error) {
    console.error('Error creating payment intent:', error);
    res.status(500).json({
      error: 'Failed to create payment intent',
      message: error.message,
    });
  }
});

// Create Subscription
router.post('/create-subscription', async (req, res) => {
  try {
    const { customerId, priceId, userId, planType, billingPeriod } = req.body;

    if (!customerId || !priceId || !userId || !planType || !billingPeriod) {
      return res.status(400).json({
        error: 'Missing required fields: customerId, priceId, userId, planType, billingPeriod',
      });
    }

    // Create or get customer
    let customer;
    try {
      customer = await stripe.customers.retrieve(customerId);
    } catch (error) {
      // Customer doesn't exist, create new one
      customer = await stripe.customers.create({
        id: customerId,
        metadata: {
          userId: userId,
        },
      });
    }

    // Create subscription
    const subscription = await stripe.subscriptions.create({
      customer: customer.id,
      items: [{ price: priceId }],
      metadata: {
        userId: userId,
        planType: planType,
        billingPeriod: billingPeriod,
      },
    });

    res.json({
      subscriptionId: subscription.id,
      status: subscription.status,
      customerId: subscription.customer,
      currentPeriodStart: subscription.current_period_start,
      currentPeriodEnd: subscription.current_period_end,
    });
  } catch (error) {
    console.error('Error creating subscription:', error);
    res.status(500).json({
      error: 'Failed to create subscription',
      message: error.message,
    });
  }
});

// Process Payment with Card Details
router.post('/process-payment', async (req, res) => {
  try {
    const { paymentIntentId, clientSecret, cardNumber, expiryDate, cvc, cardName } = req.body;

    if (!paymentIntentId || !clientSecret || !cardNumber || !expiryDate || !cvc) {
      return res.status(400).json({
        error: 'Missing required fields: paymentIntentId, clientSecret, cardNumber, expiryDate, cvc',
      });
    }

    // Parse expiry date (MM/YY format)
    const [month, year] = expiryDate.split('/');
    const expMonth = parseInt(month, 10);
    const expYear = parseInt('20' + year, 10);

    // Create payment method
    const paymentMethod = await stripe.paymentMethods.create({
      type: 'card',
      card: {
        number: cardNumber.replace(/\s/g, ''),
        exp_month: expMonth,
        exp_year: expYear,
        cvc: cvc,
      },
      billing_details: {
        name: cardName || 'Cardholder',
      },
    });

    // Confirm payment intent with payment method
    const paymentIntent = await stripe.paymentIntents.confirm(paymentIntentId, {
      payment_method: paymentMethod.id,
    });

    if (paymentIntent.status === 'succeeded') {
      res.json({
        success: true,
        paymentIntentId: paymentIntent.id,
        status: paymentIntent.status,
      });
    } else {
      res.status(400).json({
        success: false,
        error: `Payment status: ${paymentIntent.status}`,
        paymentIntentId: paymentIntent.id,
      });
    }
  } catch (error) {
    console.error('Error processing payment:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to process payment',
      message: error.message,
    });
  }
});

// Webhook handler for Stripe events
router.post('/webhook', express.raw({ type: 'application/json' }), async (req, res) => {
  const sig = req.headers['stripe-signature'];
  const webhookSecret = process.env.STRIPE_WEBHOOK_SECRET;

  let event;

  try {
    event = stripe.webhooks.constructEvent(req.body, sig, webhookSecret);
  } catch (err) {
    console.error('Webhook signature verification failed:', err.message);
    return res.status(400).send(`Webhook Error: ${err.message}`);
  }

  // Handle the event
  switch (event.type) {
    case 'payment_intent.succeeded':
      const paymentIntent = event.data.object;
      console.log('PaymentIntent succeeded:', paymentIntent.id);
      // Update subscription status in database
      break;

    case 'customer.subscription.created':
      const subscriptionCreated = event.data.object;
      console.log('Subscription created:', subscriptionCreated.id);
      // Create subscription record in database
      break;

    case 'customer.subscription.updated':
      const subscriptionUpdated = event.data.object;
      console.log('Subscription updated:', subscriptionUpdated.id);
      // Update subscription record in database
      break;

    case 'customer.subscription.deleted':
      const subscriptionDeleted = event.data.object;
      console.log('Subscription deleted:', subscriptionDeleted.id);
      // Cancel subscription in database
      break;

    default:
      console.log(`Unhandled event type ${event.type}`);
  }

  res.json({ received: true });
});

module.exports = router;

