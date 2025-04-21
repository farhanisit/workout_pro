import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Database
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart'; // For visualizing workout distribution

// ProgressScreen - Shows user workout stats and visual insights
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  // Firestore fetch to get all exercises and group them by bodyPart
  Future<Map<String, dynamic>> _fetchStats() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('exercises').get();
      final exercises = snapshot.docs;

      final bodyPartCounts = <String, int>{};
      for (var doc in exercises) {
        final data = doc.data() as Map<String, dynamic>;
        final bodyPart = data['bodyPart'] ?? 'Unknown';
        bodyPartCounts[bodyPart] = (bodyPartCounts[bodyPart] ?? 0) + 1;
      }

      return {
        'total': exercises.length, // total number of workouts
        'byBodyPart': bodyPartCounts, // breakdown by targeted body part
      };
    } catch (e) {
      debugPrint("❌ Error fetching stats: $e");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    // current theme for styling
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Progress Tracker"),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        // fetch and render workout data
        future: _fetchStats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong 😞"));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No progress data available."));
          }

          final data = snapshot.data!;
          final total = data['total'] as int;
          final bodyPartMap = data['byBodyPart'] as Map<String, int>;

          if (total == 0) {
            return const Center(
                child: Text("No workouts logged yet. Let’s start!"));
          }

          final target = 100;
          final progress = total >= target ? 1.0 : total / target;

          final motivationalText = progress >= 1
              ? "🏆 You've hit your target! Incredible work!"
              : progress >= 0.7
                  ? "🔥 Almost there! Push a bit more!"
                  : "👊 You're doing great — keep going!";

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Total workout logged and Progress bar
                Text("Total Workouts Logged: $total",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 14,
                    backgroundColor: theme.dividerColor,
                    color: theme.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  motivationalText,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: theme.brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black87,
                  ),
                ),

                const SizedBox(height: 24),

                //  Pie Chart by body part
                Text("Body Part Distribution",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 12),
                PieChart(
                  dataMap: bodyPartMap.map((k, v) => MapEntry(k, v.toDouble())),
                  chartRadius: MediaQuery.of(context).size.width / 2,
                  chartValuesOptions: const ChartValuesOptions(
                    showChartValuesInPercentage: true,
                    showChartValues: true,
                  ),
                  legendOptions: const LegendOptions(
                    showLegends: true,
                    legendPosition: LegendPosition.bottom,
                  ),
                  colorList: [
                    theme.primaryColor,
                    Colors.orangeAccent,
                    Colors.greenAccent,
                    Colors.teal,
                    Colors.deepPurple,
                    Colors.redAccent,
                    Colors.cyan,
                  ],
                ),

                const SizedBox(height: 32),

                // Workout counts by body part
                Text("Workouts by Body Part",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
                const SizedBox(height: 12),
                ...bodyPartMap.entries.map((entry) {
                  return Card(
                    color: theme.cardColor,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    elevation: 2,
                    child: ListTile(
                      leading: const Icon(Icons.fitness_center),
                      title: Text(entry.key, style: theme.textTheme.bodyLarge),
                      trailing: Text(entry.value.toString(),
                          style: theme.textTheme.bodyLarge),
                    ),
                  );
                }),

                const SizedBox(height: 28),

                //  Static Streak Preview
                Text("Consistency Streak",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
                const SizedBox(height: 12),
                Row(
                  children: List.generate(
                    7,
                    (index) => Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 18,
                        decoration: BoxDecoration(
                          color: index < 4
                              ? theme.primaryColor
                              : theme.dividerColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text("4-day streak going strong 💪",
                    style: theme.textTheme.bodyMedium),
              ],
            ),
          );
        },
      ),
    );
  }
}
/*
=====================
 ProgressScreen — shows user stats from Firebase:
- Total workout count (with progress bar)
- Distribution via pie chart
- Grouped workout breakdown
- Static weekly streak preview
======================
Helps users track consistency and celebrate milestones.
*/
