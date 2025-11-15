// Body Metrics Routes
const express = require('express');
const router = express.Router();
const BodyMetrics = require('../models/BodyMetrics');

// IMPORTANT: Order matters! Specific routes must come before parameterized routes

// Get all body metrics for a user
router.get('/user/:userId', async (req, res) => {
  try {
    const { userId } = req.params;
    const { limit = 100, skip = 0 } = req.query;

    const metrics = await BodyMetrics.find({ userId })
      .sort({ date: -1 })
      .limit(parseInt(limit))
      .skip(parseInt(skip));

    // Convert to JSON and add id field
    const metricsJson = metrics.map(metric => {
      const metricObj = metric.toObject();
      delete metricObj._id;
      delete metricObj.__v;
      metricObj['id'] = metric._id.toString();
      return metricObj;
    });

    res.json(metricsJson);
  } catch (error) {
    console.error('Error getting body metrics:', error);
    res.status(500).json({
      error: 'Failed to get body metrics',
      message: error.message,
    });
  }
});

// Get body metrics by ID (must come after user routes)
router.get('/id/:metricId', async (req, res) => {
  try {
    const { metricId } = req.params;
    const metric = await BodyMetrics.findById(metricId);

    if (!metric) {
      return res.status(404).json({
        error: 'Body metric not found',
      });
    }

    // Convert to JSON and add id field
    const metricJson = metric.toObject();
    delete metricJson._id;
    delete metricJson.__v;
    metricJson['id'] = metric._id.toString();

    res.json(metricJson);
  } catch (error) {
    console.error('Error getting body metric:', error);
    res.status(500).json({
      error: 'Failed to get body metric',
      message: error.message,
    });
  }
});

// Create body metrics
router.post('/', async (req, res) => {
  try {
    const metricsData = req.body;

    // Remove id if present
    if (metricsData.id) {
      delete metricsData.id;
    }

    const metrics = new BodyMetrics(metricsData);
    await metrics.save();

    // Convert to JSON and add id field
    const metricsJson = metrics.toObject();
    delete metricsJson._id;
    delete metricsJson.__v;
    metricsJson['id'] = metrics._id.toString();

    res.status(201).json(metricsJson);
  } catch (error) {
    console.error('Error creating body metrics:', error);
    res.status(500).json({
      error: 'Failed to create body metrics',
      message: error.message,
    });
  }
});

// Update body metrics
router.put('/id/:metricId', async (req, res) => {
  try {
    const { metricId } = req.params;
    const metricsData = req.body;

    // Remove id if present
    if (metricsData.id) {
      delete metricsData.id;
    }

    const metrics = await BodyMetrics.findByIdAndUpdate(
      metricId,
      { ...metricsData, updatedAt: new Date() },
      { new: true }
    );

    if (!metrics) {
      return res.status(404).json({
        error: 'Body metric not found',
      });
    }

    // Convert to JSON and add id field
    const metricsJson = metrics.toObject();
    delete metricsJson._id;
    delete metricsJson.__v;
    metricsJson['id'] = metrics._id.toString();

    res.json(metricsJson);
  } catch (error) {
    console.error('Error updating body metrics:', error);
    res.status(500).json({
      error: 'Failed to update body metrics',
      message: error.message,
    });
  }
});

// Delete body metrics
router.delete('/id/:metricId', async (req, res) => {
  try {
    const { metricId } = req.params;
    const metrics = await BodyMetrics.findByIdAndDelete(metricId);

    if (!metrics) {
      return res.status(404).json({
        error: 'Body metric not found',
      });
    }

    res.json({ success: true, message: 'Body metrics deleted successfully' });
  } catch (error) {
    console.error('Error deleting body metrics:', error);
    res.status(500).json({
      error: 'Failed to delete body metrics',
      message: error.message,
    });
  }
});

module.exports = router;

