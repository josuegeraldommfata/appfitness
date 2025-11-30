import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subscription_provider.dart';
import 'ai_chat_screen.dart';
import 'plans_screen.dart';

class CoachScreen extends StatefulWidget {
  const CoachScreen({super.key});

  @override
  State<CoachScreen> createState() => _CoachScreenState();
}

class _CoachScreenState extends State<CoachScreen> {
  String _selectedCategory = 'Todas';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _faqItems = [
    {
      'question': 'Como posso controlar a fome à noite?',
      'subtitle': 'Estratégias para reduzir fome noturna',
      'category': 'Perda de peso',
      'color': Colors.red,
    },
    {
      'question': 'O que fazer quando meu peso estaciona mesmo seguindo o plano?',
      'subtitle': 'Estratégias para platô de peso',
      'category': 'Perda de peso',
      'color': Colors.red,
    },
    {
      'question': 'Como saber se minha meta de peso é saudável?',
      'subtitle': 'Orientações sobre peso ideal',
      'category': 'Perda de peso',
      'color': Colors.red,
    },
    {
      'question': 'Quais são boas fontes de proteína para o meu dia a dia?',
      'subtitle': 'Fontes de proteína simples e acessíveis',
      'category': 'Nutrição',
      'color': Colors.orange,
    },
    {
      'question': 'O que posso fazer quando exagero no fim de semana?',
      'subtitle': 'Como lidar com "jacadas" sem desistir',
      'category': 'Perda de peso',
      'color': Colors.red,
    },
    {
      'question': 'Como montar um prato equilibrado rapidamente?',
      'subtitle': 'Modelo de prato saudável universal',
      'category': 'Nutrição',
      'color': Colors.orange,
    },
    {
      'question': 'Quais doces posso comer sem atrapalhar meu progresso?',
      'subtitle': 'Orientação sobre doces e equilíbrio',
      'category': 'Perda de peso',
      'color': Colors.red,
    },
    {
      'question': 'Se eu ainda não uso Herbalife, vale a pena conhecer?',
      'subtitle': 'Introdução geral à marca para não usuários',
      'category': 'Herbalife',
      'color': Colors.yellow,
    },
    {
      'question': 'Como encaixar refeições livres no meu plano sem perder o foco?',
      'subtitle': 'Estratégia para refeições mais calóricas',
      'category': 'Perda de peso',
      'color': Colors.red,
    },
    {
      'question': 'Como distribuir minha meta de água ao longo do dia?',
      'subtitle': 'Organização da ingestão de água',
      'category': 'Hidratação',
      'color': Colors.lightBlue,
    },
    {
      'question': 'Devo beber mais água em dias de treino?',
      'subtitle': 'Hidratação e atividade física',
      'category': 'Hidratação',
      'color': Colors.lightBlue,
    },
    {
      'question': 'Como me hidratar melhor em dias muito quentes?',
      'subtitle': 'Estratégias para clima quente',
      'category': 'Hidratação',
      'color': Colors.lightBlue,
    },
    {
      'question': 'Como o sono influencia meus resultados de saúde e peso?',
      'subtitle': 'Impacto do sono no emagrecimento e ganho de massa',
      'category': 'Hábitos',
      'color': Colors.green,
    },
    {
      'question': 'Como lidar com comentários negativos sobre minha mudança de hábitos?',
      'subtitle': 'Orientação sobre ambiente social e críticas',
      'category': 'Hábitos',
      'color': Colors.green,
    },
    {
      'question': 'Como posso ajustar minha alimentação em dias muito corridos?',
      'subtitle': 'Estratégias para rotina apertada',
      'category': 'Hábitos',
      'color': Colors.green,
    },
    {
      'question': 'O que é mais importante: calorias ou qualidade dos alimentos?',
      'subtitle': 'Equilíbrio entre quantidade e qualidade',
      'category': 'Nutrição',
      'color': Colors.orange,
    },
    {
      'question': 'Carboidrato à noite atrapalha o emagrecimento?',
      'subtitle': 'Aborda carboidrato no jantar',
      'category': 'Perda de peso',
      'color': Colors.red,
    },
    {
      'question': 'Posso emagrecer sem ir à academia?',
      'subtitle': 'Mostra que movimento vai além de academia',
      'category': 'Perda de peso',
      'color': Colors.red,
    },
    {
      'question': 'Caminhada ajuda mesmo a emagrecer?',
      'subtitle': 'Foca no papel da caminhada',
      'category': 'Perda de peso',
      'color': Colors.red,
    },
    {
      'question': 'Quanto tempo leva para começar a ver resultados no espelho?',
      'subtitle': 'Alinha expectativas de tempo',
      'category': 'Perda de peso',
      'color': Colors.red,
    },
  ];

