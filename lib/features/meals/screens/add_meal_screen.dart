import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_styles.dart';
import '../models/meals.dart';
import '../providers/meal_notifier.dart';

class AddMealScreen extends ConsumerStatefulWidget {
  const AddMealScreen({super.key});

  @override
  ConsumerState<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends ConsumerState<AddMealScreen> {
  final _nameController = TextEditingController();
  final _proteinController = TextEditingController();
  
  String _selectedEmoji = "🍽️";
  final List<String> _emojis = ["🍽️", "🍳", "🍗", "🥗", "🥩", "🥛", "🥜", "🐟", "🍎"];

  @override
  void dispose() {
    _nameController.dispose();
    _proteinController.dispose();
    super.dispose();
  }

  void _saveMeal() {
    final name = _nameController.text.trim();
    final protein = double.tryParse(_proteinController.text) ?? 0;

    if (name.isEmpty || protein <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid meal name and protein amount")),
      );
      return;
    }

    final meal = Meals(
      id: const Uuid().v1(),
      name: name,
      protein: protein,
      emoji: _selectedEmoji,
      createdAt: DateTime.now(),
    );

    ref.read(mealProvider.notifier).addMeal(meal);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.colorScheme.onSurface, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "Add Meal",
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: AppTextStyles.fontWeightBold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Text(
                "Log Your Meal 🍽️",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: AppTextStyles.fontWeightBold,
                  fontSize: AppTextStyles.fontSizeXxl,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                "Track your nutrition to reach your goals.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Emoji Selector
              Text(
                "Choose Emoji",
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: AppTextStyles.fontWeightBold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: _emojis.map((emoji) {
                    final isSelected = _selectedEmoji == emoji;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedEmoji = emoji),
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected 
                              ? AppColors.primary 
                              : theme.dividerColor.withOpacity(0.1),
                          ),
                          boxShadow: isSelected ? [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ] : null,
                        ),
                        child: Text(emoji,
                            style: const TextStyle(
                                fontSize: AppTextStyles.fontSizeXl)),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Inputs Section
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Meal Details",
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.hintColor.withOpacity(0.6),
                        fontWeight: AppTextStyles.fontWeightBold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextField(
                      controller: _nameController,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: AppTextStyles.fontWeightBold),
                      decoration: InputDecoration(
                        labelText: "Meal Name",
                        hintText: "e.g. Chicken & Rice",
                        labelStyle: TextStyle(
                            color: theme.hintColor.withOpacity(0.5),
                            fontSize: AppTextStyles.fontSizeXs),
                        border: UnderlineInputBorder(borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.1))),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.1))),
                        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _proteinController,
                      keyboardType: TextInputType.number,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: AppTextStyles.fontWeightBold),
                      decoration: InputDecoration(
                        labelText: "Protein (grams)",
                        hintText: "e.g. 30",
                        labelStyle: TextStyle(
                            color: theme.hintColor.withOpacity(0.5),
                            fontSize: AppTextStyles.fontSizeXs),
                        border: UnderlineInputBorder(borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.1))),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.1))),
                        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixText: "g",
                        suffixStyle: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: AppTextStyles.fontWeightBold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Tip Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb_outline, color: AppColors.primary, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Try to include high-protein foods like eggs, chicken, or lentils.",
                        style: TextStyle(
                          color: isDark ? AppColors.primaryLight : AppColors.primary,
                          fontWeight: AppTextStyles.fontWeightMedium,
                          fontSize: AppTextStyles.fontSizeXs,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _saveMeal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Save Meal",
                    style: TextStyle(
                      fontSize: AppTextStyles.fontSizeSm,
                      fontWeight: AppTextStyles.fontWeightBold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
