import 'package:flutter/material.dart'; // Flutter material component for UI rendering
import 'package:cloud_firestore/cloud_firestore.dart'; // Provides access to Firebase DB operations
import 'package:firebase_auth/firebase_auth.dart'; // For Login / signup
import 'package:workout_pro/services/user_service.dart'; // Handles firebase exercise operations

// EditGoalScreen: A main stateful widget class responsible for displaying and updating the user's fitness goal
class EditGoalScreen extends StatefulWidget {
  const EditGoalScreen(
      {super.key}); // Constructor for Optional key for widget identity

  // Creates a mutable State for the screen
  @override
  State<EditGoalScreen> createState() => _EditGoalScreenState();
}

// The state class that handles the actual logic for loading, displaying and updating the goal
class _EditGoalScreenState extends State<EditGoalScreen> {
  final _formKey =
      GlobalKey<FormState>(); // For validating and managing form state
  final TextEditingController _goalController =
      TextEditingController(); // Controller to read/Write the goal text input
  final UserService _userService =
      UserService(); // Instance of custom user sevice for DB access
  bool _isSaving = false;

  // Initializes the screen by loading the current goal from Firestore
  @override
  void initState() {
    super.initState();
    _loadCurrentGoal();
  }

  // Method to load the current user's goal from Firestore and pre-fills the text field
  Future<void> _loadCurrentGoal() async {
    final user = FirebaseAuth
        .instance.currentUser; // Fetch current signed-in user details
    if (user != null) {
      final data = await _userService.getUserProfile(user.uid);
      if (data?['goal'] != null) {
        _goalController.text = data!['goal'];
      }
    }
  }

  // Method to validate and update the goal to Firebase
  Future<void> _saveGoal() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'goal': _goalController.text.trim()
      }); // Update the goal field in Firestore for that user

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Goal updated successfully!")),
        );
        Navigator.pop(context); // 👈 Return to previous screen
      }
    }

    setState(() => _isSaving = false);
  }

  // Method that constructs the UI for editing the goal
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Edit Your Goal"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _goalController,
                decoration: InputDecoration(
                  labelText: "Your fitness goal",
                  labelStyle: theme.textTheme.bodyMedium,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Please enter a goal'
                    : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: _isSaving
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _saveGoal,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Save Goal",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
