class Workout {
  final String id;
  final String name;
  final int durationMinutes;
  final int caloriesBurned;
  final DateTime createdAt;

  Workout({
    required this.id,
    required this.name,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.createdAt,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'] as String,
      name: json['name'] as String,
      durationMinutes: json['durationMinutes'] as int,
      caloriesBurned: json['caloriesBurned'] as int,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'durationMinutes': durationMinutes,
      'caloriesBurned': caloriesBurned,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Workout copyWith({
    String? id,
    String? name,
    int? durationMinutes,
    int? caloriesBurned,
    DateTime? createdAt,
  }) {
    return Workout(
      id: id ?? this.id,
      name: name ?? this.name,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
