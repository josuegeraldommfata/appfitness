# 🚧 O Que Falta para o Aplicativo Ficar Pronto

## 📊 Resumo Geral

### ✅ **O que já está implementado:**
- ✅ Autenticação completa (MongoDB)
- ✅ Sistema de assinaturas (Stripe/Mercado Pago)
- ✅ Estrutura do banco de dados
- ✅ Telas principais do app Flutter
- ✅ Providers e serviços básicos
- ✅ Usuários de teste

### ❌ **O que falta implementar:**

---

## 🔴 **CRÍTICO - Essencial para funcionar:**

### 1. **Backend - Rotas para Refeições (Meals)**
**Prioridade: ALTA** ⚠️

Criar `backend/routes/meals.js`:
- [ ] `GET /api/meals/user/:userId/date/:date` - Listar refeições por data
- [ ] `POST /api/meals` - Adicionar refeição
- [ ] `PUT /api/meals/:mealId` - Atualizar refeição
- [ ] `DELETE /api/meals/:mealId` - Deletar refeição
- [ ] `GET /api/meals/user/:userId` - Listar todas as refeições do usuário

**Arquivo:** `backend/routes/meals.js` (CRIAR)
**Modelo já existe:** ✅ `backend/models/Meal.js`

### 2. **Backend - Rotas para Métricas Corporais (Body Metrics)**
**Prioridade: ALTA** ⚠️

Criar `backend/routes/bodyMetrics.js`:
- [ ] `GET /api/body-metrics/user/:userId` - Listar histórico de métricas
- [ ] `POST /api/body-metrics` - Adicionar métrica
- [ ] `PUT /api/body-metrics/:metricId` - Atualizar métrica
- [ ] `DELETE /api/body-metrics/:metricId` - Deletar métrica

**Arquivo:** `backend/routes/bodyMetrics.js` (CRIAR)
**Modelo já existe:** ✅ `backend/models/BodyMetrics.js`

### 3. **Backend - Rotas para Consumo de Água (Water Intake)**
**Prioridade: ALTA** ⚠️

Criar `backend/routes/waterIntake.js`:
- [ ] `GET /api/water-intake/user/:userId/date/:date` - Obter consumo por data
- [ ] `POST /api/water-intake` - Adicionar consumo de água
- [ ] `PUT /api/water-intake/:intakeId` - Atualizar consumo
- [ ] `DELETE /api/water-intake/:intakeId` - Deletar consumo
- [ ] `GET /api/water-intake/user/:userId/today` - Obter consumo hoje

**Arquivo:** `backend/routes/waterIntake.js` (CRIAR)
**Modelo já existe:** ✅ `backend/models/WaterIntake.js`

### 4. **Frontend - Implementar Métodos no ApiService**
**Prioridade: ALTA** ⚠️

Atualizar `lib/services/api_service.dart`:
- [ ] `getMealsForDate()` - Implementar chamada ao backend
- [ ] `addMeal()` - Implementar chamada ao backend
- [ ] `updateMeal()` - Implementar chamada ao backend
- [ ] `deleteMeal()` - Implementar chamada ao backend
- [ ] `getBodyMetricsHistory()` - Implementar chamada ao backend
- [ ] `addBodyMetrics()` - Implementar chamada ao backend
- [ ] `addWater()` - Implementar chamada ao backend
- [ ] `getWaterIntakeToday()` - Implementar chamada ao backend
- [ ] `resetWaterIntake()` - Implementar chamada ao backend

**Arquivo:** `lib/services/api_service.dart` (ATUALIZAR)
**Status:** Métodos existem mas retornam vazio/erro

### 5. **Backend - Registrar Rotas no Server**
**Prioridade: ALTA** ⚠️

Atualizar `backend/server.js`:
- [ ] Adicionar import das rotas de meals
- [ ] Adicionar import das rotas de body metrics
- [ ] Adicionar import das rotas de water intake
- [ ] Registrar rotas com `app.use()`

**Arquivo:** `backend/server.js` (ATUALIZAR)

### 6. **Remover Inicialização do Firebase do main.dart**
**Prioridade: MÉDIA** ⚠️

O `lib/main.dart` ainda tem imports do Firebase que não são mais necessários:
- [ ] Remover `import 'package:firebase_core/firebase_core.dart';`
- [ ] Remover `import 'firebase_options.dart';`
- [ ] Remover `await Firebase.initializeApp(...);`

**Arquivo:** `lib/main.dart` (ATUALIZAR)

---

## 🟡 **IMPORTANTE - Funcionalidades que melhoram o app:**

### 7. **Middleware de Autenticação no Backend**
**Prioridade: MÉDIA** 

Criar middleware para verificar token em rotas protegidas:
- [ ] Criar `backend/middleware/auth.js`
- [ ] Verificar token em todas as rotas que precisam autenticação
- [ ] Adicionar middleware nas rotas

**Arquivo:** `backend/middleware/auth.js` (CRIAR)

### 8. **Validação de Dados no Backend**
**Prioridade: MÉDIA**

Adicionar validação usando Joi ou similar:
- [ ] Validar dados de entrada nas rotas
- [ ] Retornar erros de validação apropriados
- [ ] Validar tipos e formatos