  final List<String> _categories = [
    'Todas',
    'Hidratação',
    'Perda de peso',
    'Ganho de massa',
    'Hábitos',
    'Nutrição',
    'Herbalife',
    'Geral',
  ];

  List<Map<String, dynamic>> get _filteredItems {
    var items = _faqItems;
    
    // Filtrar por categoria
    if (_selectedCategory != 'Todas') {
      items = items.where((item) => item['category'] == _selectedCategory).toList();
    }
    
    // Filtrar por busca
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      items = items.where((item) {
        return item['question'].toLowerCase().contains(query) ||
               item['subtitle'].toLowerCase().contains(query);
      }).toList();
    }
    
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const Text('FitLife Coach'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Coach Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.chat_bubble_outline,
                    size: 40,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Coach',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Orientações personalizadas',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar orientação...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),
                // Category Filters
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = _selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          backgroundColor: Colors.white,
                          selectedColor: Colors.blue[100],
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.blue[700] : Colors.grey[700],
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // FAQ List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const Text(
                  'Como posso te ajudar?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ..._filteredItems.map((item) => _buildFAQCard(item)),
                const SizedBox(height: 100), // Espaço para o botão flutuante
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Consumer<SubscriptionProvider>(
        builder: (context, subscriptionProvider, child) {
          final hasActiveSubscription = subscriptionProvider.currentSubscription != null &&
              subscriptionProvider.currentSubscription!.isActive;
          
          return FloatingActionButton.extended(
            onPressed: () {
              if (hasActiveSubscription) {
                // Abrir ChatGPT
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AIChatScreen()),
                );
              } else {
                // Redirecionar para planos
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PlansScreen()),
                );
              }
            },
            backgroundColor: Colors.blue[600],
            icon: const Icon(Icons.chat, color: Colors.white),
            label: Text(
              hasActiveSubscription ? 'Converse com Coach' : 'Assine para conversar',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavButton(
                  context,
                  label: 'Dashboard',
                  icon: Icons.dashboard,
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                ),
                _buildNavButton(
                  context,
                  label: 'Coach',
                  icon: Icons.chat,
                  onTap: () {},
                  isActive: true,
                ),
                _buildNavButton(
                  context,
                  label: 'Herbalife',
                  icon: Icons.business,
                  onTap: () {
                    Navigator.pushNamed(context, '/herbalife');
                  },
                ),
                _buildNavButton(
                  context,
                  label: 'Perfil',
                  icon: Icons.person,
                  onTap: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
                _buildNavButton(
                  context,
                  label: 'Compartilhar',
                  icon: Icons.share,
                  onTap: () {
                    Navigator.pushNamed(context, '/share');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFAQCard(Map<String, dynamic> item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          item['question'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            item['subtitle'],
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: (item['color'] as Color).withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            item['category'],
            style: TextStyle(
              color: item['color'],
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onTap: () {
          // TODO: Mostrar resposta detalhada ou abrir chat
        },
      ),
    );
  }

  Widget _buildNavButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? Colors.blue[600] : Colors.grey[600],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isActive ? Colors.blue[600] : Colors.grey[600],
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

