// Meal Model
const mongoose = require('mongoose');
const { Schema } = mongoose;

const mealSchema = new Schema({
  userId: {
    type: String,
    required: true,
    index: true,
  },
  dateTime: {
    type: Date,
    required: true,
    index: true,
  },
  type: {
    type: String,
    enum: ['Café da Manhã', 'Almoço', 'Jantar', 'Lanche'],
    required: true,
  },
  foods: [{
    name: {
      type: String,
      required: true,
    },
    quantity: {
      type: Number,
      required: true,
    },
    unit: {
      type: String,
      default: 'g',
    },
    calories: {
      type: Number,
      required: true,
    },
    protein: {
      type: Number,
      default: 0,
    },
    carbs: {
      type: Number,
      default: 0,
    },
    fat: {
      type: Number,
      default: 0,
    },
  }],
  totalCalories: {
    type: Number,
    default: 0,
  },
  totalMacros: {
    protein: {
      type: Number,
      default: 0,
    },
    carbs: {
      type: Number,
      default: 0,
    },
    fat: {
      type: Number,
      default: 0,
    },
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
mealSchema.index({ userId: 1, dateTime: -1 });
mealSchema.index({ userId: 1, dateTime: 1 });

const Meal = mongoose.model('Meal', mealSchema);

module.exports = Meal;

