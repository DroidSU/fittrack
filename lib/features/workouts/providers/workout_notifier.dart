import 'dart:async';

import 'package:fittrack/core/providers/firebase_providers.dart';
import 'package:fittrack/features/auth/providers/auth_provider.dart';
import 'package:fittrack/features/workouts/models/workout.dart';
import 'package:fittrack/features/workouts/repositories/workouts_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final workoutsRepositoryProvider = Provider<WorkoutsRepository>((ref) {
  final authState = ref.watch(authStateProvider);
  final user = authState.value;
  if (user == null) {
    return WorkoutsRepository(
      ref.watch(firestoreProvider),
      Hive.box('workoutsBox'),
      'dummy_user',
    );
  }
  return WorkoutsRepository(
    ref.watch(firestoreProvider),
    Hive.box('workoutsBox'),
    user.uid,
  );
});

class WorkoutNotifier extends AsyncNotifier<List<Workout>> {
  @override
  FutureOr<List<Workout>> build() async {
    return ref.watch(workoutsRepositoryProvider).getWorkouts();
  }

  Future<void> addWorkout(Workout workout) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(workoutsRepositoryProvider).addWorkout(workout);
      return ref.read(workoutsRepositoryProvider).getWorkouts();
    });
  }

  Future<void> removeWorkout(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(workoutsRepositoryProvider).deleteWorkout(id);
      return ref.read(workoutsRepositoryProvider).getWorkouts();
    });
  }
}

final workoutsProvider = AsyncNotifierProvider<WorkoutNotifier, List<Workout>>(
  WorkoutNotifier.new,
);

final totalCaloriesProvider = Provider<int>((ref) {
  final workoutsAsync = ref.watch(workoutsProvider);
  return workoutsAsync.maybeWhen(
    data: (workouts) => workouts.fold(0, (sum, w) => sum + w.caloriesBurned),
    orElse: () => 0,
  );
});

final totalDurationProvider = Provider<int>((ref) {
  final workoutsAsync = ref.watch(workoutsProvider);
  return workoutsAsync.maybeWhen(
    data: (workouts) => workouts.fold(0, (sum, w) => sum + w.durationMinutes),
    orElse: () => 0,
  );
});

final workoutsCompletedProvider = Provider<int>((ref) {
  final workoutsAsync = ref.watch(workoutsProvider);
  return workoutsAsync.maybeWhen(
    data: (workouts) => workouts.length,
    orElse: () => 0,
  );
});
