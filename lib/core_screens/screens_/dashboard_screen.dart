import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // For Managing user sessions
import 'package:flutter/material.dart'; // Flutter material component for UI rendering
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart'; // Routing system for navogation

// DashboardScreen: A stateful widget displaying fitness stats, goals and charts
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  // Creates a mutable state for the screen
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

// State class managing user workout data, charts, and layout for dashboard screen
class _DashboardScreenState extends State<DashboardScreen> {
  int _totalExercises = 0;
  final List<double> _weeklyData = [1, 2, 1.5, 3, 2.5, 2, 2.8];

  @override
  void initState() {
    super.initState();
    _loadWorkoutCount(); // Load total workouts when screen initializes
  }

  // Method to load total workout count from FIrestore
  Future<void> _loadWorkoutCount() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('exercises').get();
    setState(() {
      _totalExercises = snapshot.docs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth
        .instance.currentUser; // Fetch Current signed-in user details
    final theme = Theme.of(context); // Access themes styles
    final primaryColor = theme.primaryColor;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: const Text("Dashboard"),
        centerTitle: true,
      ),
      // FAB to navigate to workout creation form
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/create-exercise'),
        icon: const Icon(Icons.add),
        label: const Text("Add Workout"),
      ),
      // Includes Welcome text, goal, chart, program and streak stats
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome greeting
            Text(
              "Welcome back, ${user?.email?.split('@')[0] ?? 'Athlete'}!",
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            /// Weekly Goal Card
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              color: theme.cardColor,
              child: ListTile(
                leading: Icon(Icons.flag, color: primaryColor),
                title: Text("Weekly Goal", style: textTheme.bodyLarge),
                subtitle: Text("Workout at least 3 days",
                    style: textTheme.bodyMedium),
                trailing: Chip(
                  label: const Text("2 / 3"),
                  backgroundColor: primaryColor.withOpacity(0.1),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Weekly line chart
            Text("Activity Tracker", style: textTheme.titleLarge),
            const SizedBox(height: 8),
            Container(
              height: 180,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: theme.brightness == Brightness.dark
                          ? Colors.white12
                          : Colors.black12,
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _weeklyData
                          .asMap()
                          .entries
                          .map((e) => FlSpot(e.key.toDouble(), e.value))
                          .toList(),
                      isCurved: true,
                      color: theme.brightness == Brightness.dark
                          ? Colors.cyanAccent
                          : primaryColor,
                      belowBarData: BarAreaData(
                        show: true,
                        color: (theme.brightness == Brightness.dark
                                ? Colors.cyanAccent
                                : primaryColor)
                            .withOpacity(0.2),
                      ),
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Explore sections (Programs for him/her)
            Text("Explore Programs", style: textTheme.titleLarge),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildGradientButton(context, "🔥 For Him", '/cardio',
                    [Colors.indigo, Colors.indigoAccent]),
                const SizedBox(width: 12),
                _buildGradientButton(context, "💃 For Her", '/fullbody',
                    [Colors.deepOrange, Colors.orangeAccent]),
              ],
            ),

            const SizedBox(height: 24),

            // Workout Summary cards
            Text("Workout Programs", style: textTheme.titleLarge),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.fitness_center),
                    title: Text("Total Workouts Logged",
                        style: textTheme.bodyLarge),
                    subtitle: Text("You've added $_totalExercises workouts.",
                        style: textTheme.bodyMedium),
                  ),
                  Divider(color: theme.dividerColor),
                  ListTile(
                    leading: const Icon(Icons.star),
                    title:
                        Text("Consistency Streak", style: textTheme.bodyLarge),
                    subtitle: Text("7-day streak! Keep it up.",
                        style: textTheme.bodyMedium),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Method to build a custom button with gradient background
  Widget _buildGradientButton(
      BuildContext context, String label, String route, List<Color> colors) {
    return Expanded(
      child: GestureDetector(
        onTap: () => context.push(route),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: Theme.of(context).brightness == Brightness.dark
                  ? colors.map((c) => c.withOpacity(0.9)).toList()
                  : colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
/*
DashboardScreen: A dynamic landing screen for logged-in users.
- Greets the user and summarizes their workout activity.
- Displays a line chart to visualize weekly progress.
- Includes a weekly goal tracker, total workout count, and consistency streak.
- Provides quick navigation to workout creation and gender-based workout sections.
*/
