// Complete Authentication Test Script
// Tests registration, login, and error handling
const mongoose = require('mongoose');
const crypto = require('crypto');
const { connectDB } = require('../config/mongodb');
const Auth = require('../models/Auth');
const User = require('../models/User');

let testsPassed = 0;
let testsFailed = 0;

const logSuccess = (message) => {
  console.log(`✅ ${message}`);
  testsPassed++;
};

const logError = (message, error = null) => {
  console.log(`❌ ${message}`);
  if (error) console.error(`   Erro: ${error.message}`);
  testsFailed++;
};

// Test 1: Register new user
const testRegister = async () => {
  try {
    console.log('\n🧪 TESTE 1: Registrar novo usuário\n');
    
    const testUser = {
      email: `test${Date.now()}@test.com`,
      password: 'test123456',
      name: 'Usuário Teste',
      birthDate: '1995-05-15',
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
    };

    // Check if user already exists
    const existingAuth = await Auth.findOne({ email: testUser.email.toLowerCase() });
    if (existingAuth) {
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
      macroGoals: testUser.macroGoals,
      role: 'user',
      currentPlan: 'free',
    });
    await user.save();

    // Verify user was created
    const savedAuth = await Auth.findOne({ email: testUser.email.toLowerCase() });
    const savedUser = await User.findOne({ email: testUser.email.toLowerCase() });

    if (!savedAuth || !savedUser) {
      logError('Usuário não foi criado corretamente');
      return null;
    }

    if (savedUser.id !== savedAuth.userId) {
      logError('IDs não correspondem');
      return null;
    }

    logSuccess('Usuário registrado com sucesso');
    console.log(`   Email: ${testUser.email}`);
    console.log(`   Nome: ${testUser.name}`);
    console.log(`   ID: ${userId}`);

    return { email: testUser.email, password: testUser.password, userId };
  } catch (error) {
    logError('Erro ao registrar usuário', error);
    return null;
  }
};

// Test 2: Login with correct credentials
const testLogin = async (email, password) => {
  try {
    console.log(`\n🧪 TESTE 2: Login com credenciais corretas\n`);
    console.log(`   Email: ${email}`);

    // Find auth record
    const auth = await Auth.findOne({ email: email.toLowerCase() });
    if (!auth) {
      logError('Registro de autenticação não encontrado');
      return false;
    }

    // Verify password
    const passwordHash = crypto.createHash('sha256').update(password).digest('hex');
    if (auth.passwordHash !== passwordHash) {
      logError('Senha incorreta');
      return false;
    }

    // Get user profile
    const user = await User.findOne({ id: auth.userId });
    if (!user) {
      logError('Perfil de usuário não encontrado');
      return false;
    }

    logSuccess('Login realizado com sucesso');
    console.log(`   Nome: ${user.name}`);
    console.log(`   Role: ${user.role}`);
    console.log(`   Plan: ${user.currentPlan}`);

    return true;
  } catch (error) {
    logError('Erro ao fazer login', error);
    return false;
  }
};

// Test 3: Login with wrong password
const testLoginWrongPassword = async (email) => {
  try {
    console.log(`\n🧪 TESTE 3: Login com senha incorreta\n`);
    console.log(`   Email: ${email}`);

    const auth = await Auth.findOne({ email: email.toLowerCase() });
    if (!auth) {
      logError('Usuário não encontrado');
      return false;
    }

    const wrongPassword = 'senhaerrada123';
    const passwordHash = crypto.createHash('sha256').update(wrongPassword).digest('hex');
    
    if (auth.passwordHash === passwordHash) {
      logError('Senha incorreta foi aceita (ERRO!)');
      return false;
    }

    logSuccess('Senha incorreta foi rejeitada corretamente');
    return true;
  } catch (error) {
    logError('Erro no teste de senha incorreta', error);
    return false;
  }
};

// Test 4: Login with non-existent user
const testLoginNonExistent = async () => {
  try {
    console.log(`\n🧪 TESTE 4: Login com usuário inexistente\n`);

    const fakeEmail = `naoexiste${Date.now()}@test.com`;
    const auth = await Auth.findOne({ email: fakeEmail.toLowerCase() });
    
    if (auth) {
      logError('Usuário inexistente foi encontrado (ERRO!)');
      return false;
    }

    logSuccess('Usuário inexistente foi rejeitado corretamente');
    return true;
  } catch (error) {
    logError('Erro no teste de usuário inexistente', error);
    return false;
  }
};