**Pacote sugerido:** `joi` ou `express-validator`

### 9. **Tratamento de Erros Centralizado**
**Prioridade: MÉDIA**

Melhorar tratamento de erros:
- [ ] Criar middleware de tratamento de erros
- [ ] Padronizar formato de respostas de erro
- [ ] Adicionar logs de erro

### 10. **Busca de Alimentos no Backend**
**Prioridade: MÉDIA**

Criar sistema de busca de alimentos:
- [ ] Criar modelo `Food` ou usar API externa
- [ ] Criar rota `GET /api/foods/search?q=...`
- [ ] Integrar com frontend

**Opções:**
- Usar API externa (ex: USDA Food Data Central)
- Criar banco de dados próprio de alimentos

### 11. **Funcionalidades Pendentes no Frontend**
**Prioridade: BAIXA**

Melhorias e funcionalidades extras:
- [ ] Editar perfil de usuário
- [ ] Compartilhar app
- [ ] Configurações de notificação
- [ ] Configuração de ID Herbalife
- [ ] Editar/Deletar refeições (UI)
- [ ] Enviar mensagem para amigos
- [ ] Desafiar amigos
- [ ] Tela de calendário funcional
- [ ] Chat com IA (se implementado)

---

## 🟢 **MELHORIAS - Não essencial mas importante:**

### 12. **Segurança**
**Prioridade: ALTA (Para produção)**

- [ ] Implementar bcrypt para hash de senhas (substituir SHA-256)
- [ ] Implementar rate limiting
- [ ] Configurar CORS adequadamente para produção
- [ ] Implementar HTTPS
- [ ] Validar e sanitizar inputs
- [ ] Proteger contra SQL injection (MongoDB já protege, mas validar queries)

### 13. **Performance**
**Prioridade: MÉDIA**

- [ ] Implementar cache (Redis ou similar)
- [ ] Otimizar queries do MongoDB
- [ ] Implementar paginação nas listas
- [ ] Implementar lazy loading no frontend
- [ ] Otimizar imagens e assets

### 14. **Testes**
**Prioridade: MÉDIA**

- [ ] Testes unitários do backend
- [ ] Testes de integração da API
- [ ] Testes unitários do frontend
- [ ] Testes E2E

### 15. **Documentação**
**Prioridade: BAIXA**

- [ ] Documentação completa da API (Swagger/OpenAPI)
- [ ] Documentação do código
- [ ] Guia de contribuição
- [ ] README completo

### 16. **Deploy e DevOps**
**Prioridade: MÉDIA (Para produção)**

- [ ] Configurar CI/CD
- [ ] Deploy do backend (Heroku, AWS, etc.)
- [ ] Deploy do frontend (Firebase Hosting, Vercel, etc.)
- [ ] Configurar variáveis de ambiente em produção
- [ ] Monitoramento e logs

---

## 📝 **Checklist Rápido**

### Para o app funcionar basicamente:
- [x] Autenticação
- [x] Banco de dados configurado
- [ ] **Rotas de refeições (CRÍTICO)**
- [ ] **Rotas de métricas corporais (CRÍTICO)**
- [ ] **Rotas de água (CRÍTICO)**
- [ ] **Implementar métodos no ApiService (CRÍTICO)**
- [ ] **Registrar rotas no server.js (CRÍTICO)**
- [ ] Remover Firebase do main.dart

### Para o app estar completo:
- [ ] Middleware de autenticação
- [ ] Validação de dados
- [ ] Busca de alimentos
- [ ] Funcionalidades extras do frontend
- [ ] Segurança (bcrypt, rate limiting, etc.)
- [ ] Testes
- [ ] Documentação

---

## 🎯 **Ordem de Implementação Recomendada:**

1. **1º - Backend: Rotas de Meals** (30 min)
2. **2º - Backend: Rotas de Body Metrics** (20 min)
3. **3º - Backend: Rotas de Water Intake** (20 min)
4. **4º - Backend: Registrar rotas no server.js** (5 min)
5. **5º - Frontend: Implementar métodos no ApiService** (1 hora)
6. **6º - Frontend: Remover Firebase do main.dart** (5 min)
7. **7º - Backend: Middleware de autenticação** (30 min)
8. **8º - Backend: Validação de dados** (1 hora)
9. **9º - Melhorias e testes** (varia)

**Tempo estimado para versão funcional básica: ~2-3 horas**
**Tempo estimado para versão completa: ~1-2 semanas**

---

## 🚀 **Como começar:**

1. Criar `backend/routes/meals.js`
2. Criar `backend/routes/bodyMetrics.js`
3. Criar `backend/routes/waterIntake.js`
4. Atualizar `backend/server.js` para registrar as rotas
5. Atualizar `lib/services/api_service.dart` para implementar os métodos
6. Atualizar `lib/main.dart` para remover Firebase
7. Testar tudo funcionando

---

## 💡 **Notas Importantes:**

- Todos os modelos do MongoDB já existem ✅
- A estrutura do backend está pronta ✅
- O frontend está esperando os endpoints ✅
- Faltam principalmente as rotas do backend e a integração completa

**O app está ~70% completo. Falta principalmente a implementação das rotas do backend e a integração final!**

