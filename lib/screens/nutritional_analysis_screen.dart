import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/app_provider.dart';

class NutritionalAnalysisScreen extends StatelessWidget {
  const NutritionalAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final totalCalories = provider.todayTotalCalories;
        final totalMacros = provider.todayTotalMacros;
        final user = provider.currentUser;

        final calorieGoal = user?.dailyCalorieGoal ?? 2000;
        final proteinGoal = user?.macroGoals['protein'] ?? 120.0;
        final carbsGoal = user?.macroGoals['carbs'] ?? 180.0;
        final fatGoal = user?.macroGoals['fat'] ?? 60.0;

        final proteinCurrent = totalMacros['protein'] ?? 0.0;
        final carbsCurrent = totalMacros['carbs'] ?? 0.0;
        final fatCurrent = totalMacros['fat'] ?? 0.0;

        // Calculate percentages for pie chart
        final totalMacroGrams = proteinCurrent + carbsCurrent + fatCurrent;
        final proteinPercent = totalMacroGrams > 0 ? (proteinCurrent / totalMacroGrams) : 0.0;
        final carbsPercent = totalMacroGrams > 0 ? (carbsCurrent / totalMacroGrams) : 0.0;
        final fatPercent = totalMacroGrams > 0 ? (fatCurrent / totalMacroGrams) : 0.0;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Análise Nutricional'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Distribuição de Macronutrientes
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Distribuição de Macronutrientes',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                  value: proteinCurrent,
                                  title: '${(proteinPercent * 100).toStringAsFixed(1)}%',
                                  color: Colors.blue,
                                  radius: 80,
                                ),
                                PieChartSectionData(
                                  value: carbsCurrent,
                                  title: '${(carbsPercent * 100).toStringAsFixed(1)}%',
                                  color: Colors.orange,
                                  radius: 80,
                                ),
                                PieChartSectionData(
                                  value: fatCurrent,
                                  title: '${(fatPercent * 100).toStringAsFixed(1)}%',
                                  color: Colors.red,
                                  radius: 80,
                                ),
                              ],
                              sectionsSpace: 2,
                              centerSpaceRadius: 40,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Legend
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildLegendItem('Proteína', Colors.blue),
                            _buildLegendItem('Carboidratos', Colors.orange),
                            _buildLegendItem('Gorduras', Colors.red),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Progresso das Metas
                const Text(
                  'Progresso das Metas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Calorias
                _buildGoalProgressCard(
                  context,
                  icon: Icons.local_fire_department,
                  label: 'Calorias',
                  current: totalCalories.toDouble(),
                  goal: calorieGoal.toDouble(),
                  unit: 'kcal',
                ),

                const SizedBox(height: 12),

                // Proteína
                _buildGoalProgressCard(
                  context,
                  icon: Icons.fitness_center,
                  label: 'Proteína',
                  current: proteinCurrent,
                  goal: proteinGoal,
                  unit: 'g',
                ),

                const SizedBox(height: 12),

                // Carboidratos
                _buildGoalProgressCard(
                  context,
                  icon: Icons.bakery_dining,
                  label: 'Carboidratos',
                  current: carbsCurrent,
                  goal: carbsGoal,
                  unit: 'g',
                ),

                const SizedBox(height: 12),

                // Gorduras
                _buildGoalProgressCard(
                  context,
                  icon: Icons.water_drop,
                  label: 'Gorduras',
                  current: fatCurrent,
                  goal: fatGoal,
                  unit: 'g',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildGoalProgressCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required double current,
    required double goal,
    required String unit,
  }) {
    final progress = goal > 0 ? (current / goal).clamp(0.0, 1.0) : 0.0;
    final progressPercent = (progress * 100).toStringAsFixed(1);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.green[600]),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '$current / $goal $unit',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                progress > 1.0 ? Colors.red : Colors.green[600]!,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$progressPercent% da meta',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

