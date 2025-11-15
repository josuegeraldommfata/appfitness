// Create Test Users Script
// This script creates test users in MongoDB with authentication
const mongoose = require('mongoose');
const crypto = require('crypto');
const { connectDB } = require('../config/mongodb');
const Auth = require('../models/Auth');
const User = require('../models/User');

// Test users data
const testUsers = [
  {
    email: 'admin@test.com',
    password: 'admin123',
    name: 'Admin Test',
    birthDate: new Date('1990-01-01'),
    height: 175,
    weight: 75,
    bodyType: 'mesomorfo',
    goal: 'manutenção',
    targetWeight: 75,
    dailyCalorieGoal: 2000,
    macroGoals: {
      protein: 150,
      carbs: 200,
      fat: 65,
    },
    role: 'admin',
    herbalifeId: null,
    currentPlan: 'free',
  },
  {
    email: 'user@test.com',
    password: 'user123',
    name: 'User Test',
    birthDate: new Date('1995-05-15'),
    height: 170,
    weight: 70,
    bodyType: 'ectomorfo',
    goal: 'perda de peso',
    targetWeight: 65,
    dailyCalorieGoal: 1800,
    macroGoals: {
      protein: 120,
      carbs: 180,
      fat: 50,
    },
    role: 'user',
    herbalifeId: null,
    currentPlan: 'free',
  },
];

// Hash password
const hashPassword = (password) => {
  return crypto.createHash('sha256').update(password).digest('hex');
};

// Create test users
const createTestUsers = async () => {
  try {
    console.log('🔄 Connecting to MongoDB...');
    await connectDB();

    console.log('👥 Creating test users in MongoDB...\n');

    for (const userData of testUsers) {
      try {
        // Check if user already exists
        const existingAuth = await Auth.findOne({ email: userData.email.toLowerCase() });
        const existingUser = await User.findOne({ email: userData.email.toLowerCase() });

        if (existingAuth && existingUser) {
          console.log(`⚠️  User ${userData.email} already exists, updating...`);
          
          // Update auth
          existingAuth.passwordHash = hashPassword(userData.password);
          existingAuth.updatedAt = new Date();
          await existingAuth.save();
          
          // Update user
          await User.findOneAndUpdate(
            { email: userData.email.toLowerCase() },
            {
              ...userData,
              email: userData.email.toLowerCase(),
              updatedAt: new Date(),
            },
            { new: true }
          );
          
          console.log(`✅ User ${userData.email} updated successfully`);
        } else {
          // Create user ID
          const userId = new mongoose.Types.ObjectId().toString();

          // Create auth record
          const auth = new Auth({
            userId,
            email: userData.email.toLowerCase(),
            passwordHash: hashPassword(userData.password),
          });
          await auth.save();

          // Create user profile
          const user = new User({
            id: userId,
            name: userData.name,
            email: userData.email.toLowerCase(),
            birthDate: userData.birthDate,
            height: userData.height,
            weight: userData.weight,
            bodyType: userData.bodyType,
            goal: userData.goal,
            targetWeight: userData.targetWeight,
            dailyCalorieGoal: userData.dailyCalorieGoal,
            macroGoals: userData.macroGoals,
            role: userData.role,
            herbalifeId: userData.herbalifeId,
            currentPlan: userData.currentPlan,
          });
          await user.save();

          console.log(`✅ User ${userData.email} created successfully`);
        }

        // Display user info
        const user = await User.findOne({ email: userData.email.toLowerCase() });
        const auth = await Auth.findOne({ email: userData.email.toLowerCase() });
        
        console.log(`   📧 Email: ${userData.email}`);
        console.log(`   👤 Name: ${userData.name}`);
        console.log(`   🔑 Role: ${userData.role}`);
        console.log(`   📦 Plan: ${userData.currentPlan}`);
        console.log(`   🔢 ID: ${user?.id || auth?.userId}`);
        console.log(`   🔐 Password: ${userData.password}`);
        console.log('');
      } catch (error) {
        console.error(`❌ Error creating user ${userData.email}:`, error.message);
        if (error.code === 11000) {
          console.log(`   ⚠️  Duplicate key error - user may already exist`);
        }
      }
    }

    console.log('✅ Test users creation completed!');
    console.log('\n📋 Test Users Created:');
    console.log('   1. Admin: admin@test.com (Password: admin123)');
    console.log('   2. User: user@test.com (Password: user123)');
    console.log('\n✅ Users are ready to use!');
    console.log('   - Authentication is handled by MongoDB');
    console.log('   - No Firebase Auth needed');
    console.log('   - Login via API: POST /api/auth/login');

    // List all users
    const allUsers = await User.find({}).sort({ createdAt: -1 });
    const allAuths = await Auth.find({}).sort({ createdAt: -1 });
    
    console.log(`\n📊 Total users in MongoDB: ${allUsers.length}`);
    console.log(`📊 Total auth records: ${allAuths.length}`);
    
    allUsers.forEach((user, index) => {
      const auth = allAuths.find(a => a.userId === user.id);
      console.log(`   ${index + 1}. ${user.email} (${user.role}) - Plan: ${user.currentPlan} - ID: ${user.id.substring(0, 20)}...`);
    });

    process.exit(0);
  } catch (error) {
    console.error('❌ Error creating test users:', error);
    process.exit(1);
  }
};

// Run script
createTestUsers();
