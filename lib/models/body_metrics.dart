class BodyMetrics {
  final String id;
  final DateTime date;
  final double weight; // em kg
  final double? bodyFatPercentage; // em %
  final double? muscleMass; // em kg
  final Map<String, double> circumferences; // cintura, quadril, braço, etc. em cm
  final double? bmi; // calculado automaticamente
  String? userId;

  BodyMetrics({
    required this.id,
    required this.date,
    required this.weight,
    this.bodyFatPercentage,
    this.muscleMass,
    required this.circumferences,
    this.bmi,
    this.userId,
  });

  double get calculatedBmi => bmi ?? (weight / ((170 / 100) * (170 / 100))); // placeholder height

  BodyMetrics copyWith({
    String? id,
    DateTime? date,
    double? weight,
    double? bodyFatPercentage,
    double? muscleMass,
    Map<String, double>? circumferences,
    double? bmi,
    String? userId,
  }) {
    return BodyMetrics(
      id: id ?? this.id,
      date: date ?? this.date,
      weight: weight ?? this.weight,
      bodyFatPercentage: bodyFatPercentage ?? this.bodyFatPercentage,
      muscleMass: muscleMass ?? this.muscleMass,
      circumferences: circumferences ?? this.circumferences,
      bmi: bmi ?? this.bmi,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'date': date.toIso8601String(),
      'weight': weight,
      'bodyFat': bodyFatPercentage, // Backend usa 'bodyFat'
      if (muscleMass != null) 'muscleMass': muscleMass,
      if (circumferences.isNotEmpty) 'circumferences': circumferences,
      if (bmi != null) 'bmi': bmi,
      if (userId != null) 'userId': userId,
    };
  }

  factory BodyMetrics.fromJson(Map<String, dynamic> json) {
    return BodyMetrics(
      id: json['id'] ?? json['_id'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      weight: (json['weight'] ?? 0).toDouble(),
      bodyFatPercentage: json['bodyFatPercentage'] != null ? (json['bodyFatPercentage'] as num).toDouble() : (json['bodyFat'] != null ? (json['bodyFat'] as num).toDouble() : null),
      muscleMass: json['muscleMass'] != null ? (json['muscleMass'] as num).toDouble() : null,
      circumferences: json['circumferences'] != null 
        ? Map<String, double>.from(json['circumferences']) 
        : (json['notes'] != null ? <String, double>{} : <String, double>{}), // Backend não tem circumferences, apenas notes
      bmi: json['bmi'] != null ? (json['bmi'] as num).toDouble() : null,
      userId: json['userId'],
    );
  }
}
