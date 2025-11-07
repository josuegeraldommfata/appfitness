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
      'id': id,
      'date': date.toIso8601String(),
      'weight': weight,
      'bodyFatPercentage': bodyFatPercentage,
      'muscleMass': muscleMass,
      'circumferences': circumferences,
      'bmi': bmi,
      'userId': userId,
    };
  }

  factory BodyMetrics.fromJson(Map<String, dynamic> json) {
    return BodyMetrics(
      id: json['id'],
      date: DateTime.parse(json['date']),
      weight: json['weight'],
      bodyFatPercentage: json['bodyFatPercentage'],
      muscleMass: json['muscleMass'],
      circumferences: Map<String, double>.from(json['circumferences']),
      bmi: json['bmi'],
      userId: json['userId'],
    );
  }
}
