import 'package:fittrack/features/meals/models/meals.dart';
import 'package:fittrack/features/meals/providers/meal_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../features/meals/widgets/meal_item.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeaderSection(theme: theme),
              const SizedBox(height: 20),
              ProteinCard(
                current: totalProtein,
                target: targetProtein,
                percentage: proteinPercentage,
              ),
              const SizedBox(height: 12),
              const WorkoutCard(),
              const SizedBox(height: AppSpacing.md),
              _ActionButtonsRow(context: context, theme: theme),
              const SizedBox(height: 20),
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
            const SizedBox(height: AppSpacing.xs),
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
          radius: 20,
          backgroundColor: AppColors.primaryLight,
          child: Icon(Icons.person, color: Colors.white, size: 24),
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
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
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
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
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
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time, color: AppColors.primary, size: 18),
                  const SizedBox(width: AppSpacing.sm),
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
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Row(
                  children: const [
                    Text(
                      "View All",
                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    Icon(Icons.chevron_right, color: AppColors.primary, size: 14),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          if (recentMeals.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
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
                  id: meal.id,
                  name: meal.name,
                  time: timeFormatted,
                  protein: "${meal.protein.toInt()}g",
                  image: meal.emoji,
                );
              },
            ),
          const SizedBox(height: AppSpacing.sm),
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

