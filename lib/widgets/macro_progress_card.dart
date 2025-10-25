import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MacroProgressCard extends StatelessWidget {
  final Map<String, double> currentMacros;
  final Map<String, double> goalMacros;

  const MacroProgressCard({
    super.key,
    required this.currentMacros,
    required this.goalMacros,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Macronutrientes',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildMacroItem(
                  context,
                  'Proteína',
                  currentMacros['protein'] ?? 0,
                  goalMacros['protein'] ?? 0,
                  Colors.blue,
                ),
                const SizedBox(width: 16),
                _buildMacroItem(
                  context,
                  'Carboidratos',
                  currentMacros['carbs'] ?? 0,
                  goalMacros['carbs'] ?? 0,
                  Colors.orange,
                ),
                const SizedBox(width: 16),
                _buildMacroItem(
                  context,
                  'Gordura',
                  currentMacros['fat'] ?? 0,
                  goalMacros['fat'] ?? 0,
                  Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroItem(
    BuildContext context,
    String name,
    double current,
    double goal,
    Color color,
  ) {
    final progress = goal > 0 ? (current / goal).clamp(0.0, 1.0) : 0.0;

    return Expanded(
      child: Column(
        children: [
          Text(
            name,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 60,
            width: 60,
            child: CircularProgressIndicator(
              value: progress,
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              strokeWidth: 6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${current.toInt()}g',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            '/${goal.toInt()}g',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
