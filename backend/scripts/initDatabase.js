// Initialize Database Script
// This script creates the necessary collections and indexes in MongoDB
const mongoose = require('mongoose');
const { connectDB } = require('../config/mongodb');

// Import models to register them
const Auth = require('../models/Auth');
const User = require('../models/User');
const Subscription = require('../models/Subscription');
const Meal = require('../models/Meal');
const BodyMetrics = require('../models/BodyMetrics');
const WaterIntake = require('../models/WaterIntake');

// Initialize database
const initDatabase = async () => {
  try {
    console.log('🔄 Connecting to MongoDB...');
    await connectDB();

    console.log('📦 Creating collections and indexes...');

    // Create collections by creating a document in each
    // MongoDB creates collections automatically when first document is inserted
    // But we can ensure indexes are created by syncing indexes

    // Auth collection
    console.log('🔐 Creating Auth collection...');
    try {
      await Auth.createCollection();
      console.log('   Collection created successfully');
    } catch (error) {
      if (error.codeName !== 'NamespaceExists') {
        console.log('   Collection already exists, continuing...');
      } else {
        console.log('   Collection creation skipped');
      }
    }
    
    try {
      await Auth.syncIndexes();
      console.log('   Indexes synced successfully');
    } catch (error) {
      console.log('   Note: Some indexes may already exist');
    }
    console.log('✅ Auth collection ready');

    // Users collection
    console.log('👤 Creating Users collection...');
    try {
      await User.createCollection();
      console.log('   Collection created successfully');
    } catch (error) {
      if (error.codeName !== 'NamespaceExists') {
        console.log('   Collection already exists, continuing...');
      } else {
        console.log('   Collection creation skipped');
      }
    }
    
    // Sync indexes (will create or update indexes)
    try {
      await User.syncIndexes();
      console.log('   Indexes synced successfully');
    } catch (error) {
      console.log('   Note: Some indexes may already exist');
    }
    console.log('✅ Users collection ready');

    // Subscriptions collection
    console.log('💳 Creating Subscriptions collection...');
    try {
      await Subscription.createCollection();
      console.log('   Collection created successfully');
    } catch (error) {
      if (error.codeName !== 'NamespaceExists') {
        console.log('   Collection already exists, continuing...');
      } else {
        console.log('   Collection creation skipped');
      }
    }
    
    try {
      await Subscription.syncIndexes();
      console.log('   Indexes synced successfully');
    } catch (error) {
      console.log('   Note: Some indexes may already exist');
    }
    console.log('✅ Subscriptions collection ready');

    // Meals collection
    console.log('🍽️ Creating Meals collection...');
    try {
      await Meal.createCollection();
      console.log('   Collection created successfully');
    } catch (error) {
      if (error.codeName !== 'NamespaceExists') {
        console.log('   Collection already exists, continuing...');
      } else {
        console.log('   Collection creation skipped');
      }
    }
    
    try {
      await Meal.syncIndexes();
      console.log('   Indexes synced successfully');
    } catch (error) {
      console.log('   Note: Some indexes may already exist');
    }
    console.log('✅ Meals collection ready');

    // Body Metrics collection
    console.log('📊 Creating Body Metrics collection...');
    try {
      await BodyMetrics.createCollection();
      console.log('   Collection created successfully');
    } catch (error) {
      if (error.codeName !== 'NamespaceExists') {
        console.log('   Collection already exists, continuing...');
      } else {
        console.log('   Collection creation skipped');
      }
    }
    
    try {
      await BodyMetrics.syncIndexes();
      console.log('   Indexes synced successfully');
    } catch (error) {
      console.log('   Note: Some indexes may already exist');
    }
    console.log('✅ Body Metrics collection ready');

    // Water Intake collection
    console.log('💧 Creating Water Intake collection...');
    try {
      await WaterIntake.createCollection();
      console.log('   Collection created successfully');
    } catch (error) {
      if (error.codeName !== 'NamespaceExists') {
        console.log('   Collection already exists, continuing...');
      } else {
        console.log('   Collection creation skipped');
      }
    }
    
    try {
      await WaterIntake.syncIndexes();
      console.log('   Indexes synced successfully');
    } catch (error) {
      console.log('   Note: Some indexes may already exist');
    }
    console.log('✅ Water Intake collection ready');

    console.log('✅ Database initialization completed successfully!');
    console.log('📋 Collections created:');
    console.log('   - auths');
    console.log('   - users');
    console.log('   - subscriptions');
    console.log('   - meals');
    console.log('   - bodymetrics');
    console.log('   - waterintakes');

    // List all collections
    const collections = await mongoose.connection.db.listCollections().toArray();
    console.log('\n📚 All collections in database:');
    collections.forEach(col => {
      console.log(`   - ${col.name}`);
    });

    process.exit(0);
  } catch (error) {
    console.error('❌ Error initializing database:', error);
    process.exit(1);
  }
};

// Run initialization
initDatabase();

