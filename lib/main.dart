import 'package:firebase_core/firebase_core.dart';
import 'package:fittrack/features/auth/screens/auth_gate.dart';
import 'package:fittrack/features/auth/screens/auth_success_screen.dart';
import 'package:fittrack/features/auth/screens/enter_phone_screen.dart';
import 'package:fittrack/features/auth/screens/otp_verification_screen.dart';
import 'package:fittrack/features/auth/screens/splash_screen.dart';
import 'package:fittrack/features/meals/screens/add_meal_screen.dart';
import 'package:fittrack/features/onboarding/screens/onboarding_flow_screen.dart';
import 'package:fittrack/features/profile/screens/profile_screen.dart';
import 'package:fittrack/features/workouts/screens/add_workout_screen.dart';
import 'package:fittrack/screens/main_screen.dart';
import 'package:fittrack/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Hive.initFlutter();
  await Hive.openBox("mealsBox");
  await Hive.openBox("workoutsBox");

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

final _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const AuthGate(),
    ),
    GoRoute(
      path: '/phone',
      builder: (context, state) => const EnterPhoneScreen(),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) => const OtpVerificationScreen(),
    ),
    GoRoute(
      path: '/auth-success',
      builder: (context, state) => const AuthSuccessScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingFlowScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      path: '/add-meal',
      builder: (context, state) => const AddMealScreen(),
    ),
    GoRoute(
      path: '/add-workout',
      builder: (context, state) => const AddWorkoutScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FitTrack',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
    );
  }
}
