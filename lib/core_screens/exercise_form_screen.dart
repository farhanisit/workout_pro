import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Routing system for navigation
import 'package:workout_pro/model/exercise.dart'; // Model containing exercise data
import 'package:workout_pro/services/exercise_service.dart'; // For delete operation

// ExerciseFormScreen for adding or editing a workout,
// Handles form input and validation
// Submits data to Firebase via `ExerciseService
class ExerciseFormScreen extends StatefulWidget {
  const ExerciseFormScreen({super.key});

  @override
  State<ExerciseFormScreen> createState() => _ExerciseFormScreenState();
}

// State class managing form logic, data population, and submission
class _ExerciseFormScreenState extends State<ExerciseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _targetController = TextEditingController();
  final _equipmentController = TextEditingController();
  final _bodyPartController = TextEditingController();
  final _gifController = TextEditingController();

  final ExerciseService _service =
      ExerciseService(); // Handles Firestore operations
  Exercise? _editingExercise; // Holds exercise if user is editing
  bool _isSaving = false;

  // Populates form fields if exercise is passed in for editing
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra;
    if (extra is Exercise) {
      _editingExercise = extra;
      _nameController.text = extra.name;
      _targetController.text = extra.target;
      _equipmentController.text = extra.equipment;
      _bodyPartController.text = extra.bodyPart;
      _gifController.text = extra.gif;
    }
  }

  // Handles form submission: creates or updates workout in Firestore
  Future<void> _saveExercise() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final newExercise = Exercise(
      id: _editingExercise?.id,
      name: _nameController.text.trim(),
      target: _targetController.text.trim(),
      equipment: _equipmentController.text.trim(),
      bodyPart: _bodyPartController.text.trim(),
      gif: _gifController.text.trim(),
    );

    try {
      if (_editingExercise != null) {
        await _service.updateExercise(_editingExercise!.id!, newExercise);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Exercise updated")),
        );
      } else {
        await _service.createExercise(newExercise);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Exercise created")),
        );
      }

      if (context.mounted) context.go('/dashboard');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  // UI Builder
  @override
  Widget build(BuildContext context) {
    final isEdit = _editingExercise != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Workout" : "Add Workout")),
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
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _isSaving ? null : _saveExercise,
                icon: Icon(isEdit ? Icons.save_as : Icons.save),
                label: Text(isEdit ? "Update" : "Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Builds a form field with label and validator
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
