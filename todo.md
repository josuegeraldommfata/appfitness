# TODO - Aplicativo de Saúde e Fitness em Flutter

Este documento descreve o plano completo para desenvolver o aplicativo de saúde e fitness em Flutter, baseado no escopo fornecido. O projeto será desenvolvido apenas com frontend, com todos os dados mockados (sem backend real). O foco é em funcionalidades de acompanhamento nutricional, físico e motivacional, inspirado no Yazio, com adições como coaching personalizado, notificações e interações entre amigos.

## Visão Geral do Projeto
- **Nome do App**: SaúdeFit (ou similar, a definir)
- **Plataformas**: Android e iOS (usando Flutter)
- **Estado Inicial**: Projeto Flutter básico já criado (main.dart, pubspec.yaml, etc.)
- **Dependências Iniciais**: Adicionar pacotes necessários no pubspec.yaml (ex: provider para estado, shared_preferences para persistência local, intl para datas, etc.)
- **Mock Data**: Todos os dados serão simulados localmente (ex: alimentos, usuários, amigos, etc.)
- **Design e Inspiração**: O app deve se inspirar no Yazio, com cores similares (tons de verde, branco, interface limpa e intuitiva), layout focado em simplicidade e motivação.

## Estrutura Geral do Projeto
1. **Organização de Arquivos**:
   - Criar pastas: `models/`, `screens/`, `widgets/`, `services/`, `utils/`, `assets/`
   - Models: Classes para User, Meal, Food, BodyMetrics, etc.
   - Screens: Telas principais (Login, Home, Meals, etc.)
   - Widgets: Componentes reutilizáveis (Charts, Buttons, etc.)
   - Services: Lógica mockada para dados (ex: MockFoodService)
   - Utils: Helpers (ex: DateUtils, NotificationUtils)

2. **Estado e Persistência**:
   - Usar Provider ou Riverpod para gerenciamento de estado.
   - SharedPreferences para salvar dados locais (usuário logado, metas, etc.).

## Funcionalidades e Tarefas Detalhadas

### 1. Cadastro de Usuário
- **Tarefas**:
  - [X] Criar tela de cadastro/login (e-mail, Google, redes sociais - mockado).
  - [X] Formulário para metas pessoais (perda de peso, ganho muscular).
  - [X] Formulário para parâmetros de saúde (peso, altura, idade, tipo de corpo).
  - [X] Validação de campos e navegação para home após cadastro.
- **Mock**: Simular autenticação (sempre sucesso), salvar dados em SharedPreferences.
- **UI**: Campos de texto, dropdowns, botões.

### 2. Resumo Diário
- **Tarefas**:
  - [X] Criar tela principal (Home) com resumo de calorias e macronutrientes.
  - [X] Integrar banco de dados mockado de alimentos.
  - [X] Exibir gráficos (usar pacote como fl_chart) para ingestão calórica/macronutrientes.
  - [X] Atualizar resumo em tempo real com adições de refeições.
- **Mock**: Dados fixos ou gerados aleatoriamente para alimentos.
- **UI**: Cards, gráficos circulares/barras.

### 3. Cadastro de Refeições
- **Tarefas**:
  - [X] Tela para adicionar refeições (café da manhã, almoço, etc.).
  - [X] Busca de alimentos no banco mockado.
  - [ ] Possibilidade de "escanear" código de barras (simular com botão).
  - [X] Histórico de refeições.
  - [X] Sugestões baseadas em metas (mockadas).
- **Mock**: Lista de alimentos com calorias/macronutrientes.
- **UI**: Listas, formulários, botões de adição.

### 4. Consumo de Líquidos
- **Tarefas**:
  - [X] Tela ou seção para registrar água/outros líquidos.
  - [X] Contador diário com meta (ex: 2L).
  - [ ] Notificações push mockadas (usar flutter_local_notifications).
- **Mock**: Salvar consumo localmente.
- **UI**: Progress bar, botões para adicionar quantidades.

### 5. Monitoramento de Valores Corporais
- **Tarefas**:
  - [X] Tela para registrar peso, IMC, % gordura, circunferências.
  - [X] Gráficos de progresso ao longo do tempo (usar fl_chart).
  - [X] Relatórios históricos.
- **Mock**: Dados simulados para evolução.
- **UI**: Formulários, gráficos de linha.

### 6. Integração com Apps de Saúde (Mockada)
- **Tarefas**:
  - [ ] Simular importação de dados de Apple Health/Google Fit.
  - [X] Tela de configurações para "conectar" apps.
- **Mock**: Dados fixos importados ao "conectar".
- **UI**: Botões de integração, lista de dados importados.

### 7. Coach de Saúde Personalizado
- **Tarefas**:
  - [X] Sistema de notificações personalizadas baseado em desempenho.
  - [X] Pop-ups motivacionais (ex: "Parabéns pela meta!").
  - [X] Sugestões de ajustes (dieta/exercícios).
