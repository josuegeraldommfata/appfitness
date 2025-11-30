import 'package:flutter/material.dart';

enum PlanType {
  free,
  fit,
  personal,
  personalPlus,
  leader,
}

class Plan {
  final PlanType type;
  final String name;
  final String description;
  final double monthlyPrice;
  final double? yearlyPrice;
  final String? yearlySavings;
  final String emoji;
  final Color color;
  final List<String> features;
  final String? herbalifeIdRequired;
  final bool isAddOn;

  Plan({
    required this.type,
    required this.name,
    required this.description,
    required this.monthlyPrice,
    this.yearlyPrice,
    this.yearlySavings,
    required this.emoji,
    required this.color,
    required this.features,
    this.herbalifeIdRequired,
    this.isAddOn = false,
  });
}

class Plans {
  static final List<Plan> allPlans = [
    Plan(
      type: PlanType.free,
      name: 'FREE',
      description: 'Ideal para conhecer o app e começar sua jornada de bem-estar.',
      monthlyPrice: 0.0,
      emoji: '🩵',
      color: const Color(0xFF87CEEB), // Sky Blue
      features: [
        'Registro de hidratação',
        'Registro manual de refeições',
        'Progresso corporal básico (peso)',
        'Ranking da comunidade',
      ],
    ),
    Plan(
      type: PlanType.fit,
      name: 'FIT',
      description: 'Ideal para conhecer o app e começar sua jornada de bem-estar.',
      monthlyPrice: 0.0,
      emoji: '🟢',
      color: Colors.green,
      features: [
        'Tudo do plano Free',
        'Progresso corporal completo (peso, gordura, massa muscular)',
        'Gráficos detalhados da evolução',
        'Acesso aos desafios da comunidade',
      ],
      herbalifeIdRequired: 'Insira o ID Herbalife no seu perfil',
    ),
    Plan(
      type: PlanType.personal,
      name: 'PERSONAL',
      description: 'Perfeito para quem quer acompanhamento constante e metas mais precisas.',
      monthlyPrice: 19.90,
      yearlyPrice: 199.0,
      yearlySavings: 'Economize R\$ 39,80',
      emoji: '🔵',
      color: Colors.blue,
      features: [
        'Todas as vantagens do plano Fit',
        '200 mensagens/mês com o Personal IA (inclui registro de refeições por foto e texto)',
        'Metas baseadas no seu estilo de vida',
      ],
    ),
    Plan(
      type: PlanType.personalPlus,
      name: 'PERSONAL PLUS',
      description: 'Seu coach pessoal de verdade — acompanhamento contínuo, sem limites.',
      monthlyPrice: 49.90,
      yearlyPrice: 499.0,
      yearlySavings: '2 meses grátis',
      emoji: '🟣',
      color: Colors.purple,
      features: [
        'Todas as vantagens do Plano Personal',
        'Mensagens ilimitadas com o Coach IA',
      ],
    ),
    Plan(
      type: PlanType.leader,
      name: 'LÍDER',
      description: 'Você paga apenas pelo que realmente gera resultado — sua rede ativa. Quanto mais cresce, mais o Nudge trabalha por você.',
      monthlyPrice: 99.0,
      yearlyPrice: 999.0,
      yearlySavings: 'Economize R\$ 189',
      emoji: '🟠',
      color: Colors.orange,
      features: [
        'Área exclusiva do Líder',
        'Crie sua própria equipe dentro do Nudge',
        'Gere links de afiliação com seu ID Herbalife',
        'Marketing inteligente dentro do App',
        'Relatórios de desempenho da equipe',
      ],
      isAddOn: true,
    ),
  ];

  static Plan getPlanByType(PlanType type) {
    return allPlans.firstWhere((plan) => plan.type == type);
  }

  static Plan get freePlan => allPlans.firstWhere((plan) => plan.type == PlanType.free);
  static Plan get fitPlan => allPlans.firstWhere((plan) => plan.type == PlanType.fit);
  static Plan get personalPlan => allPlans.firstWhere((plan) => plan.type == PlanType.personal);
  static Plan get personalPlusPlan => allPlans.firstWhere((plan) => plan.type == PlanType.personalPlus);
  static Plan get leaderPlan => allPlans.firstWhere((plan) => plan.type == PlanType.leader);
}

