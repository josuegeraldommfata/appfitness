// Script para Criar Usuário do Cliente
// Execute: node SCRIPT_CRIAR_USUARIO_CLIENTE.js

const mongoose = require('mongoose');
const crypto = require('crypto');
const { connectDB } = require('./backend/config/mongodb');
const Auth = require('./backend/models/Auth');
const User = require('./backend/models/User');

// ⚠️ CONFIGURE AQUI OS DADOS DO CLIENTE:
const clienteData = {
  email: 'cliente@email.com', // MUDE PARA EMAIL DO CLIENTE
  password: 'Senha123', // MUDE PARA SENHA DESEJADA
  name: 'Nome do Cliente', // MUDE PARA NOME DO CLIENTE
  birthDate: '1990-01-01', // Data de nascimento
  height: 170, // Altura em cm
  weight: 70, // Peso em kg
  bodyType: 'mesomorfo', // ectomorfo, mesomorfo, endomorfo
  goal: 'manutenção', // perda de peso, ganho de peso, manutenção
  targetWeight: 70, // Peso alvo em kg
  dailyCalorieGoal: 2000, // Calorias diárias
  macroGoals: {
    protein: 150, // Proteínas em gramas
    carbs: 200, // Carboidratos em gramas
    fat: 65, // Gorduras em gramas
  },
};

async function criarUsuarioCliente() {
  try {
    console.log('🔄 Conectando ao MongoDB...');
    await connectDB();

    const { email, password, name, birthDate, height, weight, bodyType, goal, targetWeight, dailyCalorieGoal, macroGoals } = clienteData;

    // Verificar se usuário já existe
    const existingAuth = await Auth.findOne({ email: email.toLowerCase() });
    if (existingAuth) {
      console.log(`⚠️  Usuário ${email} já existe!`);
      console.log('   Atualizando senha...');
      
      // Atualizar senha
      existingAuth.passwordHash = crypto.createHash('sha256').update(password).digest('hex');
      await existingAuth.save();
      
      // Atualizar dados do usuário
      await User.findOneAndUpdate(
        { email: email.toLowerCase() },
        {
          name,
          birthDate: new Date(birthDate),
          height,
          weight,
          bodyType,
          goal,
          targetWeight,
          dailyCalorieGoal,
          macroGoals,
          updatedAt: new Date(),
        },
        { new: true }
      );
      
      console.log('✅ Usuário atualizado com sucesso!');
    } else {
      // Criar novo usuário
      const userId = new mongoose.Types.ObjectId().toString();

      // Criar auth
      const auth = new Auth({
        userId,
        email: email.toLowerCase(),
        passwordHash: crypto.createHash('sha256').update(password).digest('hex'),
      });
      await auth.save();

      // Criar user
      const user = new User({
        id: userId,
        name,
        email: email.toLowerCase(),
        birthDate: new Date(birthDate),
        height,
        weight,
        bodyType,
        goal,
        targetWeight,
        dailyCalorieGoal,
        macroGoals,
        role: 'user',
        currentPlan: 'free',
      });
      await user.save();

      console.log('✅ Usuário criado com sucesso!');
    }

    // Exibir informações
    console.log('\n📋 DADOS DO USUÁRIO CRIADO:');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    console.log(`📧 Email: ${email}`);
    console.log(`🔐 Senha: ${password}`);
    console.log(`👤 Nome: ${name}`);
    console.log(`📦 Plano: free`);
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    console.log('\n✅ Envie essas credenciais para o cliente!');
    console.log('⚠️  IMPORTANTE: Guarde essas informações com segurança!');

    process.exit(0);
  } catch (error) {
    console.error('❌ Erro ao criar usuário:', error);
    process.exit(1);
  }
}

// Executar
criarUsuarioCliente();

