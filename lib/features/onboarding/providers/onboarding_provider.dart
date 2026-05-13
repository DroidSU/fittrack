import 'package:fittrack/features/profile/models/user_profile.dart';
import 'package:fittrack/features/profile/providers/profile_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingProfileState {
  final String name;
  final String gender;
  final int age;
  final double height;
  final double currentWeight;
  final double? targetWeight;
  final String fitnessGoal;
  final String activityLevel;
  final int currentStep;
  final bool isSubmitting;
  final bool isMetric;

  OnboardingProfileState({
    this.name = '',
    this.gender = '',
    this.age = 25,
    this.height = 170.0,
    this.currentWeight = 70.0,
    this.targetWeight,
    this.fitnessGoal = '',
    this.activityLevel = '',
    this.currentStep = 0,
    this.isSubmitting = false,
    this.isMetric = true,
  });

  OnboardingProfileState copyWith({
    String? name,
    String? gender,
    int? age,
    double? height,
    double? currentWeight,
    double? targetWeight,
    String? fitnessGoal,
    String? activityLevel,
    int? currentStep,
    bool? isSubmitting,
    bool? isMetric,
  }) {
    return OnboardingProfileState(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      height: height ?? this.height,
      currentWeight: currentWeight ?? this.currentWeight,
      targetWeight: targetWeight ?? this.targetWeight,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      activityLevel: activityLevel ?? this.activityLevel,
      currentStep: currentStep ?? this.currentStep,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isMetric: isMetric ?? this.isMetric,
    );
  }

  UserProfile toUserProfile() {
    return UserProfile(
      name: name,
      gender: gender,
      age: age,
      height: height,
      currentWeight: currentWeight,
      targetWeight: targetWeight,
      fitnessGoal: fitnessGoal,
      activityLevel: activityLevel,
      isOnboardingCompleted: true,
    );
  }
}

class OnboardingNotifier extends Notifier<OnboardingProfileState> {
  @override
  OnboardingProfileState build() {
    return OnboardingProfileState();
  }

  void updateName(String name) => state = state.copyWith(name: name);
  void updateGender(String gender) => state = state.copyWith(gender: gender);
  void updateAge(int age) => state = state.copyWith(age: age);
  void updateHeight(double height) => state = state.copyWith(height: height);
  void updateCurrentWeight(double weight) => state = state.copyWith(currentWeight: weight);
  void updateTargetWeight(double? weight) => state = state.copyWith(targetWeight: weight);
  void updateFitnessGoal(String goal) => state = state.copyWith(fitnessGoal: goal);
  void updateActivityLevel(String level) => state = state.copyWith(activityLevel: level);
  void toggleUnit() => state = state.copyWith(isMetric: !state.isMetric);
  
  void nextStep() {
    state = state.copyWith(currentStep: state.currentStep + 1);
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  Future<void> completeOnboarding() async {
    state = state.copyWith(isSubmitting: true);
    final profile = state.toUserProfile();
    await ref.read(profileNotifierProvider.notifier).updateProfile(profile);
    state = state.copyWith(isSubmitting: false);
  }
}

final onboardingNotifierProvider = NotifierProvider<OnboardingNotifier, OnboardingProfileState>(OnboardingNotifier.new);
