class Drink {
  final String id;
  final String name;
  final double amount; // em ml
  final int calories;
  final DateTime dateTime;
  String? userId;

  Drink({
    required this.id,
    required this.name,
    required this.amount,
    required this.calories,
    required this.dateTime,
    this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'name': name,
      'amount': amount,
      'calories': calories,
      'dateTime': dateTime.toIso8601String(),
      if (userId != null) 'userId': userId,
    };
  }

  factory Drink.fromJson(Map<String, dynamic> json) {
    return Drink(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      calories: json['calories'] ?? 0,
      dateTime: DateTime.parse(json['dateTime'] ?? json['date'] ?? DateTime.now().toIso8601String()),
      userId: json['userId'],
    );
  }
}

