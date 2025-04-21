import 'package:flutter/material.dart'; // Flutter core UI package
import 'package:workout_pro/main.dart' as main; // Optional: If needed elsewhere
import 'package:workout_pro/transitionanimation.dart'; // For animated screen transitions
import 'package:workout_pro/services/auth_service.dart'; // Service handling Firebase login logic
import 'package:workout_pro/core_screens/screens_/home_screen.dart'; // Navigates to home after successful login

// Login – Entry point screen for existing users to log in
class Login extends StatefulWidget {
  const Login({super.key});
  // Creates a mutable state for the screen
  @override
  State<Login> createState() => _LoginState();
}

// Class: LoginState – Manages input, validation and login flow
class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>(); // Tracks form validation state

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false; // Loading state for login operation

  // Method to Validate form and attempts sign-in via Authentication Service
  void _loginUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      final auth = AuthService();
      final user = await auth.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      setState(() => isLoading = false);

      if (user != null) {
        // Redirect to Home on successful login
        Navigator.pushReplacement(
          context,
          Transit(widget: HomeScreen()),
        );
      } else {
        // Shows error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login failed. Check your credentials."),
          ),
        );
      }
    }
  }

  // Build Method to render the full login logic
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loader
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xffFFF886), Color(0xffF072B6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1),
                      const Text(
                        'Welcome Back!',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        // Email input field
                        controller: _emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                          hintText: 'Email',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        // Password input field
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                          hintText: 'Password',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        // Login button
                        onPressed: _loginUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 80),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        // Toggle to signup
                        onPressed: () {
                          // TODO: Link to Signup screen in the future
                        },
                        child: const Text("Don't have an account? Sign Up"),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}/*
Login:
This screen handles the login process using Firebase Authentication.
It validates form input, shows error messages, manages loading state,
and redirects users to the HomeScreen on success. Transition is handled
via a custom animated route.
*/

