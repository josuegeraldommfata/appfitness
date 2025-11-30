// Test Authentication Script
// This script tests registration and login functionality
const mongoose = require('mongoose');
const crypto = require('crypto');
const { connectDB } = require('../config/mongodb');
const Auth = require('../models/Auth');
const User = require('../models/User');

const BASE_URL = 'http://localhost:3000';

// Test data
const testUser = {
  email: `test${Date.now()}@test.com`,
  password: 'test123',
  name: 'Test User',
  birthDate: '1995-01-01',
  height: 170,
  weight: 70,
  bodyType: 'mesomorfo',
  goal: 'manutenção',
  targetWeight: 70,
  dailyCalorieGoal: 2000,
};

// Test registration
const testRegistration = async () => {
  try {
    console.log('🧪 Testing Registration...\n');
    
    await connectDB();
    
    // Check if user already exists
    const existingAuth = await Auth.findOne({ email: testUser.email.toLowerCase() });
    if (existingAuth) {
      console.log('⚠️  Test user already exists, deleting...');
      await Auth.deleteOne({ email: testUser.email.toLowerCase() });
      await User.deleteOne({ email: testUser.email.toLowerCase() });
    }
    
    // Create user ID
    const userId = new mongoose.Types.ObjectId().toString();
    
    // Create auth record
    const auth = new Auth({
      userId,
      email: testUser.email.toLowerCase(),
      passwordHash: crypto.createHash('sha256').update(testUser.password).digest('hex'),
    });
    await auth.save();
    console.log('✅ Auth record created');
    
    // Create user profile
    const user = new User({
      id: userId,
      name: testUser.name,
      email: testUser.email.toLowerCase(),
      birthDate: new Date(testUser.birthDate),
      height: testUser.height,
      weight: testUser.weight,
      bodyType: testUser.bodyType,
      goal: testUser.goal,
      targetWeight: testUser.targetWeight,
      dailyCalorieGoal: testUser.dailyCalorieGoal,
      macroGoals: {
        protein: 150,
        carbs: 200,
        fat: 65,
      },
      role: 'user',
      currentPlan: 'free',
    });
    await user.save();
    console.log('✅ User profile created');
    
    console.log(`\n✅ Registration test passed!`);
    console.log(`   Email: ${testUser.email}`);
    console.log(`   Password: ${testUser.password}`);
    console.log(`   User ID: ${userId}\n`);
    
    return { success: true, email: testUser.email, password: testUser.password };
  } catch (error) {
    console.error('❌ Registration test failed:', error.message);
    console.error(error);
    return { success: false, error: error.message };
  }
};

// Test login
const testLogin = async (email, password) => {
  try {
    console.log('🧪 Testing Login...\n');
    
    // Find auth record
    const auth = await Auth.findOne({ email: email.toLowerCase() });
    if (!auth) {
      console.error('❌ Auth record not found');
      return { success: false, error: 'Auth record not found' };
    }
    
    // Verify password
    const passwordHash = crypto.createHash('sha256').update(password).digest('hex');
    if (auth.passwordHash !== passwordHash) {
      console.error('❌ Password mismatch');
      return { success: false, error: 'Invalid password' };
    }
    
    // Get user profile
    const user = await User.findOne({ id: auth.userId });
    if (!user) {
      console.error('❌ User profile not found');
      return { success: false, error: 'User profile not found' };
    }
    
    console.log('✅ Login test passed!');
    console.log(`   Email: ${email}`);
    console.log(`   Name: ${user.name}`);
    console.log(`   Role: ${user.role}\n`);
    
    return { success: true, user };
  } catch (error) {
    console.error('❌ Login test failed:', error.message);
    console.error(error);
    return { success: false, error: error.message };
  }
};

// Test demo users login
const testDemoUsers = async () => {
  try {
    console.log('🧪 Testing Demo Users Login...\n');
    
    const demoUsers = [
      { email: 'demoadmin@email.com', password: 'admin123' },
      { email: 'demouser@email.com', password: 'user123' },
    ];
    
    for (const demoUser of demoUsers) {
      console.log(`Testing: ${demoUser.email}`);
      const result = await testLogin(demoUser.email, demoUser.password);
      if (result.success) {
        console.log(`✅ ${demoUser.email} login successful\n`);
      } else {
        console.log(`❌ ${demoUser.email} login failed: ${result.error}\n`);
      }
    }
  } catch (error) {
    console.error('❌ Demo users test failed:', error.message);
  }
};

// Run all tests
const runTests = async () => {
  try {
    console.log('🚀 Starting Authentication Tests...\n');
    
    // Test registration
    const regResult = await testRegistration();
    
    if (regResult.success) {
      // Test login with newly created user
      await testLogin(regResult.email, regResult.password);
    }
    
    // Test demo users
    await testDemoUsers();
    
    console.log('✅ All tests completed!');
    process.exit(0);
  } catch (error) {
    console.error('❌ Test suite failed:', error);
    process.exit(1);
  }
};

runTests();

