// Test HTTP Endpoints
// Tests the actual HTTP routes to ensure they work correctly
const http = require('http');

const BASE_URL = 'http://localhost:3000';
const API_BASE = `${BASE_URL}/api/auth`;

// Helper to make HTTP requests
const makeRequest = (method, path, data = null) => {
  return new Promise((resolve, reject) => {
    const url = new URL(path, BASE_URL);
    const options = {
      method,
      headers: {
        'Content-Type': 'application/json',
      },
    };

    const req = http.request(url, options, (res) => {
      let body = '';
      res.on('data', (chunk) => {
        body += chunk;
      });
      res.on('end', () => {
        try {
          const parsed = body ? JSON.parse(body) : {};
          resolve({
            statusCode: res.statusCode,
            headers: res.headers,
            body: parsed,
          });
        } catch (e) {
          resolve({
            statusCode: res.statusCode,
            headers: res.headers,
            body: body,
          });
        }
      });
    });

    req.on('error', (error) => {
      reject(error);
    });

    if (data) {
      req.write(JSON.stringify(data));
    }

    req.end();
  });
};

// Test 1: Health check
const testHealthCheck = async () => {
  try {
    console.log('🧪 TESTE HTTP 1: Health Check\n');
    const response = await makeRequest('GET', '/');
    
    if (response.statusCode === 200) {
      console.log('✅ Backend está respondendo');
      console.log(`   Status: ${response.statusCode}`);
      console.log(`   Response: ${JSON.stringify(response.body)}\n`);
      return true;
    } else {
      console.log(`❌ Backend retornou status ${response.statusCode}\n`);
      return false;
    }
  } catch (error) {
    console.log(`❌ Erro ao conectar ao backend: ${error.message}\n`);
    console.log('   ⚠️  Certifique-se de que o backend está rodando (npm start)\n');
    return false;
  }
};

// Test 2: Register new user
const testHttpRegister = async () => {
  try {
    console.log('🧪 TESTE HTTP 2: Registrar novo usuário via HTTP\n');
    
    const testUser = {
      email: `httptest${Date.now()}@test.com`,
      password: 'httptest123',
      name: 'HTTP Test User',
      birthDate: '1995-05-15',
      height: 175,
      weight: 75,
      bodyType: 'mesomorfo',
      goal: 'manutenção',
      targetWeight: 75,
      dailyCalorieGoal: 2000,
    };

    const response = await makeRequest('POST', API_BASE + '/register', testUser);
    
    if (response.statusCode === 200 && response.body.success) {
      console.log('✅ Registro via HTTP funcionou!');
      console.log(`   Email: ${testUser.email}`);
      console.log(`   Token recebido: ${response.body.token ? 'Sim' : 'Não'}`);
      console.log(`   User ID: ${response.body.user?.id || 'N/A'}\n`);
      return { success: true, email: testUser.email, password: testUser.password, token: response.body.token };
    } else {
      console.log(`❌ Registro falhou`);
      console.log(`   Status: ${response.statusCode}`);
      console.log(`   Erro: ${response.body.error || response.body.message || 'Desconhecido'}\n`);
      return { success: false };
    }
  } catch (error) {
    console.log(`❌ Erro ao registrar: ${error.message}\n`);
    return { success: false };
  }
};

// Test 3: Login
const testHttpLogin = async (email, password) => {
  try {
    console.log(`🧪 TESTE HTTP 3: Login via HTTP\n`);
    console.log(`   Email: ${email}`);

    const response = await makeRequest('POST', API_BASE + '/login', { email, password });
    
    if (response.statusCode === 200 && response.body.success) {
      console.log('✅ Login via HTTP funcionou!');
      console.log(`   Token recebido: ${response.body.token ? 'Sim' : 'Não'}`);
      console.log(`   Nome: ${response.body.user?.name || 'N/A'}`);
      console.log(`   Role: ${response.body.user?.role || 'N/A'}\n`);
      return { success: true, token: response.body.token };
    } else {
      console.log(`❌ Login falhou`);
      console.log(`   Status: ${response.statusCode}`);
      console.log(`   Erro: ${response.body.error || response.body.message || 'Desconhecido'}\n`);
      return { success: false };
    }
  } catch (error) {
    console.log(`❌ Erro ao fazer login: ${error.message}\n`);
    return { success: false };
  }
};

