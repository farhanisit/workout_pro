import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Auth to fetch current user data
import 'package:go_router/go_router.dart'; // Routing system for navigation
import 'package:provider/provider.dart'; // Theme toggle & state management
import 'package:workout_pro/services/user_service.dart'; // Service layer for user Firestore ops
import 'package:workout_pro/theme/theme_provider.dart'; // For dark/light mode switching

// ProfileScreen class : Displays the logges-in user's profile info as username, email, goal and dark mode preferences
//Profile data is fetches fro Firestore using a service class
//Also Supports logout and theme switching.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService(); // Firestore service instance
  Map<String, dynamic>? _userData; // Shows retreived user profile data
  bool _isLoading = true; // Loading indicator toggle

  @override
  void initState() {
    super.initState();
    _loadUser(); // Load user profile data on widget mount
  }

  // Fetches the current user's profile from Firestore
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

  // Logs out the user and navigates to the authentication screen
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) context.go('/auth');
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Profile"),
        centerTitle: true,
      ),
      // Show loading spinner or user data
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
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? Colors.grey[800]
                                : theme.primaryColor.withOpacity(0.1),
                          ),
                          child: CircleAvatar(
                            radius: 36,
                            backgroundColor: Colors.transparent,
                            child: Text(
                              (_userData!['username'] ?? 'U')[0].toUpperCase(),
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Welcome text
                      Center(
                        child: Text(
                          "Welcome, ${_userData!['username'] ?? 'Athlete'}",
                          style: theme.textTheme.titleLarge,
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Account details
                      Text(
                        "Account Info",
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      _buildDetailRow(
                          Icons.email, "Email", user?.email ?? 'N/A', theme),
                      if ((_userData!['gender'] ?? '').isNotEmpty)
                        _buildDetailRow(Icons.wc, "Gender",
                            _userData!['gender'] ?? '', theme),

                      const SizedBox(height: 30),
                      // Editable goal information
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Your Goal",
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () => context.go('/edit-goal'),
                            child: const Text("Edit"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _userData!['goal'] ?? 'Not set',
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 30),

                      // Dark mode toggle
                      SwitchListTile(
                        value: themeProvider.isDarkMode,
                        onChanged: (_) =>
                            Provider.of<ThemeProvider>(context, listen: false)
                                .toggleTheme(),
                        title:
                            Text("Dark Mode", style: theme.textTheme.bodyLarge),
                        secondary: Icon(
                          themeProvider.isDarkMode
                              ? Icons.dark_mode
                              : Icons.light_mode,
                          color: theme.iconTheme.color,
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),

                      const SizedBox(height: 30),
                      Divider(thickness: 1.2, color: theme.dividerColor),
                      const SizedBox(height: 20),
                      // Logout Button
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: _logout,
                          icon: const Icon(Icons.logout),
                          label: const Text("Log Out"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            foregroundColor: Colors.white,
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

  // Helper widget to build labelled detail rows(e.g, email, gender)
  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 22, color: theme.iconTheme.color),
          const SizedBox(width: 12),
          Text(
            "$label:",
            style: theme.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
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
==============================
 ProfileScreen Summary
==============================
Displays a logged-in user's personal profile, fetched from Firestore using `UserService`.
Features:
- Shows avatar, email, gender, and fitness goal.
- Allows goal editing via routing to /edit-goal.
- Provides a dark mode toggle using ThemeProvider.
- Supports logout and redirects to auth screen.
- Designed with responsive UI and graceful fallbacks for missing data.

Helpful for personalising the user experience and giving quick account control.

*/
