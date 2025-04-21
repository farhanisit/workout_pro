// Core Flutter and Routing Libraries
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Screen imports for route mapping
import 'package:workout_pro/core_screens/screens_/auth_screen.dart';
import 'package:workout_pro/core_screens/screens_/cardioListScreen.dart';
import 'package:workout_pro/core_screens/screens_/fullBodyScreen.dart';
import 'package:workout_pro/core_screens/screens_/home_screen.dart';
import 'package:workout_pro/core_screens/screens_/onboardingScreen.dart';
import 'package:workout_pro/core_screens/screens_/profile_setup_screen.dart';
import 'package:workout_pro/core_screens/screens_/profile_screen.dart';
import 'package:workout_pro/core_screens/screens_/goal_setup_screen.dart';
import 'package:workout_pro/core_screens/screens_/dashboard_screen.dart';
import 'package:workout_pro/core_screens/screens_/bottom_nav_scaffold.dart';
import 'package:workout_pro/core_screens/screens_/edit_goal_screen.dart';
import 'package:workout_pro/core_screens/screens_/create_exercise_screen.dart';
import 'package:workout_pro/core_screens/screens_/progress_screen.dart';
import 'package:workout_pro/core_screens/exercise_list_screen.dart';
import 'package:workout_pro/core_screens/exercise_detail_screen.dart';
import 'package:workout_pro/core_screens/exercise_form_screen.dart';
import 'package:workout_pro/features/display_exercise.dart';
import 'package:workout_pro/model/exercise.dart' as model;

// GoRouter instance to handle navigation across all screens
final GoRouter router = GoRouter(
  initialLocation: '/', // Start at onboarding screen
  errorBuilder: (context, state) => const Scaffold(
    body: Center(child: Text('Page Not Found')),
  ),
  // Redirect logic based on authentication
  redirect: (context, state) async {
    final isAuthenticated = await _checkAuthStatus();
    final location = state.matchedLocation;

    final isOnboarding = location == '/';
    final isAuth = location == '/auth';

    if (!isAuthenticated) {
      // Allow unauthenticated access to onboarding or auth
      if (!isOnboarding && !isAuth) {
        return '/auth';
      }
    } else {
      // Authenticated users shouldn't see onboarding or auth again
      if (isOnboarding || isAuth) {
        return '/main';
      }
    }

    return null;
  },

  /* 
     Define all routes used in the app in the Workout Pro via GoRouter
     and 
     Includes redirection logic and nested navigation
  */
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/main',
      builder: (context, state) => const BottomNavScaffold(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/dash',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/profile-setup',
      builder: (context, state) => const ProfileSetupScreen(),
    ),
    GoRoute(
      path: '/goal-setup',
      builder: (context, state) => const GoalSetupScreen(),
    ),
    GoRoute(
      path: '/edit-goal',
      builder: (context, state) => const EditGoalScreen(),
    ),
    GoRoute(
      path: '/cardio',
      builder: (context, state) => const CardioListScreen(),
    ),
    GoRoute(
      path: '/fullbody',
      builder: (context, state) => const FullBodyScreen(),
    ),
    GoRoute(
      path: '/progress',
      builder: (context, state) => const ProgressScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),

    // Nested routing example for exercises
    GoRoute(
      path: '/exercises',
      builder: (context, state) => const ExerciseListScreen(),
      routes: [
        GoRoute(
          path: 'detail',
          builder: (context, state) {
            final exercise = state.extra as model.Exercise?;
            if (exercise == null) {
              return const Scaffold(
                body: Center(child: Text('No exercise selected.')),
              );
            }
            return ExerciseDetailScreen(exercise: exercise);
          },
        ),
        GoRoute(
          path: 'form',
          builder: (context, state) => const ExerciseFormScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/create-exercise',
      builder: (context, state) => const CreateExerciseScreen(),
    ),

    // Tracker Screen: Displays a single exercise passed via GoRouter's extra
    GoRoute(
      path: '/tracker',
      builder: (context, state) {
        final exercise = state.extra as model.Exercise?;
        if (exercise == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(child: Text('No exercise selected.')),
          );
        }
        return DisplayExercise(exercise: exercise);
      },
    ),
  ],
);

// Utility function to check user auth status
Future<bool> _checkAuthStatus() async {
  await Future.delayed(const Duration(milliseconds: 100)); // Async wait
  return FirebaseAuth.instance.currentUser != null;
}
