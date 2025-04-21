import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication
import 'package:flutter/material.dart'; // Flutter core UI package
import 'package:workout_pro/auth/login.dart'; // Login Screen navigation
import 'package:workout_pro/transitionanimation.dart'; // Custom transition widget

// Signup: A form screen to register a new user
class Signup extends StatefulWidget {
  const Signup({super.key});
  // Creates a mutable state for the screen
  @override
  State<Signup> createState() => _SignupState();
}

// SignupState – Holds form logic, validation, and Firebase operations
class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>(); // Key to manage form validation

  // Controllers to hold user input values
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;

  // Method to validate form and resigters users via Firebase
  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        // Check if passwords match
        if (_passwordController.text != _confirmPasswordController.text) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Passwords do not match')),
          );
          setState(() => _isLoading = false);
          return;
        }

        // Create user account
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Navigate to login screen on success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup successful! Please login')),
        );
        Navigator.pushReplacement(context, Transit(widget: const Login()));
      } on FirebaseAuthException catch (e) {
        // Show error if signup fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Signup failed')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  // Build Method: Constructs the signup form UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xffFCE38A),
                  Color(0xffEAFFD0),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                const Text(
                  "Create Account",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                // Email input Field
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('@')) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                // Password input Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: "Password",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                // Confirm Password input Field
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline),
                    hintText: "Confirm Password",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Submit Button
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _handleSignup,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 80, vertical: 15),
                        ),
                        child: const Text("Signup"),
                      ),

                const SizedBox(height: 20),

                // Navigation to Login screen
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context, Transit(widget: const Login()));
                      },
                      child: const Text("Login"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
/*
Signup:
This screen handles user registration using Firebase Authentication.
Includes form validation, password match check, error handling, and success redirection to the login screen.
Aesthetic background and modern form layout enhance user experience.
*/
