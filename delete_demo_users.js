const admin = require('firebase-admin');
const serviceAccount = require('./firebase-service-account.json');

// Initialize Firebase Admin
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: 'nudge-88445',
});

const auth = admin.auth();
const db = admin.firestore();

async function deleteUser(email) {
  try {
    const user = await auth.getUserByEmail(email);
    await auth.deleteUser(user.uid);
    await db.collection('users').doc(user.uid).delete();
    console.log(`Deleted user: ${email}`);
  } catch (error) {
    if (error.code === 'auth/user-not-found') {
      console.log(`User ${email} not found`);
    } else {
      console.error(`Error deleting ${email}:`, error);
    }
  }
}

// Delete old demo users
deleteUser('demo_user@email.com');
deleteUser('demo_admin@email.com');
deleteUser('user@email.com');
deleteUser('admin@email.com');

console.log('Demo users deletion completed.');
