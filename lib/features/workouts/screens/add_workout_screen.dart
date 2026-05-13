import 'package:fittrack/features/workouts/models/workout.dart';
import 'package:fittrack/features/workouts/providers/workout_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_styles.dart';
import '../models/workout_type.dart';

class AddWorkoutScreen extends ConsumerStatefulWidget {
  const AddWorkoutScreen({super.key});

  @override
  ConsumerState<AddWorkoutScreen> createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends ConsumerState<AddWorkoutScreen> {
  final TextEditingController _durationController = TextEditingController(
    text: "45",
  );
  final TextEditingController _caloriesController = TextEditingController(
    text: "320",
  );
  final TextEditingController _notesController = TextEditingController();

  WorkoutType _selectedWorkoutType = WorkoutType.pushDay;

  final List<WorkoutType> _quickTypes = [
    WorkoutType.pushDay,
    WorkoutType.pullDay,
    WorkoutType.legDay,
    WorkoutType.hiit,
  ];

  void _showAllWorkoutsDialog(BuildContext context) {
    WorkoutType tempSelected = _selectedWorkoutType;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final theme = Theme.of(context);
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Select Workout Type",
                    style: TextStyle(
                        fontSize: AppTextStyles.fontSizeLg,
                        fontWeight: AppTextStyles.fontWeightBold)),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: WorkoutType.values.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, index) {
                  final type = WorkoutType.values[index];
                  final isSelected = tempSelected == type;
                  return GestureDetector(
                    onTap: () => setDialogState(() => tempSelected = type),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary.withOpacity(0.1) : theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : theme.dividerColor.withOpacity(0.1),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(type.emoji,
                              style: const TextStyle(
                                  fontSize: AppTextStyles.fontSizeXxl)),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            type.displayName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: AppTextStyles.fontSizeXxs,
                              fontWeight: AppTextStyles.fontWeightBold,
                              color: isSelected
                                  ? AppColors.primary
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() => _selectedWorkoutType = tempSelected);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text("Confirm",
                      style: TextStyle(
                          fontWeight: AppTextStyles.fontWeightBold)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _saveWorkout() async {
    final duration = int.tryParse(_durationController.text) ?? 0;
    final calories = int.tryParse(_caloriesController.text) ?? 0;

    if (duration <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid duration")),
      );
      return;
    }

    final workout = Workout(
      id: const Uuid().v1(),
      name: _selectedWorkoutType.displayName,
      type: _selectedWorkoutType,
      durationMinutes: duration,
      caloriesBurned: calories,
      createdAt: DateTime.now(),
    );

    try {
      await ref.read(workoutsProvider.notifier).addWorkout(workout);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving workout: $e")),
        );
      }
    }
  }

  @override
  void dispose() {
    _durationController.dispose();
    _caloriesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final workoutsState = ref.watch(workoutsProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: theme.colorScheme.onSurface,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "Add Workout",
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
              // 1. Header Section
              Text(
                "Log Your Workout 💪",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: AppTextStyles.fontWeightBold,
                  fontSize: AppTextStyles.fontSizeXxl,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                "Track your training and stay consistent.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // 2. Workout Type Section
              Text(
                "Workout Type",
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: AppTextStyles.fontWeightBold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ..._quickTypes.map((type) {
                    final isSelected = _selectedWorkoutType == type;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedWorkoutType = type),
                        child: _TypeCard(
                          emoji: type.emoji,
                          label: type.displayName,
                          isSelected: isSelected,
                        ),
                      ),
                    );
                  }),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _showAllWorkoutsDialog(context),
                      child: const _TypeCard(
                        icon: Icons.grid_view_rounded,
                        label: "More",
                        isSelected: false,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // 3. Stats Section
              Row(
                children: [
                  Expanded(
                    child: _StatInputCard(
                      title: "Duration",
                      controller: _durationController,
                      unit: "min",
                      icon: Icons.access_time_rounded,
                      iconColor: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatInputCard(
                      title: "Calories",
                      controller: _caloriesController,
                      unit: "kcal",
                      icon: Icons.local_fire_department_rounded,
                      iconColor: Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // 5. Notes Section
              Text(
                "Notes (Optional)",
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: AppTextStyles.fontWeightBold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.dividerColor.withOpacity(0.1),
                  ),
                ),
                child: TextField(
                  controller: _notesController,
                  maxLines: 3,
                  style: const TextStyle(fontSize: AppTextStyles.fontSizeSm),
                  decoration: InputDecoration(
                    hintText: "How did today's workout feel?",
                    hintStyle: TextStyle(
                      color: theme.hintColor.withOpacity(0.3),
                      fontSize: AppTextStyles.fontSizeXs,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 6. Motivation Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: AppColors.primary,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Every workout counts towards your goals.",
                        style: TextStyle(
                          color: isDark
                              ? AppColors.primaryLight
                              : AppColors.primary,
                          fontWeight: AppTextStyles.fontWeightMedium,
                          fontSize: AppTextStyles.fontSizeXs,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // 7. Save Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: workoutsState.isLoading ? null : _saveWorkout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: workoutsState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Save Workout",
                          style: TextStyle(
                              fontSize: AppTextStyles.fontSizeSm,
                              fontWeight: AppTextStyles.fontWeightBold),
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

class _TypeCard extends StatelessWidget {
  final String? emoji;
  final IconData? icon;
  final String label;
  final bool isSelected;

  const _TypeCard({
    this.emoji,
    this.icon,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedScale(
      scale: isSelected ? 1.05 : 1.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutBack,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.08) : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : theme.dividerColor.withOpacity(0.1),
            width: isSelected ? 2.0 : 1.5,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ] : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (emoji != null)
              Text(emoji!,
                  style: const TextStyle(fontSize: AppTextStyles.fontSizeXxl))
            else if (icon != null)
              Icon(icon, color: theme.hintColor.withOpacity(0.4), size: 28),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              style: TextStyle(
                fontSize: AppTextStyles.fontSizeXxs,
                fontWeight: AppTextStyles.fontWeightBold,
                color: isSelected
                    ? AppColors.primary
                    : theme.colorScheme.onSurface.withOpacity(0.8),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatInputCard extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final String unit;
  final IconData icon;
  final Color iconColor;

  const _StatInputCard({
    required this.title,
    required this.controller,
    required this.unit,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.hintColor.withOpacity(0.6),
                  fontWeight: AppTextStyles.fontWeightBold,
                ),
              ),
              Icon(icon, color: iconColor, size: 16),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: AppTextStyles.fontWeightBold,
                    color: theme.colorScheme.onSurface,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              const SizedBox(width: 2),
              Text(
                unit,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.hintColor.withOpacity(0.4),
                  fontWeight: AppTextStyles.fontWeightMedium,
                  fontSize: AppTextStyles.fontSizeXxs,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
