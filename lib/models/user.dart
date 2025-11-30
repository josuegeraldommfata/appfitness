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
  final String role; // 'user' or 'admin'
  final String? herbalifeId; // ID Herbalife para plano Fit
  final String? currentPlan; // PlanType name
  final String? referralCode; // Código único de referência
  final String? referredBy; // ID do usuário que indicou (referralCode do indicador)

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
    this.role = 'user',
    this.herbalifeId,
    this.currentPlan,
    this.referralCode,
    this.referredBy,
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
    String? role,
    String? herbalifeId,
    String? currentPlan,
    String? referralCode,
    String? referredBy,
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
      role: role ?? this.role,
      herbalifeId: herbalifeId ?? this.herbalifeId,
      currentPlan: currentPlan ?? this.currentPlan,
      referralCode: referralCode ?? this.referralCode,
      referredBy: referredBy ?? this.referredBy,
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
      'role': role,
      'herbalifeId': herbalifeId,
      'currentPlan': currentPlan,
      'referralCode': referralCode,
      'referredBy': referredBy,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photoUrl'],
      birthDate: json['birthDate'] != null 
          ? (json['birthDate'] is String 
              ? DateTime.parse(json['birthDate']) 
              : (json['birthDate'] as dynamic).toDate())
          : DateTime.now(),
      height: (json['height'] ?? 0).toDouble(),
      weight: (json['weight'] ?? 0).toDouble(),
      bodyType: json['bodyType'] ?? 'mesomorfo',
      goal: json['goal'] ?? 'manutenção',
      targetWeight: (json['targetWeight'] ?? 0).toDouble(),
      dailyCalorieGoal: json['dailyCalorieGoal'] ?? 2000,
      macroGoals: json['macroGoals'] != null 
          ? Map<String, double>.from(json['macroGoals'].map((key, value) => MapEntry(key, (value ?? 0).toDouble())))
          : {'protein': 150.0, 'carbs': 200.0, 'fat': 65.0},
      role: json['role'] ?? 'user',
      herbalifeId: json['herbalifeId'],
      currentPlan: json['currentPlan'],
      referralCode: json['referralCode'],
      referredBy: json['referredBy'],
    );
  }
}
