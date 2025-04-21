// Flutter and Dart core packages
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Firebase packages for backend and authentication
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// State management and development tools
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';

// Project-Specific imports
import 'firebase_options.dart';
import 'app_router.dart';
import 'package:workout_pro/theme/theme.dart';
import 'package:workout_pro/theme/theme_provider.dart';

// Entry point for the app
void main() async {
  // Ensure widgets are fully bound before initializing Firebase or using async features
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: DefaultFirebaseOptions
          .currentPlatform); // Firebase initialization with platform specific config

  // App starts with theme and device preview support
  runApp(
    ChangeNotifierProvider(
      create: (_) =>
          ThemeProvider(), // Makes light/Dark mode accessible throughout app.
      child: DevicePreview(
        enabled:
            !kReleaseMode, // To be enable in debug and skip in production mode
        builder: (context) => const MyApp(), // Entry Widget for app UI
      ),
    ),
  );
}

// Root Widget of the app
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Main app state class
  bool _loading = true; // Loading spinner before auth is done

  @override
  void initState() {
    super.initState();

    // Listens for authentication changes(Login/logout)
    //Used to determine when to load the app UI
    FirebaseAuth.instance.authStateChanges().listen((_) {
      setState(() {
        _loading = false; // Stops loading when auth state is received
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider =
        Provider.of<ThemeProvider>(context); // Gets current theme mode

    if (_loading) {
      //  Show loading spinner while checking Firebase auth state
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()), // Spinner UI - // Displays a loading spinner centered on the screen
        ),
      );
    }
    // Full app build after auth state is resolved
    return MaterialApp.router(
      locale: DevicePreview.locale(context), // ✅
      builder: DevicePreview.appBuilder, // ✅ Wrap app with DevicePreview
      title: 'Workout Pro', // Name of the app
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.currentTheme, // Choses between Light/ dark theme
      theme: appLightTheme, // Light theme File
      darkTheme: appDarkTheme, // Dark theme file
      routerConfig: router, // Defines routes and navigation logic for the app
    );
  }
}
