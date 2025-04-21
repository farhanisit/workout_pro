import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Routing System for navigation
import 'package:workout_pro/model/exercise.dart';
import 'package:workout_pro/services/exercise_service.dart'; // Handles firebase exercise operations
import 'exercise_detail_screen.dart'; // Exercise model

// ExerciseListScreen
// Displays all exercises with search + bodyPart filter
// Connects to Firestore using ExerciseService
class ExerciseListScreen extends StatefulWidget {
  const ExerciseListScreen({Key? key}) : super(key: key);

  @override
  _ExerciseListScreenState createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  final ExerciseService _exerciseService = ExerciseService(); // Firestore ops

  List<Exercise> _exercises = [];
  List<Exercise> _filteredExercises = []; // Filtered view

  String _searchTerm = '';
  String _selectedBodyPart = 'All';

  final List<String> _bodyParts = ['All', 'cardio', 'fullbody', 'legs', 'arms'];

  // Initial fetch when screen loads
  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  // Loads exercises from Firestore and applies filters
  Future<void> _loadExercises() async {
    final fetched = await _exerciseService.fetchExercises();
    setState(() {
      _exercises = fetched;
      _applyFilters();
    });
  }

  // Applies search and dropdown filter to exercise list
  void _applyFilters() {
    setState(() {
      _filteredExercises = _exercises.where((ex) {
        final matchSearch =
            ex.name.toLowerCase().contains(_searchTerm.toLowerCase());
        final matchFilter =
            _selectedBodyPart == 'All' || ex.bodyPart == _selectedBodyPart;
        return matchSearch && matchFilter;
      }).toList();
    });
  }

  // Main UI
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercises'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (term) {
                _searchTerm = term;
                _applyFilters();
              },
              decoration: InputDecoration(
                hintText: 'Search exercises...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Filter Dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonFormField<String>(
              value: _selectedBodyPart,
              items: _bodyParts
                  .map((part) => DropdownMenuItem(
                      value: part, child: Text(part.toUpperCase())))
                  .toList(),
              onChanged: (value) {
                _selectedBodyPart = value!;
                _applyFilters();
              },
              decoration: const InputDecoration(
                labelText: 'Filter by Body Part',
                border: OutlineInputBorder(),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Filtered Exercise List
          Expanded(
            child: _filteredExercises.isEmpty
                ? const Center(child: Text('No exercises found.'))
                : ListView.builder(
                    itemCount: _filteredExercises.length,
                    itemBuilder: (context, index) {
                      final exercise = _filteredExercises[index];
                      return ListTile(
                        title: Text(exercise.name),
                        subtitle: Text('Equipment: ${exercise.equipment}'),
                        onTap: () {
                          // Optional: you could also route this via GoRouter
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ExerciseDetailScreen(exercise: exercise),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),

      // FAB: Go to create-exercise using GoRouter
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/create-exercise');
        },
        backgroundColor: theme.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
