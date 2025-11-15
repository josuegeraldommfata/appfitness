// Sync Firebase Users Script
// This script syncs Firebase Auth users with MongoDB
// Use this after creating users in Firebase Auth to update MongoDB with Firebase UIDs
const mongoose = require('mongoose');
const { connectDB } = require('../config/mongodb');
const User = require('../models/User');

// User emails to sync
const usersToSync = [
  {
    email: 'admin@test.com',
    // The script will look up the Firebase UID from Firestore or you can provide it
    // If you have the Firebase UID, add it here: firebaseUid: 'actual-firebase-uid'
  },
  {
    email: 'user@test.com',
    // firebaseUid: 'actual-firebase-uid'
  },
];

// Sync users
const syncFirebaseUsers = async () => {
  try {
    console.log('🔄 Connecting to MongoDB...');
    await connectDB();

    console.log('🔄 Syncing Firebase users with MongoDB...\n');

    for (const userInfo of usersToSync) {
      try {
        // Find user in MongoDB by email
        const mongoUser = await User.findOne({ email: userInfo.email });

        if (!mongoUser) {
          console.log(`⚠️  User ${userInfo.email} not found in MongoDB`);
          console.log('   Please create the user first using: npm run create-test-users');
          continue;
        }

        // If Firebase UID is provided, update it
        if (userInfo.firebaseUid) {
          console.log(`🔄 Updating user ${userInfo.email} with Firebase UID: ${userInfo.firebaseUid}`);
          mongoUser.id = userInfo.firebaseUid;
          await mongoUser.save();
          console.log(`✅ User ${userInfo.email} updated with Firebase UID`);
        } else {
          console.log(`📋 User ${userInfo.email} found in MongoDB`);
          console.log(`   Current ID: ${mongoUser.id}`);
          console.log(`   ⚠️  Firebase UID not provided - user needs to be created in Firebase Auth first`);
          console.log(`   📝 To update with Firebase UID:`);
          console.log(`      1. Create user in Firebase Auth`);
          console.log(`      2. Get the Firebase UID`);
          console.log(`      3. Update this script with the Firebase UID`);
          console.log(`      4. Run this script again`);
        }

        console.log(`   📧 Email: ${mongoUser.email}`);
        console.log(`   👤 Name: ${mongoUser.name}`);
        console.log(`   🔑 Role: ${mongoUser.role}`);
        console.log(`   📦 Plan: ${mongoUser.currentPlan}`);
        console.log('');
      } catch (error) {
        console.error(`❌ Error syncing user ${userInfo.email}:`, error.message);
      }
    }

    console.log('✅ User sync completed!');
    console.log('\n📋 Instructions:');
    console.log('   1. Create users in Firebase Auth (use Firebase Console or create_users.js)');
    console.log('   2. Get the Firebase UIDs from Firebase Console');
    console.log('   3. Update the usersToSync array in this script with the Firebase UIDs');
    console.log('   4. Run this script again to sync the UIDs');

    process.exit(0);
  } catch (error) {
    console.error('❌ Error syncing users:', error);
    process.exit(1);
  }
};

// Run script
syncFirebaseUsers();

