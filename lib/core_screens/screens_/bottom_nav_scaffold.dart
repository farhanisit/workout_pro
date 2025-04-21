import 'package:flutter/material.dart'; // Flutter core UI package
import 'package:workout_pro/core_screens/screens_/dashboard_screen.dart'; // Dashboard main screen
import 'package:workout_pro/core_screens/screens_/progress_screen.dart'; // Workout Progress screen
import 'package:workout_pro/core_screens/screens_/profile_screen.dart'; // User Profile screen

// BottomNavScaffold: A stateful widget that controls navigation between core screens using bottom navigation
class BottomNavScaffold extends StatefulWidget {
  const BottomNavScaffold({super.key});

  // Creates a mutable state for the screen
  @override
  State<BottomNavScaffold> createState() => _BottomNavScaffoldState();
}

// BottomNavScaffoldState: maintains selected tab and renders the crooesponding screen
class _BottomNavScaffoldState extends State<BottomNavScaffold> {
  int _selectedIndex = 0;
  // List all main screens to switch between
  final List<Widget> _screens = const [
    DashboardScreen(),
    ProgressScreen(),
    ProfileScreen(),
  ];
  // Builds the scaffold with dynamic screen bases on bottom nav selection
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // Keeps state alive across tab switches
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      //Material 3 Bottom navigation bar
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        height: 70,
        elevation: 1,
        backgroundColor: theme.scaffoldBackgroundColor,
        indicatorColor: theme.primaryColor.withOpacity(0.1),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.show_chart_outlined),
            selectedIcon: Icon(Icons.show_chart),
            label: 'Progress',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
/*
BottomNavScaffold:
===================
Provides a persistent bottom navigation interface between Dashboard, Progress, and Profile screens.
Uses IndexedStack to preserve state of each screen and Material 3 NavigationBar for modern UI.
*/
