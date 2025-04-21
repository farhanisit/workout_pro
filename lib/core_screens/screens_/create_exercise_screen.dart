import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // For user authentication(Not directly used here)
import 'package:cloud_firestore/cloud_firestore.dart'; //For Firestore DB operations
import 'package:go_router/go_router.dart'; // Routing system for navigation
import 'package:workout_pro/model/exercise.dart'; // exercise model defination

// Stateful widget class for creating or editing a workout
class CreateExerciseScreen extends StatefulWidget {
  final Exercise? exercise;
  const CreateExerciseScreen({super.key, this.exercise});

  // Creates a mutable state for CreateExerciseScreen widget
  @override
  State<CreateExerciseScreen> createState() => _CreateExerciseScreenState();
}

// State class that holds form logic and Firebase interaction
class _CreateExerciseScreenState extends State<CreateExerciseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _targetController = TextEditingController();
  final _bodyPartController = TextEditingController();
  final _equipmentController = TextEditingController();
  final _gifController = TextEditingController();

  bool _isLoading = false;
  bool get isEdit => widget.exercise != null; // Flag to check if editing

  // Initializes the form with existinf data(If editing) or extra route data
  @override
  void initState() {
    super.initState();
    if (isEdit) {
      final ex = widget.exercise!;
      _nameController.text = ex.name;
      _targetController.text = ex.target;
      _bodyPartController.text = ex.bodyPart;
      _equipmentController.text = ex.equipment;
      _gifController.text = ex.gif;
    } else {
      // 💡 Prefill bodyPart if passed via router extra
      final extra =
          GoRouter.of(context).routerDelegate.currentConfiguration.extra;
      if (extra is Map<String, dynamic> && extra['bodyPart'] != null) {
        _bodyPartController.text = extra['bodyPart'];
      }
    }
  }

  // Method that validates form and either adds a new workout or update existing one
  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final newExercise = Exercise(
      id: widget.exercise?.id,
      name: _nameController.text.trim(),
      target: _targetController.text.trim(),
      bodyPart: _bodyPartController.text.trim(),
      equipment: _equipmentController.text.trim(),
      gif: _gifController.text.trim(),
    );

    try {
      final ref = FirebaseFirestore.instance.collection('exercises');
      if (isEdit && newExercise.id != null) {
        await ref.doc(newExercise.id).update(newExercise.toMap());
      } else {
        await ref.add(newExercise.toMap()); // Add new exercise
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEdit ? 'Exercise updated' : 'Exercise added'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/exercises'); // Navigate to exercise list
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Builds the main UI structure
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Exercise' : 'Create Exercise'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildField("Exercise Name", _nameController),
              _buildField("Target (e.g. abs)", _targetController),
              _buildField("Body Part", _bodyPartController),
              _buildField("Equipment", _equipmentController),
              _buildField("GIF URL", _gifController, required: false),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      icon: Icon(isEdit ? Icons.edit : Icons.add),
                      label: Text(isEdit ? 'Update Exercise' : 'Add Exercise'),
                      onPressed: _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable form field builder
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
                value == null || value.trim().isEmpty ? 'Required' : null
            : null,
      ),
    );
  }
}

/*
CreateExerciseScreen:
- Allows users to add or edit a workout.
- Utilizes Firestore to store structured exercise data.
- Handles both form state and Firebase integration.
- Used throughout the app for building workout collections.
*/
