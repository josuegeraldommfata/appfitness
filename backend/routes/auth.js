// Authentication Routes
const express = require('express');
const router = express.Router();
const crypto = require('crypto');
const Auth = require('../models/Auth');
const User = require('../models/User');
const mongoose = require('mongoose');

// Register
router.post('/register', async (req, res) => {
  try {
    const { email, password, name, birthDate, height, weight, bodyType, goal, targetWeight, dailyCalorieGoal, macroGoals } = req.body;

    if (!email || !password || !name) {
      return res.status(400).json({
        error: 'Missing required fields: email, password, name',
      });
    }

    // Check if user already exists
    const existingAuth = await Auth.findOne({ email: email.toLowerCase() });
    if (existingAuth) {
      return res.status(400).json({
        error: 'User already exists with this email',
      });
    }

    // Create user ID
    const userId = new mongoose.Types.ObjectId().toString();

    // Hash password
    const auth = new Auth({
      userId,
      email: email.toLowerCase(),
      passwordHash: crypto.createHash('sha256').update(password).digest('hex'),
    });

    await auth.save();

    // Create user profile
    const user = new User({
      id: userId,
      name,
      email: email.toLowerCase(),
      birthDate: new Date(birthDate),
      height: height || 170,
      weight: weight || 70,
      bodyType: bodyType || 'mesomorfo',
      goal: goal || 'manutenção',
      targetWeight: targetWeight || 70,
      dailyCalorieGoal: dailyCalorieGoal || 2000,
      macroGoals: macroGoals || {
        protein: 150,
        carbs: 200,
        fat: 65,
      },
      role: 'user',
      currentPlan: 'free',
    });

    await user.save();

    // Generate token
    const token = auth.generateToken();
    await auth.addToken(token, 30); // Token expires in 30 days
    auth.lastLogin = new Date();
    await auth.save();

    res.json({
      success: true,
      token,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        photoUrl: user.photoUrl || null,
        birthDate: user.birthDate.toISOString(),
        height: user.height,
        weight: user.weight,
        bodyType: user.bodyType,
        goal: user.goal,
        targetWeight: user.targetWeight,
        dailyCalorieGoal: user.dailyCalorieGoal,
        macroGoals: user.macroGoals,
        role: user.role,
        herbalifeId: user.herbalifeId || null,
        currentPlan: user.currentPlan,
      },
    });
  } catch (error) {
    console.error('Error registering user:', error);
    res.status(500).json({
      error: 'Failed to register user',
      message: error.message,
    });
  }
});

// Login
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({
        error: 'Missing required fields: email, password',
      });
    }

    // Find auth record
    const auth = await Auth.findOne({ email: email.toLowerCase() });
    if (!auth) {
      return res.status(401).json({
        error: 'Invalid email or password',
      });
    }

    // Verify password
    const passwordHash = crypto.createHash('sha256').update(password).digest('hex');
    if (auth.passwordHash !== passwordHash) {
      return res.status(401).json({
        error: 'Invalid email or password',
      });
    }

    // Get user profile
    const user = await User.findOne({ id: auth.userId });
    if (!user) {
      return res.status(404).json({
        error: 'User profile not found',
      });
    }

    // Generate token
    const token = auth.generateToken();
    await auth.addToken(token, 30); // Token expires in 30 days
    auth.lastLogin = new Date();
    await auth.save();

    res.json({
      success: true,
      token,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        photoUrl: user.photoUrl || null,
        birthDate: user.birthDate.toISOString(),
        height: user.height,
        weight: user.weight,
        bodyType: user.bodyType,
        goal: user.goal,
        targetWeight: user.targetWeight,
        dailyCalorieGoal: user.dailyCalorieGoal,
        macroGoals: user.macroGoals,
        role: user.role,
        herbalifeId: user.herbalifeId || null,
        currentPlan: user.currentPlan,
      },
    });
  } catch (error) {
    console.error('Error logging in:', error);
    res.status(500).json({
      error: 'Failed to login',
      message: error.message,
    });
  }
});

// Logout
router.post('/logout', async (req, res) => {
  try {
    const token = req.headers.authorization?.replace('Bearer ', '');

    if (!token) {
      return res.status(400).json({
        error: 'Token is required',
      });
    }

    // Find auth by token
    const auth = await Auth.findOne({ 'tokens.token': token });
    if (auth) {
      await auth.removeToken(token);
    }

    res.json({
      success: true,
      message: 'Logged out successfully',
    });
  } catch (error) {
    console.error('Error logging out:', error);
    res.status(500).json({
      error: 'Failed to logout',
      message: error.message,
    });
  }
});

// Verify token
router.get('/verify', async (req, res) => {
  try {
    const token = req.headers.authorization?.replace('Bearer ', '');

    if (!token) {
      return res.status(401).json({
        error: 'Token is required',
      });
    }

    // Find auth by token
    const auth = await Auth.findOne({ 'tokens.token': token });
    if (!auth) {
      return res.status(401).json({
        error: 'Invalid token',
      });
    }

    // Check if token is expired
    const tokenData = auth.tokens.find(t => t.token === token);
    if (!tokenData || tokenData.expiresAt < new Date()) {
      return res.status(401).json({
        error: 'Token expired',
      });
    }

    // Get user profile
    const user = await User.findOne({ id: auth.userId });
    if (!user) {
      return res.status(404).json({
        error: 'User profile not found',
      });
    }

    res.json({
      success: true,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        photoUrl: user.photoUrl || null,
        birthDate: user.birthDate.toISOString(),
        height: user.height,
        weight: user.weight,
        bodyType: user.bodyType,
        goal: user.goal,
        targetWeight: user.targetWeight,
        dailyCalorieGoal: user.dailyCalorieGoal,
        macroGoals: user.macroGoals,
        role: user.role,
        herbalifeId: user.herbalifeId || null,
        currentPlan: user.currentPlan,
      },
    });
  } catch (error) {
    console.error('Error verifying token:', error);
    res.status(500).json({
      error: 'Failed to verify token',
      message: error.message,
    });
  }
});

module.exports = router;

