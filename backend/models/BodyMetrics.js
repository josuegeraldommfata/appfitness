// Body Metrics Model
const mongoose = require('mongoose');
const { Schema } = mongoose;

const bodyMetricsSchema = new Schema({
  userId: {
    type: String,
    required: true,
    index: true,
  },
  date: {
    type: Date,
    required: true,
    index: true,
  },
  weight: {
    type: Number,
    required: true,
  },
  bodyFat: {
    type: Number,
    default: null,
  },
  muscleMass: {
    type: Number,
    default: null,
  },
  notes: {
    type: String,
    default: null,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
  updatedAt: {
    type: Date,
    default: Date.now,
  },
}, {
  timestamps: true,
});

// Indexes
bodyMetricsSchema.index({ userId: 1, date: -1 });
bodyMetricsSchema.index({ userId: 1, date: 1 });

const BodyMetrics = mongoose.model('BodyMetrics', bodyMetricsSchema);

module.exports = BodyMetrics;