// Test 5: Register duplicate email
const testRegisterDuplicate = async (email) => {
  try {
    console.log(`\n🧪 TESTE 5: Registrar email duplicado\n`);
    console.log(`   Email: ${email}`);

    const userId = new mongoose.Types.ObjectId().toString();
    const auth = new Auth({
      userId,
      email: email.toLowerCase(),
      passwordHash: crypto.createHash('sha256').update('senha123').digest('hex'),
    });

    try {
      await auth.save();
      logError('Email duplicado foi aceito (ERRO!)');
      // Clean up
      await Auth.deleteOne({ _id: auth._id });
      return false;
    } catch (error) {
      if (error.code === 11000) {
        logSuccess('Email duplicado foi rejeitado corretamente');
        return true;
      } else {
        throw error;
      }
    }
  } catch (error) {
    logError('Erro no teste de email duplicado', error);
    return false;
  }
};

// Test 6: Register without required fields
const testRegisterMissingFields = async () => {
  try {
    console.log(`\n🧪 TESTE 6: Registrar sem campos obrigatórios\n`);

    // Try to create user without email
    const userId = new mongoose.Types.ObjectId().toString();
    const auth = new Auth({
      userId,
      passwordHash: crypto.createHash('sha256').update('senha123').digest('hex'),
    });

    try {
      await auth.save();
      logError('Registro sem email foi aceito (ERRO!)');
      await Auth.deleteOne({ _id: auth._id });
      return false;
    } catch (error) {
      if (error.name === 'ValidationError') {
        logSuccess('Registro sem campos obrigatórios foi rejeitado corretamente');
        return true;
      } else {
        throw error;
      }
    }
  } catch (error) {
    logError('Erro no teste de campos obrigatórios', error);
    return false;
  }
};

// Test 7: Demo users login
const testDemoUsers = async () => {
  try {
    console.log(`\n🧪 TESTE 7: Login com usuários demo\n`);

    const demoUsers = [
      { email: 'demoadmin@email.com', password: 'admin123', name: 'Demo Admin' },
      { email: 'demouser@email.com', password: 'user123', name: 'Demo User' },
    ];

    let allPassed = true;
    for (const demoUser of demoUsers) {
      console.log(`   Testando: ${demoUser.email}`);
      const result = await testLogin(demoUser.email, demoUser.password);
      if (!result) {
        allPassed = false;
      }
    }

    if (allPassed) {
      logSuccess('Todos os usuários demo funcionam corretamente');
      return true;
    } else {
      logError('Alguns usuários demo falharam');
      return false;
    }
  } catch (error) {
    logError('Erro no teste de usuários demo', error);
    return false;
  }
};

// Run all tests
const runAllTests = async () => {
  try {
    console.log('🚀 INICIANDO TESTES COMPLETOS DE AUTENTICAÇÃO\n');
    console.log('='.repeat(60));

    await connectDB();
    console.log('✅ Conectado ao MongoDB\n');

    // Test 1: Register
    const newUser = await testRegister();
    if (!newUser) {
      console.log('\n❌ Teste de registro falhou. Abortando outros testes.');
      process.exit(1);
    }

    // Test 2: Login with new user
    await testLogin(newUser.email, newUser.password);

    // Test 3: Wrong password
    await testLoginWrongPassword(newUser.email);

    // Test 4: Non-existent user
    await testLoginNonExistent();

    // Test 5: Duplicate email
    await testRegisterDuplicate(newUser.email);

    // Test 6: Missing fields
    await testRegisterMissingFields();

    // Test 7: Demo users
    await testDemoUsers();

    // Summary
    console.log('\n' + '='.repeat(60));
    console.log('\n📊 RESUMO DOS TESTES:\n');
    console.log(`✅ Testes passados: ${testsPassed}`);
    console.log(`❌ Testes falhados: ${testsFailed}`);
    console.log(`📈 Taxa de sucesso: ${((testsPassed / (testsPassed + testsFailed)) * 100).toFixed(1)}%\n`);

    if (testsFailed === 0) {
      console.log('🎉 TODOS OS TESTES PASSARAM! Sistema está funcional! ✅\n');
      console.log('📋 USUÁRIOS DISPONÍVEIS:');
      console.log('   • demoadmin@email.com / admin123');
      console.log('   • demouser@email.com / user123');
      console.log(`   • ${newUser.email} / ${newUser.password}\n`);
      process.exit(0);
    } else {
      console.log('⚠️  ALGUNS TESTES FALHARAM! Verifique os erros acima.\n');
      process.exit(1);
    }
  } catch (error) {
    console.error('\n❌ ERRO CRÍTICO:', error);
    process.exit(1);
  }
};

runAllTests();

