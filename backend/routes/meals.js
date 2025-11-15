// Meals Routes
const express = require('express');
const router = express.Router();
const Meal = require('../models/Meal');

// IMPORTANT: Order matters! Specific routes must come before parameterized routes

// Get meals for a specific date
router.get('/user/:userId/date/:date', async (req, res) => {
  try {
    const { userId, date } = req.params;
    const dateObj = new Date(date);
    const startDate = new Date(dateObj.setHours(0, 0, 0, 0));
    const endDate = new Date(dateObj.setHours(23, 59, 59, 999));

    const meals = await Meal.find({
      userId,
      dateTime: {
        $gte: startDate,
        $lte: endDate,
      },
    }).sort({ dateTime: 1 });

    // Convert to JSON and add id field
    const mealsJson = meals.map(meal => {
      const mealObj = meal.toObject();
      delete mealObj._id;
      delete mealObj.__v;
      mealObj['id'] = meal._id.toString();
      return mealObj;
    });

    res.json(mealsJson);
  } catch (error) {
    console.error('Error getting meals:', error);
    res.status(500).json({
      error: 'Failed to get meals',
      message: error.message,
    });
  }
});

// Get all meals for a user
router.get('/user/:userId', async (req, res) => {
  try {
    const { userId } = req.params;
    const { limit = 100, skip = 0 } = req.query;

    const meals = await Meal.find({ userId })
      .sort({ dateTime: -1 })
      .limit(parseInt(limit))
      .skip(parseInt(skip));

    // Convert to JSON and add id field
    const mealsJson = meals.map(meal => {
      const mealObj = meal.toObject();
      delete mealObj._id;
      delete mealObj.__v;
      mealObj['id'] = meal._id.toString();
      return mealObj;
    });

    res.json(mealsJson);
  } catch (error) {
    console.error('Error getting meals:', error);
    res.status(500).json({
      error: 'Failed to get meals',
      message: error.message,
    });
  }
});

// Create meal
router.post('/', async (req, res) => {
  try {
    const mealData = req.body;

    // Remove id if present (MongoDB will generate _id)
    if (mealData.id) {
      delete mealData.id;
    }

    // Calculate totals if not provided
    if (!mealData.totalCalories || !mealData.totalMacros) {
      mealData.totalCalories = mealData.foods?.reduce((sum, food) => sum + (food.calories || 0), 0) || 0;
      mealData.totalMacros = {
        protein: mealData.foods?.reduce((sum, food) => sum + (food.protein || 0), 0) || 0,
        carbs: mealData.foods?.reduce((sum, food) => sum + (food.carbs || 0), 0) || 0,
        fat: mealData.foods?.reduce((sum, food) => sum + (food.fat || 0), 0) || 0,
      };
    }

    const meal = new Meal(mealData);
    await meal.save();

    // Convert to JSON and add id field
    const mealJson = meal.toObject();
    delete mealJson._id;
    delete mealJson.__v;
    mealJson['id'] = meal._id.toString();

    res.status(201).json(mealJson);
  } catch (error) {
    console.error('Error creating meal:', error);
    res.status(500).json({
      error: 'Failed to create meal',
      message: error.message,
    });
  }
});

// Update meal
router.put('/id/:mealId', async (req, res) => {
  try {
    const { mealId } = req.params;
    const mealData = req.body;

    // Calculate totals if foods changed
    if (mealData.foods) {
      mealData.totalCalories = mealData.foods.reduce((sum, food) => sum + (food.calories || 0), 0);
      mealData.totalMacros = {
        protein: mealData.foods.reduce((sum, food) => sum + (food.protein || 0), 0),
        carbs: mealData.foods.reduce((sum, food) => sum + (food.carbs || 0), 0),
        fat: mealData.foods.reduce((sum, food) => sum + (food.fat || 0), 0),
      };
    }

    const meal = await Meal.findByIdAndUpdate(
      mealId,
      { ...mealData, updatedAt: new Date() },
      { new: true }
    );

    if (!meal) {
      return res.status(404).json({
        error: 'Meal not found',
      });
    }

    // Convert to JSON and remove Mongoose internals
    const mealJson = meal.toObject();
    delete mealJson._id;
    delete mealJson.__v;
    mealJson['id'] = meal._id.toString();

    res.json(mealJson);
  } catch (error) {
    console.error('Error updating meal:', error);
    res.status(500).json({
      error: 'Failed to update meal',
      message: error.message,
    });
  }
});

// Delete meal
router.delete('/id/:mealId', async (req, res) => {
  try {
    const { mealId } = req.params;
    const meal = await Meal.findByIdAndDelete(mealId);

    if (!meal) {
      return res.status(404).json({
        error: 'Meal not found',
      });
    }

    res.json({ success: true, message: 'Meal deleted successfully' });
  } catch (error) {
    console.error('Error deleting meal:', error);
    res.status(500).json({
      error: 'Failed to delete meal',
      message: error.message,
    });
  }
});

// Get meal by ID (must come after user routes to avoid conflicts)
router.get('/id/:mealId', async (req, res) => {
  try {
    const { mealId } = req.params;
    const meal = await Meal.findById(mealId);

    if (!meal) {
      return res.status(404).json({
        error: 'Meal not found',
      });
    }

    // Convert to JSON and remove Mongoose internals
    const mealJson = meal.toObject();
    delete mealJson._id;
    delete mealJson.__v;
    mealJson['id'] = meal._id.toString();

    res.json(mealJson);
  } catch (error) {
    console.error('Error getting meal:', error);
    res.status(500).json({
      error: 'Failed to get meal',
      message: error.message,
    });
  }
});

module.exports = router;

