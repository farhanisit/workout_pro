import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workout_pro/model/exercise.dart';

class ExerciseService {
  final CollectionReference exercisesCollection =
      FirebaseFirestore.instance.collection('exercises');

  // ---------------------------
  // CREATE: Add a new Exercise.
  // ---------------------------
  Future<String> createExercise(Exercise exercise) async {
    try {
      DocumentReference docRef =
          await exercisesCollection.add(exercise.toMap());
      print('✅ Created new exercise with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('❌ Error creating exercise: $e');
      throw e;
    }
  }

  // ---------------------------
  // READ: Retrieve all Exercises.
  // ---------------------------
  Future<List<Exercise>> fetchExercises() async {
    print('📡 Fetching exercises from Firestore...');
    try {
      final querySnapshot = await exercisesCollection.get();
      print('📦 Found ${querySnapshot.docs.length} documents in Firestore');

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        print('🔍 Mapping document: ${doc.id}');
        return Exercise(
          id: doc.id,
          name: data['name'] ?? 'Unnamed',
          gif: data['gif'] ?? '',
          equipment: data['equipment'] ?? 'None',
          target: data['target'] ?? 'Unknown',
          bodyPart: data['bodyPart'] ?? 'Unknown',
        );
      }).toList();
    } catch (e) {
      print('❌ Error fetching exercises: $e');
      return [];
    }
  }

  // ---------------------------
  // READ: Retrieve a single Exercise by ID.
  // ---------------------------
  Future<Exercise?> getExerciseById(String id) async {
    try {
      DocumentSnapshot docSnapshot = await exercisesCollection.doc(id).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        return Exercise(
          id: docSnapshot.id,
          name: data['name'] ?? 'Unnamed',
          gif: data['gif'] ?? '',
          equipment: data['equipment'] ?? 'None',
          target: data['target'] ?? 'Unknown',
          bodyPart: data['bodyPart'] ?? 'Unknown',
        );
      } else {
        print('⚠️ No exercise found for ID: $id');
      }
      return null;
    } catch (e) {
      print('❌ Error fetching exercise by id: $e');
      throw e;
    }
  }

  // ---------------------------
  // UPDATE
  // ---------------------------
  Future<void> updateExercise(String id, Exercise exercise) async {
    try {
      await exercisesCollection.doc(id).update(exercise.toMap());
      print('✅ Updated exercise with ID: $id');
    } catch (e) {
      print('❌ Error updating exercise: $e');
      throw e;
    }
  }

  // ---------------------------
  // DELETE
  // ---------------------------
  Future<void> deleteExercise(String id) async {
    try {
      await exercisesCollection.doc(id).delete();
      print('🗑️ Deleted exercise with ID: $id');
    } catch (e) {
      print('❌ Error deleting exercise: $e');
      throw e;
    }
  }
}
