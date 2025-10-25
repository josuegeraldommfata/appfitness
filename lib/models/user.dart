class User {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final DateTime birthDate;
  final double height; // em cm
  final double weight; // em kg
  final String bodyType; // ectomorfo, mesomorfo, endomorfo
  final String goal; // perda de peso, ganho muscular, manutenção
  final double targetWeight; // peso alvo
  final int dailyCalorieGoal; // meta calórica diária
  final Map<String, double> macroGoals; // proteínas, carboidratos, gorduras em g

  User({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.birthDate,
    required this.height,
    required this.weight,
    required this.bodyType,
    required this.goal,
    required this.targetWeight,
    required this.dailyCalorieGoal,
    required this.macroGoals,
  });

  int get age => DateTime.now().year - birthDate.year;

  double get bmi => weight / ((height / 100) * (height / 100));

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    DateTime? birthDate,
    double? height,
    double? weight,
    String? bodyType,
    String? goal,
    double? targetWeight,
    int? dailyCalorieGoal,
    Map<String, double>? macroGoals,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      birthDate: birthDate ?? this.birthDate,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      bodyType: bodyType ?? this.bodyType,
      goal: goal ?? this.goal,
      targetWeight: targetWeight ?? this.targetWeight,
      dailyCalorieGoal: dailyCalorieGoal ?? this.dailyCalorieGoal,
      macroGoals: macroGoals ?? this.macroGoals,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'birthDate': birthDate.toIso8601String(),
      'height': height,
      'weight': weight,
      'bodyType': bodyType,
      'goal': goal,
      'targetWeight': targetWeight,
      'dailyCalorieGoal': dailyCalorieGoal,
      'macroGoals': macroGoals,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      birthDate: DateTime.parse(json['birthDate']),
      height: json['height'],
      weight: json['weight'],
      bodyType: json['bodyType'],
      goal: json['goal'],
      targetWeight: json['targetWeight'],
      dailyCalorieGoal: json['dailyCalorieGoal'],
      macroGoals: Map<String, double>.from(json['macroGoals']),
    );
  }
}
