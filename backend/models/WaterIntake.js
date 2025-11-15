// Water Intake Model
const mongoose = require('mongoose');
const { Schema } = mongoose;

const waterIntakeSchema = new Schema({
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
  amount: {
    type: Number,
    required: true,
    default: 0,
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
waterIntakeSchema.index({ userId: 1, date: -1 });
waterIntakeSchema.index({ userId: 1, date: 1 }, { unique: true });

const WaterIntake = mongoose.model('WaterIntake', waterIntakeSchema);

module.exports = WaterIntake;

