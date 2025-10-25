import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/app_provider.dart';
import '../widgets/calorie_progress_card.dart';
import '../widgets/macro_progress_card.dart';
import '../widgets/water_progress_card.dart';
import '../widgets/today_meals_list.dart';
import '../widgets/motivational_quote.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SaúdeFit'),
        backgroundColor: Colors.green[600],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.pushNamed(context, '/calendar');
            },
            tooltip: 'Calendário',
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
            tooltip: 'Notificações',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
            tooltip: 'Configurações',
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
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

                  // Refeições de Hoje
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Refeições de Hoje',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          // Navegar para adicionar refeição
                          Navigator.pushNamed(context, '/add_meal');
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Adicionar'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.green[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const TodayMealsList(),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              // Já na home
              break;
            case 1:
              Navigator.pushNamed(context, '/meals');
              break;
            case 2:
              Navigator.pushNamed(context, '/drinks');
              break;
            case 3:
              Navigator.pushNamed(context, '/progress');
              break;
            case 4:
              Navigator.pushNamed(context, '/friends');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Refeições',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_drink),
            label: 'Bebidas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Progresso',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Amigos',
          ),
        ],
        selectedItemColor: Colors.green[600],
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
