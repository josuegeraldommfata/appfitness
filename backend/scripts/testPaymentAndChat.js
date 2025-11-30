// Script para testar Pagamentos (Stripe/Mercado Pago) e ChatGPT
const axios = require('axios');

const BASE_URL = process.env.BACKEND_URL || 'http://localhost:3000';

console.log('🧪 TESTANDO SISTEMA DE PAGAMENTOS E CHATGPT\n');
console.log(`📍 Backend URL: ${BASE_URL}\n`);

// Test 1: Health Check
async function testHealthCheck() {
  console.log('1️⃣ Testando Health Check...');
  try {
    const response = await axios.get(`${BASE_URL}/health`);
    console.log('   ✅ Health Check OK');
    console.log(`   Status: ${response.data.status}\n`);
    return true;
  } catch (error) {
    console.log('   ❌ Health Check FALHOU');
    console.log(`   Erro: ${error.message}\n`);
    return false;
  }
}

// Test 2: ChatGPT
async function testChatGPT() {
  console.log('2️⃣ Testando ChatGPT...');
  try {
    const response = await axios.post(
      `${BASE_URL}/api/chatgpt/message`,
      {
        message: 'Olá, como posso perder peso?',
      },
      {
        headers: {
          'Content-Type': 'application/json',
        },
        timeout: 30000, // 30 segundos
      }
    );

    if (response.data.success && response.data.response) {
      console.log('   ✅ ChatGPT funcionando!');
      console.log(`   Resposta: ${response.data.response.substring(0, 100)}...\n`);
      return true;
    } else {
      console.log('   ❌ ChatGPT retornou resposta inválida');
      console.log(`   Data: ${JSON.stringify(response.data)}\n`);
      return false;
    }
  } catch (error) {
    console.log('   ❌ ChatGPT FALHOU');
    if (error.response) {
      console.log(`   Status: ${error.response.status}`);
      console.log(`   Erro: ${JSON.stringify(error.response.data)}\n`);
    } else {
      console.log(`   Erro: ${error.message}\n`);
    }
    return false;
  }
}

// Test 3: Stripe - Create Payment Intent
async function testStripePayment() {
  console.log('3️⃣ Testando Stripe Payment Intent...');
  try {
    const response = await axios.post(
      `${BASE_URL}/api/stripe/create-payment-intent`,
      {
        amount: 10.00, // R$ 10,00
        currency: 'brl',
        userId: 'test-user-123',
        planType: 'personal',
        billingPeriod: 'monthly',
      },
      {
        headers: {
          'Content-Type': 'application/json',
        },
        timeout: 10000,
      }
    );

    if (response.data.clientSecret) {
      console.log('   ✅ Stripe Payment Intent criado!');
      console.log(`   Client Secret: ${response.data.clientSecret.substring(0, 20)}...`);
      console.log(`   Payment Intent ID: ${response.data.paymentIntentId}\n`);
      return true;
    } else {
      console.log('   ❌ Stripe retornou resposta inválida');
      console.log(`   Data: ${JSON.stringify(response.data)}\n`);
      return false;
    }
  } catch (error) {
    console.log('   ❌ Stripe Payment Intent FALHOU');
    if (error.response) {
      console.log(`   Status: ${error.response.status}`);
      console.log(`   Erro: ${JSON.stringify(error.response.data)}\n`);
    } else {
      console.log(`   Erro: ${error.message}\n`);
    }
    return false;
  }
}

// Test 4: Mercado Pago - Create Preference (PIX)
async function testMercadoPagoPix() {
  console.log('4️⃣ Testando Mercado Pago PIX...');
  try {
    const response = await axios.post(
      `${BASE_URL}/api/mercado-pago/create-preference`,
      {
        amount: 10.00,
        userId: 'test-user-123',
        planType: 'personal',
        billingPeriod: 'monthly',
      },
      {
        headers: {
          'Content-Type': 'application/json',
        },
        timeout: 10000,
      }
    );

    if (response.data.preferenceId || response.data.initPoint) {
      console.log('   ✅ Mercado Pago Preference criada!');
      if (response.data.preferenceId) {
        console.log(`   Preference ID: ${response.data.preferenceId}`);
      }
      if (response.data.initPoint) {
        console.log(`   Init Point: ${response.data.initPoint.substring(0, 50)}...`);
      }
      console.log('');
      return true;
    } else {
      console.log('   ❌ Mercado Pago retornou resposta inválida');
      console.log(`   Data: ${JSON.stringify(response.data)}\n`);
      return false;
    }
  } catch (error) {
    console.log('   ❌ Mercado Pago PIX FALHOU');
    if (error.response) {
      console.log(`   Status: ${error.response.status}`);
      console.log(`   Erro: ${JSON.stringify(error.response.data)}\n`);
    } else {
      console.log(`   Erro: ${error.message}\n`);
    }
    return false;
  }
}

// Run all tests
async function runTests() {
  const results = {
    healthCheck: false,
    chatgpt: false,
    stripe: false,
    mercadoPago: false,
  };

  results.healthCheck = await testHealthCheck();
  
  if (results.healthCheck) {
    results.chatgpt = await testChatGPT();
    results.stripe = await testStripePayment();
    results.mercadoPago = await testMercadoPagoPix();
  } else {
    console.log('⚠️  Backend não está rodando! Inicie com: npm start\n');
  }

  // Summary
  console.log('='.repeat(50));
  console.log('📊 RESUMO DOS TESTES:');
  console.log('='.repeat(50));
  console.log(`   Health Check: ${results.healthCheck ? '✅' : '❌'}`);
  console.log(`   ChatGPT: ${results.chatgpt ? '✅' : '❌'}`);
  console.log(`   Stripe Payment: ${results.stripe ? '✅' : '❌'}`);
  console.log(`   Mercado Pago PIX: ${results.mercadoPago ? '✅' : '❌'}`);
  console.log('='.repeat(50));

  const allPassed = Object.values(results).every(r => r);
  if (allPassed) {
    console.log('\n🎉 TODOS OS TESTES PASSARAM!');
  } else {
    console.log('\n⚠️  ALGUNS TESTES FALHARAM');
    console.log('\n💡 Verifique:');
    console.log('   1. Backend está rodando (npm start)');
    console.log('   2. Variáveis de ambiente configuradas (.env)');
    console.log('   3. Chaves API configuradas (Stripe, Mercado Pago, OpenAI)');
  }

  process.exit(allPassed ? 0 : 1);
}

runTests();

