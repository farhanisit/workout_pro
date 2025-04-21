import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // For managing User sessions
import 'package:go_router/go_router.dart'; // For navigating between screens
import 'package:workout_pro/features/display_exercise.dart'; // Detailed View of a workout
import 'package:workout_pro/services/exercise_service.dart'; //handles firebase exercise operations
import 'package:workout_pro/model/exercise.dart'
    as model; // Exercise model (added alias to avoid clashed)

//---------------------------------------
//  Main landing screen after login.
//---------------------------------------

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ExerciseService _exerciseService =
      ExerciseService(); // CRUD helper for exercises
  late Future<List<model.Exercise>>
      _exercisesFuture; // Future to fetch exercises on load

  @override
  void initState() {
    super.initState();
    _exercisesFuture = _exerciseService
        .fetchExercises(); // Fetch exercise data from Firestore when the screen loads
  }

  @override
  Widget build(BuildContext context) {
    final user =
        FirebaseAuth.instance.currentUser; // Fetch the currently signed-in user
    final theme = Theme.of(
        context); // Fetch the active theme for styling widgets dynamically

    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background for visual comfort
      appBar: AppBar(
        title: Text(
            "Welcome ${user?.email ?? 'User'}"), // Show user email or fallback
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance
                  .signOut(); // Inform the user of Sign out
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Logged out")),
              );
            },
          ),
        ],
      ),

      // Async builder to fetch exercise list from Firebase

      body: FutureBuilder<List<model.Exercise>>(
        future: _exercisesFuture, // Uses the future assigned in initstate
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator()); // Loading  Indicator while data is being fetched
          }

          if (snapshot.hasError) {
            return Center(
                child: Text(
                    'Error: ${snapshot.error}')); // Error handling in case Firebase call fails
          }

          final exercises = snapshot.data ??
              []; // Retrieve the exercises, fallback to empty list

          if (exercises.isEmpty) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Empty state if no exercises are found
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    color: theme.primaryColor.withOpacity(0.1),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: theme.primaryColor,
                        child: const Icon(Icons.star, color: Colors.white),
                      ),
                      title: const Text("Great Start!"),
                      subtitle:
                          const Text("You haven't added any workouts yet."),
                      trailing: const Icon(Icons.bar_chart),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text("Today’s Focus",
                      style: theme.textTheme
                          .titleLarge), // Motivational title for encouragement
                  const SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: ListTile(
                      // For keeping structure intact like icon, title, subtitle etc
                      leading: const Icon(Icons.directions_run),
                      title: const Text(
                          "Stretch & Burn"), // Main title of listTile
                      subtitle: const Text(
                          "Recommended full body warm-up"), // Quick description to the user
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        final mock = model.Exercise(
                          // Creates Mock exercise object manually
                          name: "Stretch & Burn",
                          target: "Cardio Endurance",
                          bodyPart: "fullbody",
                          equipment: "None",
                          gif: "https://example.com/stretch-burn.gif",
                        );
                        Navigator.push(
                          // Opens a detailed view with mock workout data (not fetching from backend)
                          context,
                          MaterialPageRoute(
                            builder: (_) => DisplayExercise(exercise: mock),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text("Need help getting started?", // Prompt to guide the user
                      style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 8), // Spacing to avoid visual crowding
                  ElevatedButton.icon(
                    // Navigates to exercise list screen using /exercise
                    onPressed: () {
                      context.go('/exercises');
                    },
                    icon: const Icon(Icons
                        .fitness_center), // Dumbbell icon- Visually represents exercise
                    label: const Text("Browse Exercises"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView(
            // Scrollable view to  display the workout dashboard content
            padding: const EdgeInsets.all(
                16), // Padding ensures spacing around screen elements
            children: [
              Container(
                // Greeting card with gradient header - gives a welcoming feel
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    // Gradient uses Primary theme color with rounded edges
                    colors: [
                      theme.primaryColor,
                      theme.primaryColor.withOpacity(0.8)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // Personalized greeting using part of user's email(before @)
                      "Hey ${user?.email?.split('@').first ?? 'Athlete'} 👋",
                      style: theme.textTheme.titleLarge?.copyWith(
                        // Styled using theme's title text with white override
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      // Motivational subtext under greeeting
                      "Ready to crush today’s workout?",
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors
                              .white70), // Slightly faded white for visual hierarchy
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.pushNamed(
                            'exerciseForm'); // Uses named routing for navigation
                      },
                      icon: const Icon(Icons.flash_on),
                      label: const Text(
                          "Start a Workout"), // Quick-Start button to log a workout manually
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors
                            .white, // White button styled to contrast against the gradient background
                        foregroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          // Rounded corners give a soft, modern appearance
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text("🔥 Trending Workouts",
                  style: theme.textTheme
                      .titleLarge), //  Section header for horizontally scrollable trending workouts
              const SizedBox(height: 12), // Spacing below the section tile
              SizedBox(
                height: 130, // Fixed height for horizontal exercise scroll
                child: ListView(
                  scrollDirection: Axis.horizontal, // Enables side scroll
                  children: exercises
                      .take(6) // Limit the first six workouts for compactness
                      .map(
                        (exercise) => Container(
                          width: 160, // Card Width
                          margin: const EdgeInsets.only(
                              right: 12), // Spacing between cards
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white, // Card background
                            borderRadius:
                                BorderRadius.circular(12), // Rounded corners
                            boxShadow: [
                              // Subtle elevation effect
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(2, 2),
                              )
                            ],
                          ),
                          child: InkWell(
                            // Make the card tappable
                            onTap: () {
                              Navigator.push(
                                // Navigat to full detail view

                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      DisplayExercise(exercise: exercise),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  exercise.name,
                                  style: theme.textTheme.bodyLarge,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  exercise.target,
                                  style: theme.textTheme.bodySmall,
                                ),
                                const Spacer(), // Pushes arrow icon to bottom
                                const Icon(Icons.arrow_forward_ios,
                                    size: 16), // Tiny arrow for nav hint
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(
                  height: 24), // spacing before the full exercise list
              ...exercises.map((exercise) => Card(
                    // Iterate all exercises into a list of cards
                    margin: const EdgeInsets.symmetric(
                        vertical: 8), // Vertical spacing
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(
                          12), // Inner padding for list tile
                      title: Text(
                        exercise.name,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(color: Colors.black87),
                      ),
                      subtitle: Text(
                        "Target: ${exercise.target}",
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: Colors.black54),
                      ),
                      trailing: PopupMenuButton<String>(
                        // Contextual menu (Edit/Delete)
                        onSelected: (value) async {
                          if (value == 'edit') {
                            context.pushNamed('exerciseForm',
                                extra: exercise); //Navigate to edit
                          } else if (value == 'delete') {
                            await _exerciseService.deleteExercise(
                                exercise.id!); // Delete from Firestore
                            setState(() {
                              _exercisesFuture = _exerciseService
                                  .fetchExercises(); // Refresh UI
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Exercise deleted')), // Feedback
                            );
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                              value: 'edit', child: Text('Edit')),
                          const PopupMenuItem(
                              value: 'delete', child: Text('Delete')),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DisplayExercise(
                                exercise: exercise), // Shows details
                          ),
                        );
                      },
                    ),
                  )),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            context.pushNamed('exerciseForm'), // Shortcut to add a new workout
        child: const Icon(Icons.add),
        backgroundColor: theme.primaryColor,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            context.go('/exercises'); // Navigate to Exercises tab
          } else if (index == 2) {
            context.go('/profile'); // Navigate to Profile
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Exercises',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
/*
The HomeScreen provides users with a dashboard-like view of their workouts.
It fetches workout data from Firebase and displays trending exercises.
Users can quickly add, view, edit, or delete workouts, or start a guided session.
UI dynamically adapts to user state, offering motivational headers and fallback content when empty.
*/