- **Mock**: Lógica simples baseada em metas atingidas.
- **UI**: Dialogs, snackbars para notificações.

### 8. Ranking entre Amigos
- **Tarefas**:
  - [X] Tela para adicionar amigos (lista mockada).
  - [X] Ranking de calorias, atividades, metas.
  - [X] Competições (ex: beber água).
- **Mock**: Lista de amigos com dados simulados.
- **UI**: Listas classificadas, ícones de medalhas.

### 9. Sugestões Personalizadas
- **Tarefas**:
  - [X] Sugestões de exercícios/dietas baseadas em metas.
  - [ ] Vídeos/tutoriais (links mockados ou placeholders).
  - [X] Receitas baseadas em preferências (vegano, etc.).
- **Mock**: Dados fixos para sugestões.
- **UI**: Cards com imagens, listas.

### 10. Notificações e Pop-Ups
- **Tarefas**:
  - [ ] Configurar notificações push (flutter_local_notifications).
  - [ ] Agendar lembretes para refeições, água, exercícios.
  - [X] Pop-ups motivacionais em momentos chave.
- **Mock**: Simular agendamento.
- **UI**: Configurações de notificações.

### 11. Relatórios e Análises
- **Tarefas**:
  - [X] Telas para relatórios semanais/mensais.
  - [X] Análise de progresso (peso, calorias).
  - [X] Comparação com outros usuários (mockada).
- **Mock**: Dados históricos simulados.
- **UI**: Gráficos, tabelas.

### 12. Design e UI/UX
- **Tarefas**:
  - [X] Implementar tema claro/escuro (inspirado no Yazio, com verde como cor principal).
  - [X] Design responsivo para mobile, focado em simplicidade e motivação.
  - [X] Ícones, cores amigáveis (tons de verde, branco, gradientes suaves).
  - [X] Navegação (BottomNavigationBar, Drawer).
- **UI**: Seguir Material Design, foco em usabilidade, similar ao Yazio (layouts limpos, cards, botões arredondados).

## Dependências a Adicionar no pubspec.yaml
- [X] provider: ^6.0.5 (estado)
- [X] shared_preferences: ^2.2.2 (persistência)
- [X] intl: ^0.19.0 (datas)
- [X] fl_chart: ^0.66.1 (gráficos)
- [ ] flutter_local_notifications: ^16.3.2 (notificações)
- [ ] image_picker: ^1.0.4 (para "escanear" códigos, se necessário)
- [X] Outros conforme necessidade (ex: http para simular APIs, mas manter mockado)

## Ordem de Desenvolvimento (Priorização)
1. [X] Configurar estrutura básica e dependências.
2. [X] Implementar cadastro/login (base para tudo).
3. [X] Criar resumo diário e cadastro de refeições (core do app).
4. [X] Adicionar consumo de líquidos e monitoramento corporal.
5. [X] Implementar integrações mockadas e coach.
6. [X] Adicionar amigos e rankings.
7. [X] Sugestões, notificações e relatórios.
8. [X] Polir UI/UX e testes.

## Testes e Validação
- [X] Escrever testes unitários para models e services.
- [X] Testes de widget para telas principais.
- [X] Testar em emuladores Android/iOS.

## Próximos Passos
- [X] Revisar e aprovar este plano.
- [X] Começar implementação incremental, testando cada funcionalidade.
- [X] Usar Git para versionamento (já há .gitignore).

## Funcionalidades Solicitadas pelo Cliente (Implementadas)

### Navegação Inferior Atualizada
- **Tarefas**:
  - [X] Alterar botões para: Home, Refeições, Bebidas, Progresso, Amigos
  - [X] Remover botão "Perfil"

### Ícones no AppBar Superior (Topo Direito)
- **Tarefas**:
  - [X] Adicionar ícones: Calendário, Notificações, Configurações
  - [X] Calendário: Navegação para alteração de datas retroativas
  - [X] Notificações: Lista de notificações (app, conquistas usuário/amigos, artigos)
  - [X] Configurações: Foto, nome, compartilhar app, editar informações, Herbalife, notificações, tema, coach WhatsApp

### Tela de Bebidas
- **Tarefas**:
  - [X] Criar tela para registrar consumo de líquidos
  - [X] Seleção de tipos de bebidas com cálculo de calorias
  - [X] Histórico de bebidas consumidas

### Tela de Progresso Melhorada
- **Tarefas**:
  - [X] Adicionar dropdown para seleção de período: Semanal, Mensal, Anual
  - [X] Gráficos e dados adaptados ao período selecionado

### Tela de Amigos Melhorada
- **Tarefas**:
  - [X] Ranking entre amigos e global
  - [X] Busca de amigos por nome/email
  - [X] Adicionar amigos com pedido de amizade

### Botão Coach WhatsApp
- **Tarefas**:
  - [X] Implementar botão para chamar coach via WhatsApp

Este plano cobre todas as funcionalidades do escopo, com foco em frontend mockado. Ajustes podem ser feitos conforme progresso.
