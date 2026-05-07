import 'package:fittrack/features/meals/models/meals.dart';
import 'package:fittrack/features/meals/providers/meal_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../theme/app_colors.dart';
import '../widgets/meal_item.dart';
import '../widgets/protein_card.dart';
import '../widgets/workout_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mealsList = ref.watch(mealProvider);
    final totalProtein = ref.watch(totalProteinProvider);
    const targetProtein = 150.0;
    final proteinPercentage = (totalProtein / targetProtein).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeaderSection(theme: theme),
              const SizedBox(height: 24),
              ProteinCard(
                current: totalProtein,
                target: targetProtein,
                percentage: proteinPercentage,
              ),
              const SizedBox(height: 16),
              const WorkoutCard(),
              const SizedBox(height: 20),
              _ActionButtonsRow(context: context, theme: theme),
              const SizedBox(height: 24),
              _RecentMealsSection(theme: theme, totalProtein: totalProtein, mealsList: mealsList),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final ThemeData theme;
  const _HeaderSection({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Good Morning, Sujoy",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Let's hit your goals today 💪",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.primaryLight,
          child: Icon(Icons.person, color: Colors.white, size: 30),
        ),
      ],
    );
  }
}

class _ActionButtonsRow extends StatelessWidget {
  final BuildContext context;
  final ThemeData theme;
  const _ActionButtonsRow({required this.context, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => context.push("/add-meal"),
            icon: const Icon(Icons.add_circle, size: 20),
            label: const Text("Add Meal"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_circle, size: 20),
            label: const Text("Add Workout"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5C6BC0),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }
}

class _RecentMealsSection extends StatelessWidget {
  final ThemeData theme;
  final double totalProtein;
  final List<Meals> mealsList;

  const _RecentMealsSection({required this.theme, required this.totalProtein, required this.mealsList});

  @override
  Widget build(BuildContext context) {
    // Get last 3 meals and reverse them to show newest first
    final recentMeals = mealsList.length > 3
        ? mealsList.sublist(mealsList.length - 3).reversed.toList()
        : mealsList.reversed.toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    "Recent Meals",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Row(
                  children: const [
                    Text(
                      "View All",
                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                    ),
                    Icon(Icons.chevron_right, color: AppColors.primary, size: 16),
                  ],
                ),
              ),
            ],
          ),
          const Divider(),
          if (recentMeals.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "No meals logged today",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                  ),
                ),
              )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentMeals.length,
              itemBuilder: (context, index) {
                final meal = recentMeals[index];
                final timeFormatted = DateFormat('h:mm a').format(meal.createdAt);
                
                return MealItem(
                  name: meal.name,
                  time: timeFormatted,
                  protein: "${meal.protein.toInt()}g",
                  image: meal.emoji,
                );
              },
            ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Total Protein: ",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                ),
              ),
              Text(
                "${totalProtein.toInt()}g",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

