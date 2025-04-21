import 'package:flutter/material.dart'; // Flutter material component for UI rendering
import 'package:firebase_auth/firebase_auth.dart'; // Auth to fetch current user data
import 'package:go_router/go_router.dart'; // Routing system for navigation
import 'package:provider/provider.dart'; // For state management (theme switch)
import 'package:workout_pro/services/user_service.dart'; // Handles Firestore operations for user profile
import 'package:workout_pro/theme/theme_provider.dart'; // For toggling light/dark mode

// Class representing the profile setup screen (stateful)
class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key}); // Constructor for the class

  @override
  State<ProfileSetupScreen> createState() => _ProfileScreenState();
}

// State class that manages logic and UI for ProfileSetupScreen
class _ProfileScreenState extends State<ProfileSetupScreen> {
  final UserService _userService =
      UserService(); // Instance to interact with Firestore user data
  Map<String, dynamic>? _userData; // Holds user data fetched from Firestore
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser(); // Load user data when screen initializes
  }

// Method to load user profile data from Firebase using UID
  Future<void> _loadUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final data = await _userService.getUserProfile(user.uid);
        setState(() {
          _userData = data;
          _isLoading = false;
        });
      } catch (e) {
        debugPrint('Failed to load user profile: $e');
        setState(() => _isLoading = false);
      }
    }
  }

  // Method to log out the user and redirect to authentication screen
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) context.go('/auth');
  }

  @override
  Widget build(BuildContext context) {
    final user =
        FirebaseAuth.instance.currentUser; // Fetch Current signed-in user
    final theme = Theme.of(context); // Fetch theme for consistent styling
    final isDark =
        theme.brightness == Brightness.dark; // Access dark/light mode toggle
    final themeProvider =
        Provider.of<ThemeProvider>(context); // Check if current theme is dark

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor, // Background color based on theme
      appBar: AppBar(
        title: const Text("Your Profile"),
        centerTitle: true,
      ),
      // Show spinner if loading, show "no data" if null/empty, else build profile UI
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userData == null || _userData!.isEmpty
              ? const Center(child: Text("No profile data found."))
              : SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Avatar
                      Center(
                        child: CircleAvatar(
                          radius: 36,
                          backgroundColor: theme.primaryColor.withOpacity(0.1),
                          child: Text(
                            (_userData!['username'] ?? 'U')[0].toUpperCase(),
                            style: TextStyle(
                              fontSize: 28,
                              color: theme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Welcome message with username fallback
                      Center(
                        child: Text(
                          "Welcome, ${_userData!['username'] ?? 'Athlete'}",
                          style: theme.textTheme.titleLarge,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Section title: Account Info
                      Text("Account Info",
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      // Show email and gender (if available)
                      _buildDetailRow(
                          Icons.email, "Email", user?.email ?? 'N/A', theme),
                      if ((_userData!['gender'] ?? '').isNotEmpty)
                        _buildDetailRow(Icons.wc, "Gender",
                            _userData!['gender'] ?? '', theme),

                      const SizedBox(height: 30),

                      //  Section: Goal with edit option
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Your Goal",
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          TextButton(
                            onPressed: () => context.go('/edit-goal'),
                            child: const Text("Edit"),
                          )
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text((_userData!['goal'] ?? 'Not set'),
                          style: theme.textTheme.bodyLarge),

                      const SizedBox(height: 30),

                      // Toggle for dark mode
                      SwitchListTile(
                        value: themeProvider.isDarkMode, // Reflect current mode
                        onChanged: (_) =>
                            Provider.of<ThemeProvider>(context, listen: false)
                                .toggleTheme(), // Toggle app theme
                        title: const Text("Dark Mode"),
                        secondary: Icon(
                          themeProvider.isDarkMode
                              ? Icons.dark_mode
                              : Icons.light_mode,
                          color: theme.colorScheme.primary,
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),

                      const SizedBox(height: 30),
                      // Divider for visual break
                      Divider(thickness: 1.2, color: theme.dividerColor),
                      const SizedBox(height: 20),

                      // Log out button
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: _logout, // Call logout function
                          icon: const Icon(Icons.logout),
                          label: const Text("Log Out"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  // Helper widget to build a single row of user info (icon + label + value)
  Widget _buildDetailRow(
      IconData icon, String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 22, color: theme.iconTheme.color),
          const SizedBox(width: 12),
          Text("$label:",
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/*
ProfileSetupScreen:
----------------------
Handles the visual representation of user account data like name, email, gender, and goal.
Includes a toggle for dark mode and logout functionality.
Data is fetched from Firebase via UserService and rendered dynamically.
-----------------------
*/
