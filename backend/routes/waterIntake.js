// Water Intake Routes
const express = require('express');
const router = express.Router();
const WaterIntake = require('../models/WaterIntake');

// IMPORTANT: Order matters! Specific routes must come before parameterized routes

// Get water intake for a specific date
router.get('/user/:userId/date/:date', async (req, res) => {
  try {
    const { userId, date } = req.params;
    const dateObj = new Date(date);
    const startDate = new Date(dateObj.setHours(0, 0, 0, 0));
    const endDate = new Date(dateObj.setHours(23, 59, 59, 999));

    const intakes = await WaterIntake.find({
      userId,
      date: {
        $gte: startDate,
        $lte: endDate,
      },
    });

    // Sum all amounts for the day
    const totalAmount = intakes.reduce((sum, intake) => sum + (intake.amount || 0), 0);

    // Convert to JSON and add id field
    const intakesJson = intakes.map(intake => {
      const intakeObj = intake.toObject();
      delete intakeObj._id;
      delete intakeObj.__v;
      intakeObj['id'] = intake._id.toString();
      return intakeObj;
    });

    res.json({
      date: date,
      totalAmount: totalAmount,
      intakes: intakesJson,
    });
  } catch (error) {
    console.error('Error getting water intake:', error);
    res.status(500).json({
      error: 'Failed to get water intake',
      message: error.message,
    });
  }
});

// Get water intake for today
router.get('/user/:userId/today', async (req, res) => {
  try {
    const { userId } = req.params;
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);

    const intakes = await WaterIntake.find({
      userId,
      date: {
        $gte: today,
        $lt: tomorrow,
      },
    });

    const totalAmount = intakes.reduce((sum, intake) => sum + (intake.amount || 0), 0);

    // Convert to JSON and add id field
    const intakesJson = intakes.map(intake => {
      const intakeObj = intake.toObject();
      delete intakeObj._id;
      delete intakeObj.__v;
      intakeObj['id'] = intake._id.toString();
      return intakeObj;
    });

    res.json({
      date: today.toISOString(),
      totalAmount: totalAmount,
      intakes: intakesJson,
    });
  } catch (error) {
    console.error('Error getting today water intake:', error);
    res.status(500).json({
      error: 'Failed to get today water intake',
      message: error.message,
    });
  }
});

// Get all water intake for a user
router.get('/user/:userId', async (req, res) => {
  try {
    const { userId } = req.params;
    const { limit = 100, skip = 0 } = req.query;

    const intakes = await WaterIntake.find({ userId })
      .sort({ date: -1 })
      .limit(parseInt(limit))
      .skip(parseInt(skip));

    // Convert to JSON and add id field
    const intakesJson = intakes.map(intake => {
      const intakeObj = intake.toObject();
      delete intakeObj._id;
      delete intakeObj.__v;
      intakeObj['id'] = intake._id.toString();
      return intakeObj;
    });

    res.json(intakesJson);
  } catch (error) {
    console.error('Error getting water intake:', error);
    res.status(500).json({
      error: 'Failed to get water intake',
      message: error.message,
    });
  }
});

// Create water intake
router.post('/', async (req, res) => {
  try {
    const intakeData = req.body;
    
    // Remove id if present
    if (intakeData.id) {
      delete intakeData.id;
    }
    
    // If date is not provided, use today
    if (!intakeData.date) {
      intakeData.date = new Date();
    } else if (typeof intakeData.date === 'string') {
      intakeData.date = new Date(intakeData.date);
    }

    const intake = new WaterIntake(intakeData);
    await intake.save();

    // Convert to JSON and add id field
    const intakeJson = intake.toObject();
    delete intakeJson._id;
    delete intakeJson.__v;
    intakeJson['id'] = intake._id.toString();

    res.status(201).json(intakeJson);
  } catch (error) {
    console.error('Error creating water intake:', error);
    res.status(500).json({
      error: 'Failed to create water intake',
      message: error.message,
    });
  }
});

// Update water intake
router.put('/id/:intakeId', async (req, res) => {
  try {
    const { intakeId } = req.params;
    const intakeData = req.body;

    // Remove id if present
    if (intakeData.id) {
      delete intakeData.id;
    }

    const intake = await WaterIntake.findByIdAndUpdate(
      intakeId,
      { ...intakeData, updatedAt: new Date() },
      { new: true }
    );

    if (!intake) {
      return res.status(404).json({
        error: 'Water intake not found',
      });
    }

    // Convert to JSON and add id field
    const intakeJson = intake.toObject();
    delete intakeJson._id;
    delete intakeJson.__v;
    intakeJson['id'] = intake._id.toString();

    res.json(intakeJson);
  } catch (error) {
    console.error('Error updating water intake:', error);
    res.status(500).json({
      error: 'Failed to update water intake',
      message: error.message,
    });
  }
});

// Delete water intake
router.delete('/id/:intakeId', async (req, res) => {
  try {
    const { intakeId } = req.params;
    const intake = await WaterIntake.findByIdAndDelete(intakeId);

    if (!intake) {
      return res.status(404).json({
        error: 'Water intake not found',
      });
    }

    res.json({ success: true, message: 'Water intake deleted successfully' });
  } catch (error) {
    console.error('Error deleting water intake:', error);
    res.status(500).json({
      error: 'Failed to delete water intake',
      message: error.message,
    });
  }
});

// Reset water intake for today
router.delete('/user/:userId/today', async (req, res) => {
  try {
    const { userId } = req.params;
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);

    const result = await WaterIntake.deleteMany({
      userId,
      date: {
        $gte: today,
        $lt: tomorrow,
      },
    });

    res.json({
      success: true,
      message: 'Water intake reset successfully',
      deletedCount: result.deletedCount,
    });
  } catch (error) {
    console.error('Error resetting water intake:', error);
    res.status(500).json({
      error: 'Failed to reset water intake',
      message: error.message,
    });
  }
});

module.exports = router;

