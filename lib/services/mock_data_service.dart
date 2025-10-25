import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/user.dart';
import '../models/meal.dart';
import '../models/body_metrics.dart';

class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  // Mock user data
  User? _currentUser;
  User? get currentUser => _currentUser;

  void setCurrentUser(User user) {
    _currentUser = user;
  }

  // Mock foods database
  List<Map<String, dynamic>> _foods = [];

  Future<void> loadMockFoods() async {
    if (_foods.isNotEmpty) return;

    // Simular carregamento de dados mockados
    _foods = [
      {
        'id': '1',
        'name': 'Arroz Branco',
        'calories': 130,
        'protein': 2.7,
        'carbs': 28.0,
        'fat': 0.3,
        'servingSize': 100.0, // g
      },
      {
        'id': '2',
        'name': 'Frango Grelhado',
        'calories': 165,
        'protein': 31.0,
        'carbs': 0.0,
        'fat': 3.6,
        'servingSize': 100.0,
      },
      {
        'id': '3',
        'name': 'Banana',
        'calories': 89,
        'protein': 1.1,
        'carbs': 23.0,
        'fat': 0.3,
        'servingSize': 100.0,
      },
      {
        'id': '4',
        'name': 'Ovo Cozido',
        'calories': 155,
        'protein': 13.0,
        'carbs': 1.1,
        'fat': 11.0,
        'servingSize': 100.0,
      },
      {
        'id': '5',
        'name': 'Salada de Alface',
        'calories': 15,
        'protein': 1.4,
        'carbs': 2.9,
        'fat': 0.2,
        'servingSize': 100.0,
      },
      // Adicionar mais alimentos mockados conforme necessário
    ];
  }

  List<Map<String, dynamic>> searchFoods(String query) {
    return _foods.where((food) =>
        food['name'].toLowerCase().contains(query.toLowerCase())).toList();
  }

  Map<String, dynamic>? getFoodById(String id) {
    return _foods.firstWhere((food) => food['id'] == id, orElse: () => {});
  }

  // Mock meals
  List<Meal> _meals = [];

  List<Meal> getMealsForDate(DateTime date) {
    return _meals.where((meal) =>
        meal.dateTime.year == date.year &&
        meal.dateTime.month == date.month &&
        meal.dateTime.day == date.day).toList();
  }

  void addMeal(Meal meal) {
    _meals.add(meal);
  }

  void updateMeal(Meal meal) {
    final index = _meals.indexWhere((m) => m.id == meal.id);
    if (index != -1) {
      _meals[index] = meal;
    }
  }

  void deleteMeal(String mealId) {
    _meals.removeWhere((meal) => meal.id == mealId);
  }

  // Mock body metrics
  List<BodyMetrics> _bodyMetrics = [];

  List<BodyMetrics> getBodyMetricsHistory() {
    return _bodyMetrics..sort((a, b) => b.date.compareTo(a.date));
  }

  void addBodyMetrics(BodyMetrics metrics) {
    _bodyMetrics.add(metrics);
  }

  // Mock friends
  List<Map<String, dynamic>> _friends = [
    {
      'id': '1',
      'name': 'João Silva',
      'photoUrl': null,
      'caloriesToday': 1850,
      'goalCalories': 2000,
      'rank': 1,
    },
    {
      'id': '2',
      'name': 'Maria Santos',
      'photoUrl': null,
      'caloriesToday': 1750,
      'goalCalories': 1800,
      'rank': 2,
    },
    {
      'id': '3',
      'name': 'Pedro Costa',
      'photoUrl': null,
      'caloriesToday': 1650,
      'goalCalories': 1900,
      'rank': 3,
    },
  ];

  List<Map<String, dynamic>> getFriends() {
    return _friends;
  }

  // Mock water intake
  double _waterIntakeToday = 0.0;
  double get waterIntakeToday => _waterIntakeToday;
  double get waterGoal => 2.0; // 2L por dia

  void addWater(double amount) {
    _waterIntakeToday += amount;
  }

  void resetWaterIntake() {
    _waterIntakeToday = 0.0;
  }

  // Mock suggestions
  List<Map<String, dynamic>> getMealSuggestions(String type) {
    // Retornar sugestões baseadas no tipo de refeição
    switch (type) {
      case 'Café da Manhã':
        return [
          {'name': 'Aveia com Banana', 'calories': 250},
          {'name': 'Ovos Mexidos', 'calories': 180},
        ];
      case 'Almoço':
        return [
          {'name': 'Salada de Frango', 'calories': 350},
          {'name': 'Arroz com Feijão', 'calories': 400},
        ];
      case 'Jantar':
        return [
          {'name': 'Peixe Grelhado', 'calories': 300},
          {'name': 'Salada Verde', 'calories': 150},
        ];
      default:
        return [];
    }
  }

  List<Map<String, dynamic>> getExerciseSuggestions() {
    return [
      {'name': 'Caminhada 30 min', 'calories': 150},
      {'name': 'Corrida 20 min', 'calories': 200},
      {'name': 'Yoga 45 min', 'calories': 100},
    ];
  }
}
