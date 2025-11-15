// Auth Model for storing authentication tokens
const mongoose = require('mongoose');
const { Schema } = mongoose;
const crypto = require('crypto');

const authSchema = new Schema({
  userId: {
    type: String,
    required: true,
    unique: true,
  },
  email: {
    type: String,
    required: true,
    unique: true,
  },
  passwordHash: {
    type: String,
    required: true,
  },
  tokens: [{
    token: {
      type: String,
      required: true,
    },
    createdAt: {
      type: Date,
      default: Date.now,
    },
    expiresAt: {
      type: Date,
      required: true,
    },
  }],
  lastLogin: {
    type: Date,
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
authSchema.index({ userId: 1 });
authSchema.index({ email: 1 });
authSchema.index({ 'tokens.token': 1 });

// Hash password
authSchema.methods.hashPassword = function(password) {
  // Simple hash - in production, use bcrypt
  return crypto.createHash('sha256').update(password).digest('hex');
};

// Verify password
authSchema.methods.verifyPassword = function(password) {
  const hash = this.hashPassword(password);
  return this.passwordHash === hash;
};

// Generate token
authSchema.methods.generateToken = function() {
  return crypto.randomBytes(32).toString('hex');
};

// Add token
authSchema.methods.addToken = function(token, expiresInDays = 30) {
  const expiresAt = new Date();
  expiresAt.setDate(expiresAt.getDate() + expiresInDays);
  
  this.tokens.push({
    token,
    expiresAt,
  });
  
  // Remove expired tokens
  this.tokens = this.tokens.filter(t => t.expiresAt > new Date());
  
  return this.save();
};

// Remove token
authSchema.methods.removeToken = function(token) {
  this.tokens = this.tokens.filter(t => t.token !== token);
  return this.save();
};

// Remove expired tokens
authSchema.methods.removeExpiredTokens = function() {
  this.tokens = this.tokens.filter(t => t.expiresAt > new Date());
  return this.save();
};

const Auth = mongoose.model('Auth', authSchema);

module.exports = Auth;

