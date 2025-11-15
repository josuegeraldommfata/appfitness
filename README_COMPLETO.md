# 🎉 NUDGE - Aplicativo de Saúde e Fitness

## ✅ **APLICATIVO 100% COMPLETO E FUNCIONAL!**

O NUDGE é um aplicativo completo de saúde e fitness desenvolvido em Flutter com backend Node.js/Express e MongoDB Atlas.

---

## 🚀 **Quick Start**

### **1. Backend:**
```bash
cd backend
npm install
npm run init-db      # Inicializar banco de dados
npm run create-test-users  # Criar usuários de teste
npm start            # Iniciar servidor na porta 3000
```

### **2. Frontend:**
```bash
flutter pub get
flutter run
```

### **3. Login:**
- **Admin:** `admin@test.com` / `admin123`
- **User:** `user@test.com` / `user123`

---

## ✨ **Funcionalidades Implementadas**

### ✅ **Autenticação**
- Login/Registro/Logout
- Sistema de tokens
- Verificação de sessão

### ✅ **Usuários**
- CRUD completo
- Perfis personalizados
- Dashboard admin
- Estatísticas

### ✅ **Refeições (Meals)**
- Adicionar refeições
- Histórico completo
- Cálculo automático de calorias e macros
- Editar/Deletar refeições

### ✅ **Métricas Corporais**
- Registrar peso
- % gordura corporal
- Massa muscular
- Histórico e gráficos

### ✅ **Consumo de Água**
- Registrar consumo
- Meta diária (2L)
- Histórico

### ✅ **Assinaturas**
- Planos: Free, Fit, Personal, Personal Plus, Leader
- Integração Stripe
- Integração Mercado Pago
- Gerenciamento de assinaturas

---

## 📁 **Estrutura do Projeto**

```
nudge-main/
├── backend/           # Node.js/Express API
│   ├── routes/        # Rotas da API
│   ├── models/        # Modelos MongoDB
│   ├── config/        # Configurações
│   └── scripts/       # Scripts de inicialização
├── lib/               # Flutter App
│   ├── screens/       # Telas do app
│   ├── services/      # Serviços e APIs
│   ├── providers/     # State management
│   └── models/        # Modelos de dados
└── docs/              # Documentação
```

---

## 🔌 **Endpoints da API**

### Autenticação
- `POST /api/auth/login`
- `POST /api/auth/register`
- `POST /api/auth/logout`
- `GET /api/auth/verify`

### Refeições
- `GET /api/meals/user/:userId/date/:date`
- `GET /api/meals/user/:userId`
- `POST /api/meals`
- `PUT /api/meals/id/:mealId`
- `DELETE /api/meals/id/:mealId`

### Métricas Corporais
- `GET /api/body-metrics/user/:userId`
- `POST /api/body-metrics`
- `PUT /api/body-metrics/id/:metricId`
- `DELETE /api/body-metrics/id/:metricId`

### Consumo de Água
- `GET /api/water-intake/user/:userId/today`
- `POST /api/water-intake`
- `DELETE /api/water-intake/user/:userId/today`

### Assinaturas
- `GET /api/subscriptions/user/:userId/active`
- `POST /api/subscriptions`
- `PUT /api/subscriptions/:subscriptionId`
- `DELETE /api/subscriptions/:subscriptionId`

---

## 📊 **Banco de Dados (MongoDB)**

### Coleções:
- `auths` - Autenticação e tokens
- `users` - Usuários
- `subscriptions` - Assinaturas
- `meals` - Refeições
- `bodymetrics` - Métricas corporais
- `waterintakes` - Consumo de água

---

## 🎯 **Status: PRONTO PARA USO!**

✅ Todas as funcionalidades principais implementadas
✅ Backend 100% funcional
✅ Frontend 100% integrado
✅ Banco de dados configurado
✅ Usuários de teste criados

---

## 📚 **Documentação**

- `FINALIZADO.md` - Status completo do projeto
- `APP_COMPLETO.md` - Lista de funcionalidades
- `MONGODB_ONLY_SETUP.md` - Configuração MongoDB
- `O_QUE_FALTA.md` - Checklist (agora tudo completo!)

---

## 🎊 **Parabéns!**

**O aplicativo NUDGE está completo e pronto para uso!**

Todos os componentes foram implementados e estão funcionando. Você pode começar a usar o aplicativo imediatamente!

---

**Desenvolvido com ❤️ para ajudar na jornada de bem-estar!**

