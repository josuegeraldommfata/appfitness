// Create Demo Users Script
// This script creates demo users with the emails demoadmin@email.com and demouser@email.com
const mongoose = require('mongoose');
const crypto = require('crypto');
const { connectDB } = require('../config/mongodb');
const Auth = require('../models/Auth');
const User = require('../models/User');

// Demo users data
const demoUsers = [
  {
    email: 'demoadmin@email.com',
    password: 'admin123', // Same password as admin@test.com for consistency
    name: 'Demo Admin',
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
    email: 'demouser@email.com',
    password: 'user123', // Same password as user@test.com for consistency
    name: 'Demo User',
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

// Create demo users
const createDemoUsers = async () => {
  try {
    console.log('🔄 Connecting to MongoDB...');
    await connectDB();

    console.log('👥 Creating demo users in MongoDB...\n');

    for (const userData of demoUsers) {
      try {
        // Check if user already exists
        const existingAuth = await Auth.findOne({ email: userData.email.toLowerCase() });
        const existingUser = await User.findOne({ email: userData.email.toLowerCase() });

        if (existingAuth && existingUser) {
          console.log(`⚠️  User ${userData.email} already exists, updating password...`);
          
          // Update auth password
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

    console.log('✅ Demo users creation completed!');
    console.log('\n📋 Demo Users Created:');
    console.log('   1. Admin: demoadmin@email.com (Password: admin123)');
    console.log('   2. User: demouser@email.com (Password: user123)');
    console.log('\n✅ Users are ready to use!');

    process.exit(0);
  } catch (error) {
    console.error('❌ Error creating demo users:', error);
    process.exit(1);
  }
};

// Run script
createDemoUsers();

