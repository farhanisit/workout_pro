import 'package:flutter/material.dart'; // Flutter core UI package
import 'package:firebase_auth/firebase_auth.dart'; // Firebase authentication service
import 'package:go_router/go_router.dart'; // Routing system for navigation
import 'package:workout_pro/services/user_service.dart'; // Custom Firestore user operations
import 'package:workout_pro/widgets/primary_button.dart'; // Styled app button widget
import 'package:workout_pro/widgets/custom_input_field.dart'; // Optional reusable input field widget

// AuthenticationScreen: A stateful widget that toggles between Logi and Signup functionality
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  // Creates a mutable state for the screen
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

// _AuthenticationScreenState: Manages from state, authentication logic and view toggle between login/signup
class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController(); // For email input
  final _passwordController = TextEditingController(); // For password input
  final _userService =
      UserService(); // Custom service to handle user data on Firestore

  bool _isLogin = true;
  bool _isLoading = false;
  String? _errorMessage; // To display authentication errors

  // Method ta=hat handles Firebase login or signup depending on _isLogin
  Future<void> _handleAuth() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      UserCredential userCredential;

      if (_isLogin) {
        // Sign in with email and password
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // New user setup
      } else {
        userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        final user = userCredential.user;
        if (user != null) {
          // Save basic user profile to Firestore
          await _userService.createUserProfile(
            uid: user.uid,
            email: user.email ?? '',
            name: user.email!.split('@')[0],
            gender: '',
            goal: '',
          );
        }
      }
      // Navigate to main app after success
      if (mounted) context.go('/main');
    } on FirebaseAuthException catch (e) {
      // Catch and show errors
      setState(() => _errorMessage = e.message ?? "Authentication failed.");
    } catch (_) {
      setState(() => _errorMessage = "Something went wrong.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Build: Builds full login/signup screen UI with email/password form and toggle button
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          _isLogin ? "Login" : "Sign Up",
          style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            // 🏋️ Workout Logo
            Image.asset(
              'assets/images/logo.png',
              height: 100,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.fitness_center, size: 80),
            ),
            // Login/ signup card UI
            const SizedBox(height: 24),
            // Card containing email/password form
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // For Email
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // For Password
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Error message(if any)
                    if (_errorMessage != null)
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),

                    const SizedBox(height: 12),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : PrimaryButton(
                            label: _isLogin ? "Login" : "Sign Up",
                            onPressed: _handleAuth,
                          ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // login/signup toggle
            TextButton(
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin;
                  _errorMessage = null;
                });
              },
              child: Text(
                _isLogin
                    ? "Need an account? Sign up"
                    : "Already have an account? Log in",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/*
AuthScreen:
Handles login and sign-up flows using Firebase Authentication.
Initializes user profiles in Firestore for new accounts.
Provides full UI feedback (error messages, loader, toggle logic).
Serves as the entry point for authenticated user access to the app.
*/
