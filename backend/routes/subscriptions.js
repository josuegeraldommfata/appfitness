// Subscription Routes
const express = require('express');
const router = express.Router();
const Subscription = require('../models/Subscription');

// Get user subscriptions
router.get('/user/:userId', async (req, res) => {
  try {
    const { userId } = req.params;
    const subscriptions = await Subscription.find({ userId })
      .sort({ createdAt: -1 });

    res.json(subscriptions);
  } catch (error) {
    console.error('Error getting subscriptions:', error);
    res.status(500).json({
      error: 'Failed to get subscriptions',
      message: error.message,
    });
  }
});

// Get active subscription
router.get('/user/:userId/active', async (req, res) => {
  try {
    const { userId } = req.params;
    const subscription = await Subscription.findOne({
      userId,
      status: 'active',
    }).sort({ createdAt: -1 });

    if (!subscription) {
      return res.status(404).json({
        error: 'No active subscription found',
      });
    }

    res.json(subscription);
  } catch (error) {
    console.error('Error getting active subscription:', error);
    res.status(500).json({
      error: 'Failed to get active subscription',
      message: error.message,
    });
  }
});

// Create subscription
router.post('/', async (req, res) => {
  try {
    const subscriptionData = req.body;
    const subscription = new Subscription(subscriptionData);
    await subscription.save();

    res.json(subscription);
  } catch (error) {
    console.error('Error creating subscription:', error);
    res.status(500).json({
      error: 'Failed to create subscription',
      message: error.message,
    });
  }
});

// Update subscription
router.put('/:subscriptionId', async (req, res) => {
  try {
    const { subscriptionId } = req.params;
    const subscriptionData = req.body;
    const subscription = await Subscription.findOneAndUpdate(
      { id: subscriptionId },
      { ...subscriptionData, updatedAt: new Date() },
      { new: true }
    );

    if (!subscription) {
      return res.status(404).json({
        error: 'Subscription not found',
      });
    }

    res.json(subscription);
  } catch (error) {
    console.error('Error updating subscription:', error);
    res.status(500).json({
      error: 'Failed to update subscription',
      message: error.message,
    });
  }
});

// Cancel subscription
router.delete('/:subscriptionId', async (req, res) => {
  try {
    const { subscriptionId } = req.params;
    const subscription = await Subscription.findOneAndUpdate(
      { id: subscriptionId },
      { status: 'cancelled', updatedAt: new Date() },
      { new: true }
    );

    if (!subscription) {
      return res.status(404).json({
        error: 'Subscription not found',
      });
    }

    res.json(subscription);
  } catch (error) {
    console.error('Error cancelling subscription:', error);
    res.status(500).json({
      error: 'Failed to cancel subscription',
      message: error.message,
    });
  }
});

module.exports = router;

