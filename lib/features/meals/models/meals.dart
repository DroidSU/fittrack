class Meals {
  final String id;
  final String name;
  final double protein;
  final String emoji;
  final DateTime createdAt;

  Meals({
    required this.id,
    required this.name,
    required this.protein,
    required this.createdAt,
    this.emoji = '🍽️',
  });

  factory Meals.fromJson(Map<String, dynamic> json) {
    return Meals(
      id: json['id'],
      name: json['name'],
      protein: (json['protein'] as num).toDouble(),
      emoji: json['emoji'] ?? '🍽️',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'protein': protein,
      'emoji': emoji,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
