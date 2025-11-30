class Challenge {
  final String id;
  final String title;
  final String description;
  final String type; // 'water', 'calories', 'exercise', 'custom'
  final double target;
  final String unit; // 'ml', 'kcal', 'minutes', etc.
  final DateTime startDate;
  final DateTime endDate;
  final String userId;
  final List<String> participants; // User IDs
  final bool isActive;
  final DateTime createdAt;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.target,
    required this.unit,
    required this.startDate,
    required this.endDate,
    required this.userId,
    this.participants = const [],
    this.isActive = true,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'target': target,
      'unit': unit,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'userId': userId,
      'participants': participants,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'] ?? json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? 'custom',
      target: (json['target'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      startDate: DateTime.parse(json['startDate'] ?? DateTime.now().toIso8601String()),
      endDate: DateTime.parse(json['endDate'] ?? DateTime.now().toIso8601String()),
      userId: json['userId'] ?? '',
      participants: List<String>.from(json['participants'] ?? []),
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

