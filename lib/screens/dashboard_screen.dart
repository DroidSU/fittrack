import 'package:fittrack/features/meals/providers/meal_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../widgets/meal_item.dart';
import '../widgets/protein_card.dart';
import '../widgets/workout_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final totalProtein = ref.watch(totalProteinProvider);
    const targetProtein = 150.0;
    final proteinPercentage = (totalProtein / targetProtein).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: Colors.white,
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
              _RecentMealsSection(theme: theme, totalProtein: totalProtein),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _BottomNavBar(theme: theme),
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
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Let's hit your goals today 💪",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const CircleAvatar(
          radius: 24,
          backgroundColor: Color(0xFFE8EAF6),
          child: Icon(Icons.person, color: AppColors.primary, size: 30),
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
  const _RecentMealsSection({required this.theme, required this.totalProtein});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
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
                      color: Colors.black,
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
          const MealItem(
            name: "Oats with Whey",
            time: "7:30 AM",
            protein: "25g",
            image: "🥣",
          ),
          const MealItem(
            name: "Grilled Chicken",
            time: "1:15 PM",
            protein: "35g",
            image: "🍗",
          ),
          const MealItem(
            name: "Paneer Curry",
            time: "7:45 PM",
            protein: "20g",
            image: "🥘",
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Total Protein: ",
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
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

class _BottomNavBar extends StatelessWidget {
  final ThemeData theme;
  const _BottomNavBar({required this.theme});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey[400],
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.soup_kitchen_rounded),
          label: 'Meals',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center_rounded),
          label: 'Workouts',
        ),
      ],
    );
  }
}
