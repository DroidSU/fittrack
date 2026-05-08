import 'package:fittrack/features/workouts/models/workout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class WorkoutNotifier extends Notifier<List<Workout>> {
  late Box box;

  @override
  List<Workout> build() {
    box = Hive.box("workoutsBox");

    final workoutsData = box.get("workouts", defaultValue: []) as List;

    return workoutsData.map((item) {
      return Workout.fromJson(Map<String, dynamic>.from(item));
    }).toList();
  }

  void addWorkout(Workout workout) {
    final updatedState = [...state, workout];
    state = updatedState;

    _saveToDb(updatedState);
  }

  void removeWorkout(int index) {
    final updatedState = [...state]..removeAt(index);
    state = updatedState;

    _saveToDb(updatedState);
  }

  int get totalCalories {
    return state.fold(0, (sum, workout) => sum + workout.caloriesBurned);
  }

  int get totalDuration {
    return state.fold(0, (sum, workout) => sum + workout.durationMinutes);
  }

  int get workoutsCompleted {
    return state.length;
  }

  void _saveToDb(List<Workout> workouts) {
    final data = workouts.map((w) => w.toJson()).toList();
    box.put('workouts', data);
  }
}

final workoutsProvider = NotifierProvider<WorkoutNotifier, List<Workout>>(
  WorkoutNotifier.new,
);

final totalCaloriesProvider = Provider<int>((ref) {
  ref.watch(workoutsProvider);
  return ref.read(workoutsProvider.notifier).totalCalories;
});

final totalDurationProvider = Provider<int>((ref) {
  ref.watch(workoutsProvider);
  return ref.read(workoutsProvider.notifier).totalDuration;
});

final workoutsCompletedProvider = Provider<int>((ref) {
  ref.watch(workoutsProvider);
  return ref.read(workoutsProvider.notifier).workoutsCompleted;
});
