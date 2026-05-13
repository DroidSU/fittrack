import 'package:fittrack/features/onboarding/providers/onboarding_provider.dart';
import 'package:fittrack/features/onboarding/widgets/onboarding_button.dart';
import 'package:fittrack/features/onboarding/widgets/onboarding_card_option.dart';
import 'package:fittrack/features/onboarding/widgets/onboarding_number_picker.dart';
import 'package:fittrack/features/onboarding/widgets/onboarding_scaffold.dart';
import 'package:fittrack/theme/app_colors.dart';
import 'package:fittrack/theme/app_radius.dart';
import 'package:fittrack/theme/app_spacing.dart';
import 'package:fittrack/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OnboardingFlowScreen extends ConsumerStatefulWidget {
  const OnboardingFlowScreen({super.key});

  @override
  ConsumerState<OnboardingFlowScreen> createState() => _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends ConsumerState<OnboardingFlowScreen> {
  late PageController _pageController;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    ref.read(onboardingNotifierProvider.notifier).nextStep();
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    ref.read(onboardingNotifierProvider.notifier).previousStep();
  }

  Widget _buildUnitToggle(bool isMetric, VoidCallback onToggle) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.primary;

    return Center(
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ToggleItem(
              text: 'Metric',
              isSelected: isMetric,
              onTap: isMetric ? null : onToggle,
              primaryColor: primaryColor,
            ),
            _ToggleItem(
              text: 'Imperial',
              isSelected: !isMetric,
              onTap: !isMetric ? null : onToggle,
              primaryColor: primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingNotifierProvider);
    final notifier = ref.read(onboardingNotifierProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final showTargetWeight = state.fitnessGoal == 'Lose Fat' || state.fitnessGoal == 'Build Muscle';
    final totalSteps = showTargetWeight ? 9 : 8;
    final progress = (state.currentStep + 1) / totalSteps;

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // STEP 1: Name
          OnboardingScaffold(
            title: 'What should we call you?',
            subtitle: 'This helps personalize your experience.',
            progress: progress,
            child: TextField(
              controller: _nameController,
              onChanged: notifier.updateName,
              textAlign: TextAlign.center,
              style: AppTextStyles.h2,
              decoration: InputDecoration(
                hintText: 'Enter your name',
                hintStyle: AppTextStyles.h2.copyWith(
                  color: (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary).withOpacity(0.3),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: isDark ? AppColors.darkSurface : AppColors.surface,
              ),
            ),
            action: OnboardingButton(
              text: 'Continue',
              onPressed: state.name.isNotEmpty ? _nextPage : null,
            ),
          ),

          // STEP 2: Gender
          OnboardingScaffold(
            title: 'Tell us about yourself',
            subtitle: 'Choose the option that represents you.',
            progress: progress,
            onBack: _previousPage,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OnboardingCardOption(
                  title: 'Male',
                  icon: const Icon(Icons.male_rounded),
                  isSelected: state.gender == 'Male',
                  onTap: () => notifier.updateGender('Male'),
                ),
                const SizedBox(height: AppSpacing.md),
                OnboardingCardOption(
                  title: 'Female',
                  icon: const Icon(Icons.female_rounded),
                  isSelected: state.gender == 'Female',
                  onTap: () => notifier.updateGender('Female'),
                ),
                const SizedBox(height: AppSpacing.md),
                OnboardingCardOption(
                  title: 'Prefer not to say',
                  icon: const Icon(Icons.person_outline_rounded),
                  isSelected: state.gender == 'Prefer not to say',
                  onTap: () => notifier.updateGender('Prefer not to say'),
                ),
              ],
            ).animate().fadeIn().slideY(begin: 0.1, end: 0),
            action: OnboardingButton(
              text: 'Continue',
              onPressed: state.gender.isNotEmpty ? _nextPage : null,
            ),
          ),

          // STEP 3: Age
          OnboardingScaffold(
            title: 'How old are you?',
            subtitle: 'This helps us calculate your needs.',
            progress: progress,
            onBack: _previousPage,
            child: OnboardingNumberPicker(
              minValue: 10,
              maxValue: 100,
              selectedValue: state.age,
              onSelectedItemChanged: notifier.updateAge,
              unit: 'years old',
            ),
            action: OnboardingButton(
              text: 'Continue',
              onPressed: _nextPage,
            ),
          ),

          // STEP 4: Height
          OnboardingScaffold(
            title: "What's your height?",
            subtitle: 'Used for BMI and health calculations.',
            progress: progress,
            onBack: _previousPage,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildUnitToggle(state.isMetric, notifier.toggleUnit),
                const SizedBox(height: AppSpacing.lg),
                OnboardingNumberPicker(
                  minValue: state.isMetric ? 100 : 40,
                  maxValue: state.isMetric ? 250 : 100,
                  selectedValue: state.height.toInt(),
                  onSelectedItemChanged: (val) => notifier.updateHeight(val.toDouble()),
                  unit: state.isMetric ? 'cm' : 'in',
                ),
              ],
            ),
            action: OnboardingButton(
              text: 'Continue',
              onPressed: _nextPage,
            ),
          ),

          // STEP 5: Current Weight
          OnboardingScaffold(
            title: "What's your current weight?",
            subtitle: 'Starting point for your journey.',
            progress: progress,
            onBack: _previousPage,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildUnitToggle(state.isMetric, notifier.toggleUnit),
                const SizedBox(height: AppSpacing.lg),
                OnboardingNumberPicker(
                  minValue: state.isMetric ? 30 : 60,
                  maxValue: state.isMetric ? 250 : 550,
                  selectedValue: state.currentWeight.toInt(),
                  onSelectedItemChanged: (val) => notifier.updateCurrentWeight(val.toDouble()),
                  unit: state.isMetric ? 'kg' : 'lbs',
                ),
              ],
            ),
            action: OnboardingButton(
              text: 'Continue',
              onPressed: _nextPage,
            ),
          ),

          // STEP 6: Fitness Goal
          OnboardingScaffold(
            title: "What's your primary goal?",
            subtitle: 'We will tailor your plan accordingly.',
            progress: progress,
            onBack: _previousPage,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OnboardingCardOption(
                  title: 'Lose Fat',
                  subtitle: 'Burn calories and get leaner',
                  icon: const Text('🔥', style: TextStyle(fontSize: 24)),
                  isSelected: state.fitnessGoal == 'Lose Fat',
                  onTap: () => notifier.updateFitnessGoal('Lose Fat'),
                ),
                const SizedBox(height: AppSpacing.md),
                OnboardingCardOption(
                  title: 'Build Muscle',
                  subtitle: 'Gain strength and size',
                  icon: const Text('💪', style: TextStyle(fontSize: 24)),
                  isSelected: state.fitnessGoal == 'Build Muscle',
                  onTap: () => notifier.updateFitnessGoal('Build Muscle'),
                ),
                const SizedBox(height: AppSpacing.md),
                OnboardingCardOption(
                  title: 'Stay Fit',
                  subtitle: 'Maintain current health',
                  icon: const Text('🏃', style: TextStyle(fontSize: 24)),
                  isSelected: state.fitnessGoal == 'Stay Fit',
                  onTap: () => notifier.updateFitnessGoal('Stay Fit'),
                ),
                const SizedBox(height: AppSpacing.md),
                OnboardingCardOption(
                  title: 'Improve Nutrition',
                  subtitle: 'Better eating habits',
                  icon: const Text('🥗', style: TextStyle(fontSize: 24)),
                  isSelected: state.fitnessGoal == 'Improve Nutrition',
                  onTap: () => notifier.updateFitnessGoal('Improve Nutrition'),
                ),
              ],
            ),
            action: OnboardingButton(
              text: 'Continue',
              onPressed: state.fitnessGoal.isNotEmpty ? _nextPage : null,
            ),
          ),

          // STEP 7: Activity Level
          OnboardingScaffold(
            title: 'How active are you?',
            subtitle: 'Used to calculate your daily energy.',
            progress: progress,
            onBack: _previousPage,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OnboardingCardOption(
                  title: 'Sedentary',
                  subtitle: 'Little or no exercise',
                  isSelected: state.activityLevel == 'Sedentary',
                  onTap: () => notifier.updateActivityLevel('Sedentary'),
                ),
                const SizedBox(height: AppSpacing.md),
                OnboardingCardOption(
                  title: 'Lightly Active',
                  subtitle: 'Light exercise 1-3 days/week',
                  isSelected: state.activityLevel == 'Lightly Active',
                  onTap: () => notifier.updateActivityLevel('Lightly Active'),
                ),
                const SizedBox(height: AppSpacing.md),
                OnboardingCardOption(
                  title: 'Moderately Active',
                  subtitle: 'Moderate exercise 3-5 days/week',
                  isSelected: state.activityLevel == 'Moderately Active',
                  onTap: () => notifier.updateActivityLevel('Moderately Active'),
                ),
                const SizedBox(height: AppSpacing.md),
                OnboardingCardOption(
                  title: 'Very Active',
                  subtitle: 'Hard exercise 6-7 days/week',
                  isSelected: state.activityLevel == 'Very Active',
                  onTap: () => notifier.updateActivityLevel('Very Active'),
                ),
                const SizedBox(height: AppSpacing.md),
                OnboardingCardOption(
                  title: 'Athlete',
                  subtitle: 'Very hard exercise & physical job',
                  isSelected: state.activityLevel == 'Athlete',
                  onTap: () => notifier.updateActivityLevel('Athlete'),
                ),
              ],
            ),
            action: OnboardingButton(
              text: 'Continue',
              onPressed: state.activityLevel.isNotEmpty 
                ? (showTargetWeight ? _nextPage : () => _pageController.animateToPage(8, duration: 400.ms, curve: Curves.easeInOut)) 
                : null,
            ),
          ),

          // STEP 8: Target Weight (Conditional)
          OnboardingScaffold(
            title: "What's your target weight?",
            subtitle: 'Tell us where you want to be.',
            progress: progress,
            onBack: _previousPage,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildUnitToggle(state.isMetric, notifier.toggleUnit),
                const SizedBox(height: AppSpacing.lg),
                OnboardingNumberPicker(
                  minValue: state.isMetric ? 30 : 60,
                  maxValue: state.isMetric ? 250 : 550,
                  selectedValue: (state.targetWeight ?? state.currentWeight).toInt(),
                  onSelectedItemChanged: (val) => notifier.updateTargetWeight(val.toDouble()),
                  unit: state.isMetric ? 'kg' : 'lbs',
                ),
              ],
            ),
            action: OnboardingButton(
              text: 'Continue',
              onPressed: _nextPage,
            ),
          ),

          // FINAL STEP: Completion
          Scaffold(
            backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
            body: SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: (isDark ? AppColors.darkPrimary : AppColors.primary).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check_circle_rounded,
                              size: 80,
                              color: isDark ? AppColors.darkPrimary : AppColors.primary,
                            ),
                          ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                          const SizedBox(height: AppSpacing.xl),
                          Text(
                            'Your plan is ready.',
                            style: AppTextStyles.h1.copyWith(
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                            ),
                          ).animate().fade(delay: 400.ms).slideY(begin: 0.2, end: 0),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            "Let's start building consistency.",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyLg.copyWith(
                              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                            ),
                          ).animate().fade(delay: 600.ms).slideY(begin: 0.2, end: 0),
                          const Spacer(),
                          OnboardingButton(
                            text: 'Enter Dashboard',
                            isLoading: state.isSubmitting,
                            onPressed: () async {
                              await notifier.completeOnboarding();
                              if (context.mounted) {
                                context.go('/home');
                              }
                            },
                          ).animate().fade(delay: 800.ms),
                          const SizedBox(height: AppSpacing.xl),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleItem extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback? onTap;
  final Color primaryColor;

  const _ToggleItem({
    required this.text,
    required this.isSelected,
    this.onTap,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Text(
          text,
          style: AppTextStyles.label.copyWith(
            color: isSelected 
              ? Colors.white 
              : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}
