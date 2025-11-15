// User Model
const mongoose = require('mongoose');
const { Schema } = mongoose;

const userSchema = new Schema({
  id: {
    type: String,
    required: true,
  },
  name: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
    lowercase: true,
    trim: true,
  },
  photoUrl: {
    type: String,
    default: null,
  },
  birthDate: {
    type: Date,
    required: true,
  },
  height: {
    type: Number,
    required: true,
  },
  weight: {
    type: Number,
    required: true,
  },
  bodyType: {
    type: String,
    enum: ['ectomorfo', 'mesomorfo', 'endomorfo'],
    required: true,
  },
  goal: {
    type: String,
    enum: ['perda de peso', 'ganho muscular', 'manutenção'],
    required: true,
  },
  targetWeight: {
    type: Number,
    required: true,
  },
  dailyCalorieGoal: {
    type: Number,
    required: true,
  },
  macroGoals: {
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
  role: {
    type: String,
    enum: ['user', 'admin'],
    default: 'user',
  },
  herbalifeId: {
    type: String,
    default: null,
  },
  currentPlan: {
    type: String,
    enum: ['free', 'fit', 'personal', 'personalPlus', 'leader'],
    default: 'free',
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
userSchema.index({ email: 1 }, { unique: true });
userSchema.index({ id: 1 }, { unique: true });
userSchema.index({ currentPlan: 1 });

const User = mongoose.model('User', userSchema);

module.exports = User;

