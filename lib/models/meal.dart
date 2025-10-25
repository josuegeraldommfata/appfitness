class Meal {
  final String id;
  final String name;
  final String type; // café da manhã, almoço, jantar, lanche
  final DateTime dateTime;
  final List<FoodItem> foods;
  final int totalCalories;
  final Map<String, double> totalMacros; // proteínas, carboidratos, gorduras

  Meal({
    required this.id,
    required this.name,
    required this.type,
    required this.dateTime,
    required this.foods,
    required this.totalCalories,
    required this.totalMacros,
  });

  Meal copyWith({
    String? id,
    String? name,
    String? type,
    DateTime? dateTime,
    List<FoodItem>? foods,
    int? totalCalories,
    Map<String, double>? totalMacros,
  }) {
    return Meal(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      dateTime: dateTime ?? this.dateTime,
      foods: foods ?? this.foods,
      totalCalories: totalCalories ?? this.totalCalories,
      totalMacros: totalMacros ?? this.totalMacros,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'dateTime': dateTime.toIso8601String(),
      'foods': foods.map((food) => food.toJson()).toList(),
      'totalCalories': totalCalories,
      'totalMacros': totalMacros,
    };
  }

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      dateTime: DateTime.parse(json['dateTime']),
      foods: (json['foods'] as List).map((food) => FoodItem.fromJson(food)).toList(),
      totalCalories: json['totalCalories'],
      totalMacros: Map<String, double>.from(json['totalMacros']),
    );
  }
}

class FoodItem {
  final String id;
  final String name;
  final double quantity; // em gramas
  final int calories;
  final double protein; // em g
  final double carbs; // em g
  final double fat; // em g

  FoodItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
    };
  }

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      calories: json['calories'],
      protein: json['protein'],
      carbs: json['carbs'],
      fat: json['fat'],
    );
  }
}
