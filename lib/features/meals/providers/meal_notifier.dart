import 'dart:async';

import 'package:fittrack/core/providers/firebase_providers.dart';
import 'package:fittrack/features/auth/providers/auth_provider.dart';
import 'package:fittrack/features/meals/repositories/meals_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../models/meals.dart';

final mealsRepositoryProvider = Provider<MealsRepository>((ref) {
  final authState = ref.watch(authStateProvider);
  final user = authState.value;
  if (user == null) {
    // Return a dummy repo or handle unauthenticated state
    // In this app, the UI should prevent access if not logged in.
    return MealsRepository(
      ref.watch(firestoreProvider),
      Hive.box('mealsBox'),
      'dummy_user',
    );
  }
  return MealsRepository(
    ref.watch(firestoreProvider),
    Hive.box('mealsBox'),
    user.uid,
  );
});

class MealNotifier extends AsyncNotifier<List<Meals>> {
  @override
  FutureOr<List<Meals>> build() async {
    return ref.watch(mealsRepositoryProvider).getMeals();
  }

  Future<void> addMeal(Meals meal) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(mealsRepositoryProvider).addMeal(meal);
      return ref.read(mealsRepositoryProvider).getMeals();
    });
  }

  Future<void> removeMeal(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(mealsRepositoryProvider).deleteMeal(id);
      return ref.read(mealsRepositoryProvider).getMeals();
    });
  }
}

final mealProvider = AsyncNotifierProvider<MealNotifier, List<Meals>>(
  MealNotifier.new,
);

final totalProteinProvider = Provider<double>((ref) {
  final mealsAsync = ref.watch(mealProvider);
  return mealsAsync.maybeWhen(
    data: (meals) => meals.fold(0.0, (sum, meal) => sum + meal.protein),
    orElse: () => 0.0,
  );
});
