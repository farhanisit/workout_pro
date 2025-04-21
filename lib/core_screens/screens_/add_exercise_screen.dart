import 'package:flutter/material.dart'; // Flutter core UI package
import 'package:workout_pro/model/exercise.dart'; // Exercise model class
import 'package:workout_pro/services/exercise_service.dart'; // Handles Firestore execise operations
import 'package:go_router/go_router.dart'; //routing system for navigation

// AddExerciseScreen : handles adding a new exercise via form
class AddExerciseScreen extends StatefulWidget {
  const AddExerciseScreen({Key? key}) : super(key: key);

  // Creates a mutable state for the screen
  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

// AddExerciseScreenState: Handles form state, validation, and saving logic
class _AddExerciseScreenState extends State<AddExerciseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(); // Controller for name field
  final _targetController =
      TextEditingController(); // Controller for target field
  final _equipmentController =
      TextEditingController(); // Controller for equipment field
  final _bodyPartController =
      TextEditingController(); // Controller for body part field
  final _gifController =
      TextEditingController(); // Controller for body part field

  final ExerciseService _service =
      ExerciseService(); // Instance for Firestore CRUD
  bool _isSaving = false; // Flag to show loader/button disable state

  // Validates form and submits exercise data to Firestore
  Future<void> _saveExercise() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final newExercise = Exercise(
      name: _nameController.text,
      target: _targetController.text,
      equipment: _equipmentController.text,
      bodyPart: _bodyPartController.text,
      gif: _gifController.text,
    );

    try {
      await _service.createExercise(newExercise);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Exercise added")),
        );
        context.go('/dashboard'); // Redirect to dashboard after save
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  // Build: Builds the form UI for entering exercise details
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Workout")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildField("Name", _nameController),
              _buildField("Target", _targetController),
              _buildField("Equipment", _equipmentController),
              _buildField("Body Part", _bodyPartController),
              _buildField("GIF URL (optional)", _gifController,
                  required: false),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _isSaving ? null : _saveExercise,
                icon: const Icon(Icons.save),
                label: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // BuildField(): Reusable form field widget for all inputs
  Widget _buildField(String label, TextEditingController controller,
      {bool required = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: required
            ? (value) =>
                (value == null || value.trim().isEmpty) ? "Required" : null
            : null,
      ),
    );
  }
}

/*
AddExerciseScreen:
This screen allows users to add a new workout by entering details like name, target area, equipment, and optional GIF.
Includes form validation, feedback via SnackBar, and navigation back to the dashboard.
All data is submitted to Firebase via ExerciseService.
*/
