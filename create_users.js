const admin = require('firebase-admin');

// Initialize Firebase Admin SDK
const serviceAccount = require('./firebase-service-account.json'); // You'll need to download this from Firebase Console

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'https://nudge-88445-default-rtdb.firebaseio.com',
  projectId: 'nudge-88445'
});

const auth = admin.auth();
const db = admin.firestore();

// Test users data
const demoUsers = [
  {
    email: 'admin@test.com',
    password: 'admin123',
    displayName: 'Admin Test',
    role: 'admin',
    profileData: {
      id: 'admin-test-001',
      name: 'Admin Test',
      email: 'admin@test.com',
      photoUrl: null,
      birthDate: new Date('1990-01-01'),
      height: 175.0,
      weight: 75.0,
      bodyType: 'mesomorfo',
      goal: 'manutenção',
      targetWeight: 75.0,
      dailyCalorieGoal: 2000,
      macroGoals: {
        protein: 150.0,
        carbs: 200.0,
        fat: 65.0
      },
      role: 'admin',
      herbalifeId: null,
      currentPlan: 'free'
    }
  },
  {
    email: 'user@test.com',
    password: 'user123',
    displayName: 'User Test',
    role: 'user',
    profileData: {
      id: 'user-test-001',
      name: 'User Test',
      email: 'user@test.com',
      photoUrl: null,
      birthDate: new Date('1995-05-15'),
      height: 170.0,
      weight: 70.0,
      bodyType: 'ectomorfo',
      goal: 'perda de peso',
      targetWeight: 65.0,
      dailyCalorieGoal: 1800,
      macroGoals: {
        protein: 120.0,
        carbs: 180.0,
        fat: 50.0
      },
      role: 'user',
      herbalifeId: null,
      currentPlan: 'free'
    }
  }
];

async function createDemoUsers() {
  try {
    console.log('🔄 Creating test users in Firebase Auth and Firestore...\n');

    for (const userData of demoUsers) {
      try {
        console.log(`👤 Creating user: ${userData.email}`);

        // Check if user already exists
        let userRecord;
        try {
          userRecord = await auth.getUserByEmail(userData.email);
          console.log(`   ⚠️  User ${userData.email} already exists in Firebase Auth`);
          console.log(`   📧 UID: ${userRecord.uid}`);
        } catch (error) {
          if (error.code === 'auth/user-not-found') {
            // Create user in Firebase Auth
            userRecord = await auth.createUser({
              email: userData.email,
              password: userData.password,
              displayName: userData.displayName,
              emailVerified: true
            });
            console.log(`   ✅ User created in Firebase Auth`);
            console.log(`   📧 UID: ${userRecord.uid}`);
          } else {
            throw error;
          }
        }

        // Update user profile data in Firestore
        const userDoc = {
          ...userData.profileData,
          id: userRecord.uid, // Use Firebase UID as ID
          role: userData.role,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
          updatedAt: admin.firestore.FieldValue.serverTimestamp()
        };

        await db.collection('users').doc(userRecord.uid).set(userDoc, { merge: true });
        console.log(`   ✅ Profile data added/updated in Firestore`);
        console.log(`   📋 Role: ${userData.role}`);
        console.log(`   📦 Plan: ${userData.profileData.currentPlan}`);
        console.log('');
      } catch (error) {
        console.error(`   ❌ Error creating user ${userData.email}:`, error.message);
      }
    }

    console.log('✅ All test users created successfully!');
    console.log('\n📋 Test Users:');
    console.log('   1. Admin: admin@test.com (Password: admin123)');
    console.log('   2. User: user@test.com (Password: user123)');
    console.log('\n⚠️  Note: Users also need to be added to MongoDB for backend API');
    console.log('   Run: npm run create-test-users (in backend folder)');
  } catch (error) {
    console.error('❌ Error creating test users:', error);
  } finally {
    try {
      admin.app().delete();
    } catch (error) {
      // Ignore if already deleted
    }
  }
}

createDemoUsers();
