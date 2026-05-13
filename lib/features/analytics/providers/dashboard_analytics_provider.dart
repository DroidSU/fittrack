import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../meals/providers/meal_notifier.dart';
import '../../workouts/models/workout_type.dart';
import '../../workouts/providers/workout_notifier.dart';
import '../models/dashboard_insight.dart';

final weeklyProteinIntakeProvider = Provider<List<double>>((ref) {
  final mealsAsync = ref.watch(mealProvider);
  return mealsAsync.maybeWhen(
    data: (meals) {
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      
      final weeklyData = List.generate(7, (index) {
        final day = startOfWeek.add(Duration(days: index));
        return meals
            .where((m) =>
                m.createdAt.year == day.year &&
                m.createdAt.month == day.month &&
                m.createdAt.day == day.day)
            .fold(0.0, (sum, m) => sum + m.protein);
      });
      return weeklyData;
    },
    orElse: () => List.filled(7, 0.0),
  );
});

final dashboardStreakProvider = Provider<int>((ref) {
  final mealsAsync = ref.watch(mealProvider);
  final workoutsAsync = ref.watch(workoutsProvider);
  
  final meals = mealsAsync.value ?? [];
  final workouts = workoutsAsync.value ?? [];
  
  final allActivityDates = {
    ...meals.map((m) => DateTime(m.createdAt.year, m.createdAt.month, m.createdAt.day)),
    ...workouts.map((w) => DateTime(w.createdAt.year, w.createdAt.month, w.createdAt.day)),
  }.toList()..sort((a, b) => b.compareTo(a));

  if (allActivityDates.isEmpty) return 0;
  
  int streak = 0;
  DateTime today = DateTime.now();
  DateTime currentCheck = DateTime(today.year, today.month, today.day);
  
  if (allActivityDates.first.isBefore(currentCheck.subtract(const Duration(days: 1)))) {
    return 0;
  }

  for (final date in allActivityDates) {
    if (date == currentCheck) {
      streak++;
      currentCheck = currentCheck.subtract(const Duration(days: 1));
    } else if (date.isBefore(currentCheck)) {
      break;
    }
  }
  
  return streak;
});

final weeklyGoalProgressProvider = Provider<double>((ref) {
  final weeklyData = ref.watch(weeklyProteinIntakeProvider);
  const targetProtein = 150.0;
  
  final metDays = weeklyData.where((protein) => protein >= targetProtein).length;
  return metDays / 7.0;
});

final averageProteinProvider = Provider<double>((ref) {
  final mealsAsync = ref.watch(mealProvider);
  final meals = mealsAsync.value ?? [];
  if (meals.isEmpty) return 0;
  final days = {
    ...meals.map((m) => DateTime(m.createdAt.year, m.createdAt.month, m.createdAt.day))
  }.length;
  return ref.read(totalProteinProvider) / (days > 0 ? days : 1);
});

final dashboardInsightsProvider = Provider<List<DashboardInsight>>((ref) {
  final mealsAsync = ref.watch(mealProvider);
  final workoutsAsync = ref.watch(workoutsProvider);
  final avgProtein = ref.watch(averageProteinProvider);
  
  final meals = mealsAsync.value ?? [];
  final workouts = workoutsAsync.value ?? [];
  
  double maxProtein = 0;
  if (meals.isNotEmpty) {
    final proteinByDay = <DateTime, double>{};
    for (final meal in meals) {
      final day = DateTime(meal.createdAt.year, meal.createdAt.month, meal.createdAt.day);
      proteinByDay[day] = (proteinByDay[day] ?? 0) + meal.protein;
    }
    maxProtein = proteinByDay.values.fold(0, (max, v) => v > max ? v : max);
  }

  String mostFreqWorkout = "None";
  if (workouts.isNotEmpty) {
    final counts = <WorkoutType, int>{};
    for (final w in workouts) {
      counts[w.type] = (counts[w.type] ?? 0) + 1;
    }
    mostFreqWorkout = counts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key
        .displayName;
  }

  return [
    DashboardInsight(
      emoji: "🚀",
      title: "Highest Protein Day",
      value: "${maxProtein.toInt()}g",
      subtitle: "Peak performance",
    ),
    DashboardInsight(
      emoji: "📊",
      title: "Average Daily Protein",
      value: "${avgProtein.toInt()}g",
      subtitle: "Consistency is key",
    ),
    DashboardInsight(
      emoji: "⚡",
      title: "Most Frequent Workout",
      value: mostFreqWorkout,
      subtitle: "Your specialty",
    ),
  ];
});
