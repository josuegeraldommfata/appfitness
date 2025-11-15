// Subscription Model
const mongoose = require('mongoose');
const { Schema } = mongoose;

const subscriptionSchema = new Schema({
  id: {
    type: String,
    required: true,
    unique: true,
  },
  userId: {
    type: String,
    required: true,
    index: true,
  },
  planType: {
    type: String,
    enum: ['free', 'fit', 'personal', 'personalPlus', 'leader'],
    required: true,
  },
  status: {
    type: String,
    enum: ['active', 'cancelled', 'expired', 'trial', 'pending'],
    default: 'pending',
  },
  startDate: {
    type: Date,
    required: true,
  },
  endDate: {
    type: Date,
    default: null,
  },
  nextBillingDate: {
    type: Date,
    default: null,
  },
  billingPeriod: {
    type: String,
    enum: ['monthly', 'yearly'],
    required: true,
  },
  paymentProvider: {
    type: String,
    enum: ['stripe', 'mercadoPago', 'none'],
    default: 'none',
  },
  paymentId: {
    type: String,
    default: null,
  },
  transactionId: {
    type: String,
    default: null,
  },
  amount: {
    type: Number,
    required: true,
  },
  herbalifeId: {
    type: String,
    default: null,
  },
  isLeaderPlan: {
    type: Boolean,
    default: false,
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
subscriptionSchema.index({ userId: 1, status: 1 });
subscriptionSchema.index({ userId: 1, createdAt: -1 });
subscriptionSchema.index({ paymentId: 1 });
subscriptionSchema.index({ transactionId: 1 });

const Subscription = mongoose.model('Subscription', subscriptionSchema);

module.exports = Subscription;

