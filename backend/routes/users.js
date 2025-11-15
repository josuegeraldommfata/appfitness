// User Routes
const express = require('express');
const router = express.Router();
const User = require('../models/User');
const Meal = require('../models/Meal');

// Get all users (admin only)
router.get('/', async (req, res) => {
  try {
    const users = await User.find({}).sort({ createdAt: -1 });
    res.json(users);
  } catch (error) {
    console.error('Error getting users:', error);
    res.status(500).json({
      error: 'Failed to get users',
      message: error.message,
    });
  }
});

// Get user count (admin only)
router.get('/stats/count', async (req, res) => {
  try {
    const count = await User.countDocuments({});
    res.json({ count });
  } catch (error) {
    console.error('Error getting user count:', error);
    res.status(500).json({
      error: 'Failed to get user count',
      message: error.message,
    });
  }
});

// Get active users count (admin only)
router.get('/stats/active', async (req, res) => {
  try {
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
    
    // Count users who have logged in within the last 30 days
    // Note: This requires lastLogin field in Auth model
    const count = await User.countDocuments({
      updatedAt: { $gte: thirtyDaysAgo },
    });
    
    res.json({ count });
  } catch (error) {
    console.error('Error getting active users count:', error);
    res.status(500).json({
      error: 'Failed to get active users count',
      message: error.message,
    });
  }
});

// Get total meals today (admin only)
router.get('/stats/meals-today', async (req, res) => {
  try {
    const todayStart = new Date();
    todayStart.setHours(0, 0, 0, 0);
    const todayEnd = new Date();
    todayEnd.setHours(23, 59, 59, 999);
    
    const count = await Meal.countDocuments({
      dateTime: { $gte: todayStart, $lte: todayEnd },
    });
    
    res.json({ count });
  } catch (error) {
    console.error('Error getting total meals today:', error);
    res.status(500).json({
      error: 'Failed to get total meals today',
      message: error.message,
    });
  }
});

// Get user by ID
router.get('/:userId', async (req, res) => {
  try {
    const { userId } = req.params;
    const user = await User.findOne({ id: userId });

    if (!user) {
      return res.status(404).json({
        error: 'User not found',
      });
    }

    res.json(user);
  } catch (error) {
    console.error('Error getting user:', error);
    res.status(500).json({
      error: 'Failed to get user',
      message: error.message,
    });
  }
});

// Create or update user
router.post('/', async (req, res) => {
  try {
    const userData = req.body;
    const user = await User.findOneAndUpdate(
      { id: userData.id },
      userData,
      { new: true, upsert: true, setDefaultsOnInsert: true }
    );

    res.json(user);
  } catch (error) {
    console.error('Error creating/updating user:', error);
    res.status(500).json({
      error: 'Failed to create/update user',
      message: error.message,
    });
  }
});

// Update user
router.put('/:userId', async (req, res) => {
  try {
    const { userId } = req.params;
    const userData = req.body;
    const user = await User.findOneAndUpdate(
      { id: userId },
      { ...userData, updatedAt: new Date() },
      { new: true }
    );

    if (!user) {
      return res.status(404).json({
        error: 'User not found',
      });
    }

    res.json(user);
  } catch (error) {
    console.error('Error updating user:', error);
    res.status(500).json({
      error: 'Failed to update user',
      message: error.message,
    });
  }
});

// Delete user (admin only)
router.delete('/:userId', async (req, res) => {
  try {
    const { userId } = req.params;
    
    // Delete user
    await User.findOneAndDelete({ id: userId });
    
    // Delete user's meals
    await Meal.deleteMany({ userId });
    
    // TODO: Delete user's body metrics, water intake, subscriptions, etc.
    
    res.json({ success: true });
  } catch (error) {
    console.error('Error deleting user:', error);
    res.status(500).json({
      error: 'Failed to delete user',
      message: error.message,
    });
  }
});

// Update user role (admin only)
router.put('/:userId/role', async (req, res) => {
  try {
    const { userId } = req.params;
    const { role } = req.body;
    
    const user = await User.findOneAndUpdate(
      { id: userId },
      { role, updatedAt: new Date() },
      { new: true }
    );

    if (!user) {
      return res.status(404).json({
        error: 'User not found',
      });
    }

    res.json(user);
  } catch (error) {
    console.error('Error updating user role:', error);
    res.status(500).json({
      error: 'Failed to update user role',
      message: error.message,
    });
  }
});

module.exports = router;

