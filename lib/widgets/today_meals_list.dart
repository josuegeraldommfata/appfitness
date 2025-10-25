import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/meal.dart';

class TodayMealsList extends StatelessWidget {
  const TodayMealsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final meals = provider.todayMeals;

        if (meals.isEmpty) {
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Icon(
                    Icons.restaurant_menu,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhuma refeição registrada hoje',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Adicione sua primeira refeição!',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: meals.length,
          itemBuilder: (context, index) {
            final meal = meals[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getMealColor(meal.type),
                  child: Icon(
                    _getMealIcon(meal.type),
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  meal.name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  '${meal.totalCalories} kcal • ${meal.foods.length} alimentos',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // TODO: Navigate to edit meal
                  },
                ),
                onTap: () {
                  _showMealDetails(context, meal);
                },
              ),
            );
          },
        );
      },
    );
  }

  Color _getMealColor(String type) {
    switch (type) {
      case 'Café da Manhã':
        return Colors.orange;
      case 'Almoço':
        return Colors.green;
      case 'Jantar':
        return Colors.blue;
      case 'Lanche':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getMealIcon(String type) {
    switch (type) {
      case 'Café da Manhã':
        return Icons.free_breakfast;
      case 'Almoço':
        return Icons.restaurant;
      case 'Jantar':
        return Icons.dinner_dining;
      case 'Lanche':
        return Icons.cookie;
      default:
        return Icons.restaurant_menu;
    }
  }

  void _showMealDetails(BuildContext context, Meal meal) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: _getMealColor(meal.type),
                    child: Icon(
                      _getMealIcon(meal.type),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meal.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          meal.type,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${meal.totalCalories} kcal',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Alimentos:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: meal.foods.length,
                  itemBuilder: (context, index) {
                    final food = meal.foods[index];
                    return ListTile(
                      title: Text(food.name),
                      subtitle: Text('${food.quantity.toStringAsFixed(0)}g'),
                      trailing: Text('${food.calories} kcal'),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      // TODO: Edit meal
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Editar'),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      // TODO: Delete meal
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text('Excluir'),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
