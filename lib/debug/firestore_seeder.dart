import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore DB package

// Function to add sample cardio exercises into Firestore
Future<void> seedCardioWorkouts() async {
  final exercises = [
    {
      "name": "Jumping Jacks",
      "target": "Cardio",
      "bodyPart": "cardio",
      "equipment": "None",
      "gif": "https://example.com/jumping-jacks.gif"
    },
    {
      "name": "Mountain Climbers",
      "target": "Cardio",
      "bodyPart": "cardio",
      "equipment": "None",
      "gif": "https://example.com/mountain-climbers.gif"
    },
    {
      "name": "High Knees",
      "target": "Cardio",
      "bodyPart": "cardio",
      "equipment": "None",
      "gif": "https://example.com/high-knees.gif"
    },
  ];

  for (final workout in exercises) {
    await FirebaseFirestore.instance.collection('exercises').add(workout);
    print("✅ Seeded: \${workout['name']}");
  }
}

// Function that seeds mixed fullbody + cardio workouts in batch
Future<void> seedGymExercises() async {
  final exercises = [
    {
      "name": "Push Ups",
      "equipment": "None",
      "target": "Chest",
      "bodyPart": "fullbody",
      "gif": "https://media.giphy.com/media/XreQmk7ETCak0/giphy.gif",
    },
    {
      "name": "Jumping Jacks",
      "equipment": "None",
      "target": "Full Body",
      "bodyPart": "cardio",
      "gif": "https://media.giphy.com/media/l0ExncehJzexFpRHq/giphy.gif",
    },
    {
      "name": "Plank",
      "equipment": "Mat",
      "target": "Core",
      "bodyPart": "fullbody",
      "gif": "https://media.giphy.com/media/xThtao0fYxH5yDm5Dy/giphy.gif",
    },
    {
      "name": "High Knees",
      "equipment": "None",
      "target": "Legs",
      "bodyPart": "cardio",
      "gif": "https://media.giphy.com/media/l0MYt5jPR6QX5pnqM/giphy.gif",
    },
  ];

  final batch = FirebaseFirestore.instance.batch();

  for (var ex in exercises) {
    final docRef = FirebaseFirestore.instance.collection('exercises').doc();
    batch.set(docRef, ex);
  }

  await batch.commit();
  print("🔥 Seeded gym exercises successfully!");
}
/*
firestore_seeder.dart:
This script provides two seeding functions:
1. seedCardioWorkouts() – Adds basic cardio exercises individually.
2. seedGymExercises() – Batch inserts cardio + fullbody workouts for testing/demo.
Useful for testing Firestore data and UI population during development.
*/
