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

// Demo users data
const demoUsers = [
  {
    email: 'user@email.com',
    password: 'user123',
    displayName: 'Usuário Teste',
    role: 'user',
    profileData: {
      name: 'Usuário Teste',
      email: 'user@email.com',
      birthDate: new Date('1990-01-01'),
      height: 170.0,
      weight: 70.0,
      bodyType: 'Mesomorfo',
      goal: 'Perda de Peso',
      targetWeight: 65.0,
      dailyCalorieGoal: 1800,
      macroGoals: {
        protein: 120.0,
        carbs: 180.0,
        fat: 60.0
      }
    }
  },
  {
    email: 'admin@email.com',
    password: 'admin123',
    displayName: 'Admin Teste',
    role: 'admin',
    profileData: {
      name: 'Admin Teste',
      email: 'admin@email.com',
      birthDate: new Date('1985-05-15'),
      height: 175.0,
      weight: 75.0,
      bodyType: 'Ectomorfo',
      goal: 'Ganho de Massa',
      targetWeight: 80.0,
      dailyCalorieGoal: 2500,
      macroGoals: {
        protein: 200.0,
        carbs: 250.0,
        fat: 83.0
      }
    }
  }
];

async function createDemoUsers() {
  try {
    for (const userData of demoUsers) {
      console.log(`Creating user: ${userData.email}`);

      // Create user in Firebase Auth
      const userRecord = await auth.createUser({
        email: userData.email,
        password: userData.password,
        displayName: userData.displayName,
        emailVerified: true
      });

      console.log(`User created with UID: ${userRecord.uid}`);

      // Add user profile data to Firestore
      await db.collection('users').doc(userRecord.uid).set({
        ...userData.profileData,
        uid: userRecord.uid,
        role: userData.role,
        createdAt: admin.firestore.FieldValue.serverTimestamp()
      });

      console.log(`Profile data added for user: ${userData.email}`);
    }

    console.log('All demo users created successfully!');
  } catch (error) {
    console.error('Error creating demo users:', error);
  } finally {
    admin.app().delete();
  }
}

createDemoUsers();
