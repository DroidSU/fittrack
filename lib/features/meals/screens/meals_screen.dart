import 'package:fittrack/features/meals/providers/meal_notifier.dart';
import 'package:fittrack/features/meals/widgets/meal_item.dart';
import 'package:fittrack/widgets/protein_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/animated_entry.dart';

class MealsScreen extends ConsumerStatefulWidget {
  const MealsScreen({super.key});

  @override
  ConsumerState<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends ConsumerState<MealsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mealsAsync = ref.watch(mealProvider);
    final totalProtein = ref.watch(totalProteinProvider);
    const targetProtein = 150.0;
    final proteinPercentage = (totalProtein / targetProtein).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      floatingActionButton: _CustomFAB(onPressed: () => context.push("/add-meal")),
      body: SafeArea(
        child: mealsAsync.when(
          data: (mealsList) {
            final filteredMeals = mealsList.where((meal) {
              return meal.name.toLowerCase().startsWith(_searchQuery.toLowerCase());
            }).toList().reversed.toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Header Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Meals",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: AppTextStyles.fontWeightBold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              "Track your daily protein intake",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.bar_chart, color: AppColors.primary, size: 28),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // 2. Protein Summary Card
                  ProteinCard(
                    current: totalProtein,
                    target: targetProtein,
                    percentage: proteinPercentage,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // 3. Search & Filter Section
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: "Search meals...",
                              hintStyle: TextStyle(
                                  color: theme.hintColor.withOpacity(0.3),
                                  fontSize: AppTextStyles.fontSizeMd),
                              prefixIcon: Icon(Icons.search,
                                  color: theme.hintColor.withOpacity(0.3),
                                  size: 24),
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 52,
                        width: 52,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
                        ),
                        child: Icon(Icons.tune, color: theme.hintColor.withOpacity(0.5), size: 24),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 4. Meals List Section
                  const _MealSectionHeader(title: "All Logged Meals"),
                  const SizedBox(height: AppSpacing.sm),
                  
                  if (filteredMeals.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: AnimatedEntry(
                          child: Text(
                            _searchQuery.isEmpty ? "No meals logged yet" : "No meals found for '$_searchQuery'",
                            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                          ),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredMeals.length,
                      itemBuilder: (context, index) {
                        final meal = filteredMeals[index];
                        final timeFormatted = DateFormat('h:mm a').format(meal.createdAt);
                        
                        return MealItem(
                          index: index,
                          id: meal.id,
                          name: meal.name,
                          time: timeFormatted,
                          protein: "${meal.protein.toInt()}g",
                          image: meal.emoji,
                          onDelete: () {
                            ref.read(mealProvider.notifier).removeMeal(meal.id);
                          },
                        );
                      },
                    ),

                  const SizedBox(height: 20),
                  // 5. Tip Card
                  _TipCard(percentage: (proteinPercentage * 100).toInt()),
                  const SizedBox(height: 80), // Spacing for FAB
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }
}

class _MealSectionHeader extends StatelessWidget {
  final String title;

  const _MealSectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge
              ?.copyWith(fontWeight: AppTextStyles.fontWeightBold),
        ),
        Row(
          children: [
            Text(
              "Newest",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
              size: 20,
            ),
          ],
        ),
      ],
    );
  }
}

class _TipCard extends StatelessWidget {
  final int percentage;

  const _TipCard({required this.percentage});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const Color greenBg = Color(0xFFF0F9F6);
    const Color greenAccent = Color(0xFF34A853);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: greenBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline, color: greenAccent, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Tip",
                  style: TextStyle(
                    fontWeight: AppTextStyles.fontWeightBold,
                    color: greenAccent,
                    fontSize: AppTextStyles.fontSizeMd,
                  ),
                ),
                Text(
                  "Great job! You're $percentage% towards your daily protein goal.",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomFAB extends StatelessWidget {
  final VoidCallback onPressed;
  const _CustomFAB({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AnimatedEntry(
      offset: const Offset(0, 0.5),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.add, color: Colors.white, size: 32),
              Text(
                "Add Meal",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppTextStyles.fontSizeXs,
                  fontWeight: AppTextStyles.fontWeightBold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
