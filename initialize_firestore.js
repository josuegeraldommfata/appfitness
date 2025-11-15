const admin = require('firebase-admin');

// Initialize Firebase Admin SDK
const serviceAccount = require('./firebase-service-account.json'); // You'll need to download this from Firebase Console

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'https://nudge-88445-default-rtdb.firebaseio.com',
  projectId: 'nudge-88445'
});

// If you don't have the service account key, use the API key from google-services.json for limited access (not recommended for production)
const googleServices = require('./google-services.json');
const apiKey = googleServices.client[0].api_key[0].current_key;

// For admin operations, you still need the service account key. This is just a fallback.

const auth = admin.auth();
const db = admin.firestore();

// Demo users data
const demoUsers = [
  {
    email: 'demouser@email.com',
    password: 'user123',
    displayName: 'Usuário Demo',
    role: 'user',
    profileData: {
      name: 'Usuário Demo',
      email: 'demouser@email.com',
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
    email: 'demoadmin@email.com',
    password: 'admin123',
    displayName: 'Admin Demo',
    role: 'admin',
    profileData: {
      name: 'Admin Demo',
      email: 'demoadmin@email.com',
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

// Sample foods - expanded to ~60 common foods with nutritional data (per typical serving, sourced from USDA/Nutritionix)
const sampleFoods = [
  { name: 'Banana', calories: 105, protein: 1.3, carbs: 27, fat: 0.4, serving: '1 medium' },
  { name: 'Maçã', calories: 95, protein: 0.5, carbs: 25, fat: 0.3, serving: '1 medium' },
  { name: 'Laranja', calories: 62, protein: 1.2, carbs: 15, fat: 0.2, serving: '1 medium' },
  { name: 'Morango', calories: 32, protein: 0.7, carbs: 8, fat: 0.3, serving: '100g' },
  { name: 'Uva', calories: 69, protein: 0.7, carbs: 18, fat: 0.2, serving: '100g' },
  { name: 'Abacate', calories: 160, protein: 2, carbs: 9, fat: 15, serving: '1/2 medium' },
  { name: 'Arroz Branco Cozido', calories: 130, protein: 2.7, carbs: 28, fat: 0.3, serving: '100g' },
  { name: 'Arroz Integral Cozido', calories: 111, protein: 2.6, carbs: 23, fat: 0.9, serving: '100g' },
  { name: 'Pão Integral', calories: 247, protein: 13, carbs: 41, fat: 4.2, serving: '100g' },
  { name: 'Macarrão Cozido', calories: 131, protein: 5.8, carbs: 25, fat: 1.1, serving: '100g' },
  { name: 'Frango Grelhado', calories: 165, protein: 31, carbs: 0, fat: 3.6, serving: '100g' },
  { name: 'Peito de Peru', calories: 135, protein: 29, carbs: 0, fat: 1, serving: '100g' },
  { name: 'Bife de Carne', calories: 250, protein: 26, carbs: 0, fat: 15, serving: '100g' },
  { name: 'Salmão Grelhado', calories: 206, protein: 22, carbs: 0, fat: 13, serving: '100g' },
  { name: 'Atum em Lata', calories: 132, protein: 29, carbs: 0, fat: 1.3, serving: '100g' },
  { name: 'Ovo Cozido', calories: 155, protein: 13, carbs: 1.1, fat: 11, serving: '100g' },
  { name: 'Queijo Cheddar', calories: 402, protein: 25, carbs: 1.3, fat: 33, serving: '100g' },
  { name: 'Iogurte Natural', calories: 61, protein: 3.5, carbs: 4.7, fat: 3.3, serving: '100g' },
  { name: 'Leite Desnatado', calories: 34, protein: 3.4, carbs: 5, fat: 0.1, serving: '100ml' },
  { name: 'Manteiga de Amendoim', calories: 588, protein: 25, carbs: 20, fat: 50, serving: '100g' },
  { name: 'Amêndoas', calories: 579, protein: 21, carbs: 22, fat: 50, serving: '100g' },
  { name: 'Nozes', calories: 654, protein: 15, carbs: 14, fat: 65, serving: '100g' },
  { name: 'Aveia em Flocos', calories: 389, protein: 17, carbs: 66, fat: 7, serving: '100g' },
  { name: 'Batata Doce Assada', calories: 90, protein: 2, carbs: 21, fat: 0.2, serving: '100g' },
  { name: 'Batata Inglesa Cozida', calories: 87, protein: 1.9, carbs: 20, fat: 0.1, serving: '100g' },
  { name: 'Cenoura Crua', calories: 41, protein: 0.9, carbs: 10, fat: 0.2, serving: '100g' },
  { name: 'Brócolis Cozido', calories: 35, protein: 2.4, carbs: 7.2, fat: 0.4, serving: '100g' },
  { name: 'Espinafre', calories: 23, protein: 2.9, carbs: 3.6, fat: 0.4, serving: '100g' },
  { name: 'Tomate', calories: 18, protein: 0.9, carbs: 3.9, fat: 0.2, serving: '100g' },
  { name: 'Alface', calories: 15, protein: 1.4, carbs: 2.9, fat: 0.2, serving: '100g' },
  { name: 'Abobrinha', calories: 17, protein: 1.2, carbs: 3.1, fat: 0.3, serving: '100g' },
  { name: 'Pepino', calories: 16, protein: 0.7, carbs: 3.6, fat: 0.1, serving: '100g' },
  { name: 'Pimentão', calories: 31, protein: 1, carbs: 6, fat: 0.3, serving: '100g' },
  { name: 'Cogumelo', calories: 22, protein: 3.1, carbs: 3.3, fat: 0.3, serving: '100g' },
  { name: 'Feijão Preto Cozido', calories: 132, protein: 8.9, carbs: 23, fat: 0.5, serving: '100g' },
  { name: 'Lentilha Cozida', calories: 116, protein: 9, carbs: 20, fat: 0.4, serving: '100g' },
  { name: 'Quinoa Cozida', calories: 120, protein: 4.4, carbs: 21, fat: 1.9, serving: '100g' },
  { name: 'Cuscuz', calories: 112, protein: 3.8, carbs: 23, fat: 0.2, serving: '100g' },
  { name: 'Pão de Forma', calories: 265, protein: 9, carbs: 49, fat: 3.2, serving: '100g' },
  { name: 'Torrada', calories: 296, protein: 9, carbs: 56, fat: 4, serving: '100g' },
  { name: 'Cereal Matinal', calories: 378, protein: 8.4, carbs: 78, fat: 1.1, serving: '100g' },
  { name: 'Biscoito Integral', calories: 443, protein: 8.3, carbs: 65, fat: 16, serving: '100g' },
  { name: 'Chocolate Amargo', calories: 546, protein: 5.5, carbs: 46, fat: 43, serving: '100g' },
  { name: 'Sorvete', calories: 207, protein: 3.5, carbs: 28, fat: 11, serving: '100g' },
  { name: 'Mel', calories: 304, protein: 0.3, carbs: 82, fat: 0, serving: '100g' },
  { name: 'Açúcar', calories: 387, protein: 0, carbs: 100, fat: 0, serving: '100g' },
  { name: 'Azeite de Oliva', calories: 884, protein: 0, carbs: 0, fat: 100, serving: '100ml' },
  { name: 'Manteiga', calories: 717, protein: 0.9, carbs: 0.1, fat: 81, serving: '100g' },
  { name: 'Queijo Cottage', calories: 98, protein: 11, carbs: 3.4, fat: 4.3, serving: '100g' },
  { name: 'Ricota', calories: 174, protein: 11, carbs: 3, fat: 13, serving: '100g' },
  { name: 'Presunto', calories: 145, protein: 18, carbs: 1.5, fat: 8, serving: '100g' },
  { name: 'Salsicha', calories: 297, protein: 14, carbs: 2.4, fat: 25, serving: '100g' },
  { name: 'Hambúrguer', calories: 250, protein: 26, carbs: 0, fat: 16, serving: '100g' },
  { name: 'Pizza Margherita', calories: 266, protein: 11, carbs: 32, fat: 10, serving: '1 fatia' },
  { name: 'Sushi', calories: 130, protein: 6, carbs: 20, fat: 3, serving: '1 peça' },
  { name: 'Tacos', calories: 226, protein: 13, carbs: 24, fat: 9, serving: '1 taco' },
  { name: 'Salada César', calories: 200, protein: 10, carbs: 10, fat: 15, serving: 'porção' },
  { name: 'Sopa de Legumes', calories: 50, protein: 2, carbs: 10, fat: 0.5, serving: '200ml' },
  { name: 'Smoothie de Frutas', calories: 150, protein: 2, carbs: 35, fat: 1, serving: '250ml' },
  { name: 'Barra de Proteína', calories: 200, protein: 20, carbs: 20, fat: 6, serving: '1 barra' },
  { name: 'Whey Protein', calories: 120, protein: 24, carbs: 3, fat: 1, serving: '1 scoop' },
  { name: 'Café', calories: 2, protein: 0.1, carbs: 0, fat: 0, serving: '240ml' },
  { name: 'Chá Verde', calories: 1, protein: 0.2, carbs: 0, fat: 0, serving: '240ml' }
];

async function createDemoUsers() {
  const userIds = [];
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

      userIds.push(userRecord.uid);
      console.log(`Profile data added for user: ${userData.email}`);
    }

    console.log('All demo users created successfully!');
    return userIds;
  } catch (error) {
    console.error('Error creating demo users:', error);
    throw error;
  }
}

async function addSampleMeals(userIds) {
  const meals = [
    {
      name: 'Café da Manhã',
      foods: [{ name: 'Aveia', quantity: 50, calories: 153.5, protein: 5.5, carbs: 27.5, fat: 3 }],
      totalCalories: 153.5,
      totalProtein: 5.5,
      totalCarbs: 27.5,
      totalFat: 3,
      dateTime: new Date(),
      type: 'Café da Manhã'
    },
    {
      name: 'Almoço',
      foods: [{ name: 'Arroz Branco', quantity: 100, calories: 130, protein: 2.7, carbs: 28, fat: 0.3 }, { name: 'Frango Grelhado', quantity: 100, calories: 165, protein: 31, carbs: 0, fat: 3.6 }],
      totalCalories: 295,
      totalProtein: 33.7,
      totalCarbs: 28,
      totalFat: 3.9,
      dateTime: new Date(),
      type: 'Almoço'
    }
  ];

  for (const uid of userIds) {
    for (const meal of meals) {
      await db.collection('meals').add({
        ...meal,
        userId: uid
      });
    }
  }
  console.log('Sample meals added.');
}

async function addBodyMetrics(userIds) {
  const metrics = [
    { weight: 70, height: 170, date: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000) },
    { weight: 69.5, height: 170, date: new Date() }
  ];

  for (const uid of userIds) {
    for (const metric of metrics) {
      await db.collection('body_metrics').add({
        ...metric,
        userId: uid
      });
    }
  }
  console.log('Body metrics added.');
}

async function addWaterIntake(userIds) {
  const today = new Date().toISOString().split('T')[0];
  for (const uid of userIds) {
    await db.collection('water_intake').doc(uid).collection('days').doc(today).set({
      amount: 1.5
    });
  }
  console.log('Water intake added.');
}

async function addFoods() {
  for (const food of sampleFoods) {
    await db.collection('foods').add(food);
  }
  console.log('Foods added.');
}

async function addFriends(userIds) {
  if (userIds.length >= 2) {
    await db.collection('friends').add({
      userId: userIds[0],
      friendId: userIds[1],
      status: 'accepted'
    });
    await db.collection('friends').add({
      userId: userIds[1],
      friendId: userIds[0],
      status: 'accepted'
    });
  }
  console.log('Friends added.');
}

async function initializeFirestore() {
  try {
    const userIds = await createDemoUsers();
    await addSampleMeals(userIds);
    await addBodyMetrics(userIds);
    await addWaterIntake(userIds);
    await addFoods();
    await addFriends(userIds);
    console.log('Firestore initialized successfully!');
  } catch (error) {
    console.error('Error initializing Firestore:', error);
  } finally {
    admin.app().delete();
  }
}

initializeFirestore();
