import 'package:fittrack/features/meals/screens/meals_screen.dart';
import 'package:fittrack/features/workouts/screens/workout_screen.dart';
import 'package:fittrack/screens/dashboard_screen.dart';
import 'package:fittrack/theme/app_colors.dart';
import 'package:fittrack/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    MealsScreen(),
    WorkoutScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: _screens.asMap().entries.map((entry) {
          final index = entry.key;
          final screen = entry.value;
          return AnimatedOpacity(
            opacity: _currentIndex == index ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: IgnorePointer(
              ignoring: _currentIndex != index,
              child: screen,
            ),
          );
        }).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: theme.unselectedWidgetColor.withOpacity(0.4),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedFontSize: AppTextStyles.fontSizeSm,
        unselectedFontSize: AppTextStyles.fontSizeXs,
        iconSize: 28,
        type: BottomNavigationBarType.fixed,
        backgroundColor: theme.colorScheme.surface,
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
      ),
    );
  }
}
