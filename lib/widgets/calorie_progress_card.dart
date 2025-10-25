import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CalorieProgressCard extends StatelessWidget {
  final int current;
  final int goal;
  final double progress;

  const CalorieProgressCard({
    super.key,
    required this.current,
    required this.goal,
    required this.progress,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Calorias Hoje',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
                Text(
                  '$current / $goal kcal',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearPercentIndicator(
              lineHeight: 8.0,
              percent: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.grey[300]!,
              progressColor: progress > 1.0 ? Colors.red : Colors.green[600],
              barRadius: const Radius.circular(4),
            ),
            const SizedBox(height: 8),
            Text(
              progress > 1.0
                  ? 'Meta excedida! (${(progress * 100).toInt()}%)'
                  : 'Faltam ${(goal - current)} kcal para a meta',
              style: TextStyle(
                color: progress > 1.0 ? Colors.red : Colors.green[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
