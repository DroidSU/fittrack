import 'package:fittrack/features/workouts/models/workout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class WorkoutNotifier extends Notifier<List<Workout>> {
  late Box box;

  @override
  List<Workout> build() {
    box = Hive.box("workoutsBox");

    final workoutsList = box.get("workouts", defaultValue: []) as List;

    return workoutsList.map((item) {
      return Workout.fromJson(Map<String, dynamic>.from(item));
    }).toList();
  }

  void addWorkout(Workout workout){
    final updatedState = [...state, workout];
    state = updatedState;

    saveToDB(state);
  }

  void removeWorkout(int index) {
    final updatedState = [...state]..removeAt(index);

    state = updatedState;
  }

  void saveToDB(List<Workout> workoutList) {
    final data = workoutList.map((m) => m.toJson()).toList();
    box.put('workouts', data);
  }


  final workoutsProvider = NotifierProvider<WorkoutNotifier, List<Workout>>(
    WorkoutNotifier.new,
  );

}