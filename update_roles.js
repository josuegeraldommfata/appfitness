const admin = require('firebase-admin');
const serviceAccount = require('./firebase-service-account.json');

// Initialize Firebase Admin
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: 'nudge-88445',
});

const auth = admin.auth();
const db = admin.firestore();

// Function to update user role
async function updateUserRole(email, role) {
  try {
    const user = await auth.getUserByEmail(email);
    await db.collection('users').doc(user.uid).set({
      role: role,
      lastLogin: admin.firestore.FieldValue.serverTimestamp(),
    }, { merge: true });
    console.log(`Role updated for ${email} to ${role}`);
  } catch (error) {
    if (error.code === 'auth/user-not-found') {
      console.log(`User ${email} not found`);
    } else {
      console.error(`Error updating role for ${email}:`, error);
    }
  }
}

// Update roles
updateUserRole('demo_user@email.com', 'user');
updateUserRole('demo_admin@email.com', 'admin');

console.log('Role updates completed.');
