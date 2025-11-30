import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/calorie_progress_card.dart';
import '../widgets/macro_progress_card.dart';
import '../widgets/water_progress_card.dart';
import '../widgets/today_meals_list.dart';
import '../widgets/motivational_quote.dart';
import '../widgets/herbalife_section.dart';
import '../widgets/share_app_modal.dart';
import '../models/meal.dart';
import '../models/drink.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFE3F2FD), // Azul claro similar ao print
          appBar: AppBar(
            title: const Text('FitLife Coach'),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          body: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () => provider.loadTodayData(),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Saudação
                        Text(
                          'Olá, ${provider.currentUser?.name.split(' ').first ?? 'Usuário'}!',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const MotivationalQuote(),
                        const SizedBox(height: 24),

                        // Progresso Calórico
                        CalorieProgressCard(
                          current: provider.todayTotalCalories,
                          goal: provider.currentUser?.dailyCalorieGoal ?? 2000,
                          progress: provider.calorieProgress,
                        ),
                        const SizedBox(height: 16),

                        // Macronutrientes
                        MacroProgressCard(
                          currentMacros: provider.todayTotalMacros,
                          goalMacros: provider.currentUser?.macroGoals ?? {},
                        ),
                        const SizedBox(height: 16),

                        // Consumo de Água
                        WaterProgressCard(
                          current: provider.waterIntake,
                          goal: provider.waterGoal,
                          progress: provider.waterProgress,
                          onAddWater: (amount) => provider.addWater(amount),
                        ),
                        const SizedBox(height: 24),

                        // Minhas Refeições
                        Text(
                          'Minhas Refeições',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.1,
                          children: [
                            _buildMealCard(
                              context,
                              title: 'Café da manhã',
                              icon: Icons.free_breakfast,
                              color: Colors.orange[100]!,
                              iconColor: Colors.orange[700]!,
                              onTap: () => _navigateToAddMeal(context, 'Café da Manhã'),
                            ),
                            _buildMealCard(
                              context,
                              title: 'Lanche da manhã',
                              icon: Icons.apple,
                              color: Colors.green[100]!,
                              iconColor: Colors.green[700]!,
                              onTap: () => _navigateToAddMeal(context, 'Lanche'),
                            ),
                            _buildMealCard(
                              context,
                              title: 'Almoço',
                              icon: Icons.restaurant,
                              color: Colors.purple[100]!,
                              iconColor: Colors.purple[700]!,
                              onTap: () => _navigateToAddMeal(context, 'Almoço'),
                            ),
                            _buildMealCard(
                              context,
                              title: 'Lanche da tarde',
                              icon: Icons.local_drink,
                              color: Colors.pink[100]!,
                              iconColor: Colors.pink[700]!,
                              onTap: () => _navigateToAddMeal(context, 'Lanche'),
                            ),
                            _buildMealCard(
                              context,
                              title: 'Jantar',
                              icon: Icons.dinner_dining,
                              color: Colors.blue[100]!,
                              iconColor: Colors.blue[700]!,
                              onTap: () => _navigateToAddMeal(context, 'Jantar'),
                            ),
                            _buildMealCard(
                              context,
                              title: 'Ceia',
                              icon: Icons.local_cafe,
                              color: Colors.grey[200]!,
                              iconColor: Colors.grey[700]!,
                              onTap: () => _navigateToAddMeal(context, 'Lanche'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Refeições Adicionadas - SEMPRE MOSTRAR
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Refeições Adicionadas',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: provider.todayMeals.isNotEmpty ? Colors.green[100] : Colors.grey[200],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${provider.todayMeals.length}',
                                      style: TextStyle(
                                        color: provider.todayMeals.isNotEmpty ? Colors.green[800] : Colors.grey[600],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              if (provider.todayMeals.isEmpty)
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Column(
                                      children: [
                                        Icon(Icons.restaurant_menu, size: 48, color: Colors.grey[400]),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Nenhuma refeição adicionada hoje',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              else
                                const TodayMealsList(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Bebidas
                        Text(
                          'Bebidas',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/add_drink');
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Icon(Icons.local_drink, size: 40, color: Colors.blue[600]),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Adicionar Bebida',
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Registre suas bebidas do dia',
                                          style: TextStyle(color: Colors.grey[600]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward_ios, color: Colors.grey[400]),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Bebidas Adicionadas - SEMPRE MOSTRAR
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Bebidas Adicionadas',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: provider.todayDrinks.isNotEmpty ? Colors.blue[100] : Colors.grey[200],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${provider.todayDrinks.length}',
                                      style: TextStyle(
                                        color: provider.todayDrinks.isNotEmpty ? Colors.blue[800] : Colors.grey[600],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              if (provider.todayDrinks.isEmpty)
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Column(
                                      children: [
                                        Icon(Icons.local_drink, size: 48, color: Colors.grey[400]),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Nenhuma bebida adicionada hoje',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              else
                                _buildTodayDrinksList(provider.todayDrinks),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
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
                      isActive: true,
                    ),
                    _buildNavButton(
                      context,
                      label: 'Coach',
                      icon: Icons.chat,
                      onTap: () {
                        Navigator.pushNamed(context, '/coach');
                      },
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
      },
    );
  }

  Widget _buildTodayDrinksList(List<Drink> drinks) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: drinks.length,
      itemBuilder: (context, index) {
        final drink = drinks[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Icon(
                Icons.local_drink,
                color: Colors.blue[700],
              ),
            ),
            title: Text(
              drink.name,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              '${(drink.amount / 1000).toStringAsFixed(1)}L • ${drink.calories} kcal',
              style: TextStyle(color: Colors.grey[600]),
            ),
            trailing: Text(
              '${drink.calories} kcal',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue[600],
              ),
            ),
          ),
        );
      },
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

  Widget _buildMealCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: iconColor),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: iconColor,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  minimumSize: const Size(0, 28),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Adicionar refeição',
                  style: TextStyle(fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToAddMeal(BuildContext context, String mealType) {
    Navigator.pushNamed(
      context,
      '/add_meal',
      arguments: mealType,
    );
  }
}