// Test 4: Login with wrong password
const testHttpLoginWrongPassword = async (email) => {
  try {
    console.log(`🧪 TESTE HTTP 4: Login com senha incorreta\n`);
    console.log(`   Email: ${email}`);

    const response = await makeRequest('POST', API_BASE + '/login', { 
      email, 
      password: 'senhaerrada123' 
    });
    
    if (response.statusCode === 401) {
      console.log('✅ Senha incorreta foi rejeitada corretamente');
      console.log(`   Status: ${response.statusCode} (Esperado: 401)\n`);
      return true;
    } else {
      console.log(`❌ Senha incorreta foi aceita (ERRO!)`);
      console.log(`   Status: ${response.statusCode} (Esperado: 401)\n`);
      return false;
    }
  } catch (error) {
    console.log(`❌ Erro no teste: ${error.message}\n`);
    return false;
  }
};

// Test 5: Register duplicate email
const testHttpRegisterDuplicate = async (email) => {
  try {
    console.log(`🧪 TESTE HTTP 5: Registrar email duplicado\n`);
    console.log(`   Email: ${email}`);

    const response = await makeRequest('POST', API_BASE + '/register', {
      email,
      password: 'senha123',
      name: 'Duplicate Test',
      birthDate: '1990-01-01',
    });
    
    if (response.statusCode === 400 && response.body.error) {
      console.log('✅ Email duplicado foi rejeitado corretamente');
      console.log(`   Status: ${response.statusCode} (Esperado: 400)`);
      console.log(`   Mensagem: ${response.body.error}\n`);
      return true;
    } else {
      console.log(`❌ Email duplicado foi aceito (ERRO!)`);
      console.log(`   Status: ${response.statusCode} (Esperado: 400)\n`);
      return false;
    }
  } catch (error) {
    console.log(`❌ Erro no teste: ${error.message}\n`);
    return false;
  }
};

// Test 6: Login with demo users
const testHttpDemoUsers = async () => {
  try {
    console.log('🧪 TESTE HTTP 6: Login com usuários demo\n');

    const demoUsers = [
      { email: 'demoadmin@email.com', password: 'admin123' },
      { email: 'demouser@email.com', password: 'user123' },
    ];

    let allPassed = true;
    for (const demoUser of demoUsers) {
      const result = await testHttpLogin(demoUser.email, demoUser.password);
      if (!result.success) {
        allPassed = false;
      }
    }

    if (allPassed) {
      console.log('✅ Todos os usuários demo funcionam via HTTP!\n');
      return true;
    } else {
      console.log('❌ Alguns usuários demo falharam\n');
      return false;
    }
  } catch (error) {
    console.log(`❌ Erro no teste: ${error.message}\n`);
    return false;
  }
};

// Run all HTTP tests
const runHttpTests = async () => {
  try {
    console.log('🚀 INICIANDO TESTES HTTP COMPLETOS\n');
    console.log('='.repeat(60));
    console.log(`🌐 Base URL: ${BASE_URL}\n`);

    let testsPassed = 0;
    let testsFailed = 0;

    // Test 1: Health check
    if (await testHealthCheck()) {
      testsPassed++;
    } else {
      testsFailed++;
      console.log('❌ Backend não está respondendo. Execute: npm start\n');
      process.exit(1);
    }

    // Test 2: Register
    const registerResult = await testHttpRegister();
    if (registerResult.success) {
      testsPassed++;
    } else {
      testsFailed++;
    }

    // Test 3: Login with new user
    if (registerResult.success) {
      const loginResult = await testHttpLogin(registerResult.email, registerResult.password);
      if (loginResult.success) {
        testsPassed++;
      } else {
        testsFailed++;
      }

      // Test 4: Wrong password
      if (await testHttpLoginWrongPassword(registerResult.email)) {
        testsPassed++;
      } else {
        testsFailed++;
      }

      // Test 5: Duplicate email
      if (await testHttpRegisterDuplicate(registerResult.email)) {
        testsPassed++;
      } else {
        testsFailed++;
      }
    }

    // Test 6: Demo users
    if (await testHttpDemoUsers()) {
      testsPassed++;
    } else {
      testsFailed++;
    }

    // Summary
    console.log('='.repeat(60));
    console.log('\n📊 RESUMO DOS TESTES HTTP:\n');
    console.log(`✅ Testes passados: ${testsPassed}`);
    console.log(`❌ Testes falhados: ${testsFailed}`);
    console.log(`📈 Taxa de sucesso: ${((testsPassed / (testsPassed + testsFailed)) * 100).toFixed(1)}%\n`);

    if (testsFailed === 0) {
      console.log('🎉 TODOS OS TESTES HTTP PASSARAM! Sistema está 100% funcional! ✅\n');
      process.exit(0);
    } else {
      console.log('⚠️  ALGUNS TESTES HTTP FALHARAM!\n');
      process.exit(1);
    }
  } catch (error) {
    console.error('\n❌ ERRO CRÍTICO:', error);
    process.exit(1);
  }
};

runHttpTests();

