import 'package:flutter/material.dart'; // Flutter material component for UI rendering
import 'package:go_router/go_router.dart'; // Routing system for navigation
import 'package:workout_pro/model/exercise.dart'; // Model containing exercise data
import 'package:workout_pro/services/exercise_service.dart'; // For delete operation

// Exercise Detail View — allows edit/delete and shows GIF preview
class ExerciseDetailScreen extends StatelessWidget {
  final Exercise exercise;
  // Constructor requiring the exercise to display
  const ExerciseDetailScreen({Key? key, required this.exercise})
      : super(key: key);

  // Main widget builder for the screen layout
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ExerciseService _service = ExerciseService();

    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Push to editable form
              context.pushNamed('exerciseForm', extra: exercise);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              // Confirm delete dialog
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Delete Workout?"),
                  content: const Text(
                      "Are you sure you want to delete this workout?"),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Cancel")),
                    ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text("Delete")),
                  ],
                ),
              );

              if (confirmed == true) {
                await _service.deleteExercise(exercise.id!);
                if (context.mounted) context.pop();
              }
            },
          )
        ],
      ),

      // Main detail UI
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Workout Details", style: theme.textTheme.titleLarge),
                const Divider(),
                const SizedBox(height: 8),
                _buildRow("Name", exercise.name, theme),
                _buildRow("Equipment", exercise.equipment, theme),
                _buildRow("Target", exercise.target, theme),
                _buildRow("Body Part", exercise.bodyPart, theme),
                const SizedBox(height: 20),

                // 🖼️ Show GIF if available
                if (exercise.gif.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      exercise.gif,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Text('Could not load image.'),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to render each line item in the details(e.g., Name: Push-up)
  Widget _buildRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ",
              style: theme.textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}

/*
 ExerciseDetailScreen Overview:
- Displays workout details like name, target, equipment, and body part.
- Shows a GIF preview if provided.
- Offers edit and delete actions through AppBar buttons.
- Uses _buildRow for consistent layout rendering.

Called from:
- ExerciseList or Home → Tap an exercise → lands here.
*/
