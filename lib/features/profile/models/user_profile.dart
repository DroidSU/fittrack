class UserProfile {
  final String name;
  final String gender;
  final int age;
  final double height;
  final double currentWeight;
  final double? targetWeight;
  final String fitnessGoal;
  final String activityLevel;
  final String? profileImageUrl;
  final bool isOnboardingCompleted;

  UserProfile({
    required this.name,
    required this.gender,
    required this.age,
    required this.height,
    required this.currentWeight,
    this.targetWeight,
    required this.fitnessGoal,
    required this.activityLevel,
    this.profileImageUrl,
    this.isOnboardingCompleted = false,
  });

  UserProfile copyWith({
    String? name,
    String? gender,
    int? age,
    double? height,
    double? currentWeight,
    double? targetWeight,
    String? fitnessGoal,
    String? activityLevel,
    String? profileImageUrl,
    bool? isOnboardingCompleted,
  }) {
    return UserProfile(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      height: height ?? this.height,
      currentWeight: currentWeight ?? this.currentWeight,
      targetWeight: targetWeight ?? this.targetWeight,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      activityLevel: activityLevel ?? this.activityLevel,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isOnboardingCompleted:
          isOnboardingCompleted ?? this.isOnboardingCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'gender': gender,
      'age': age,
      'height': height,
      'currentWeight': currentWeight,
      'targetWeight': targetWeight,
      'fitnessGoal': fitnessGoal,
      'activityLevel': activityLevel,
      'profileImageUrl': profileImageUrl,
      'isOnboardingCompleted': isOnboardingCompleted,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'] ?? '',
      gender: map['gender'] ?? '',
      age: map['age']?.toInt() ?? 0,
      height: map['height']?.toDouble() ?? 0.0,
      currentWeight: map['currentWeight']?.toDouble() ?? 0.0,
      targetWeight: map['targetWeight']?.toDouble(),
      fitnessGoal: map['fitnessGoal'] ?? '',
      activityLevel: map['activityLevel'] ?? '',
      profileImageUrl: map['profileImageUrl'],
      isOnboardingCompleted: map['isOnboardingCompleted'] ?? false,
    );
  }

  factory UserProfile.empty() {
    return UserProfile(
      name: '',
      gender: '',
      age: 25,
      height: 170,
      currentWeight: 70,
      fitnessGoal: '',
      activityLevel: '',
    );
  }
}
