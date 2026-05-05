class Meals {
  final String id;
  final String name;
  final double protein;

  // Standard constructor
  Meals({required this.id, required this.name, required this.protein});

  // Factory constructor to create a User from JSON (Map)
  factory Meals.fromJson(Map<String, dynamic> json) {
    return Meals(
      id: json['id'],
      name: json['name'],
      protein: json['protein'],
    );
  }

  // Method to convert a User object back to JSON (Map)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'protein': protein,
    };
  }
}
