import 'package:firebase_auth/firebase_auth.dart'; // Firebase Autentication

// Class: AuthService – Handles Firebase login & logout methods
class AuthService {
  // FirebaseAuth instance to access Firebase authentication methods.
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method SignIn
  // Sign in using email and password.
  // Returns the User if successful, otherwise null.
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('Sign-in error!: ${e.toString()}');
      return null;
    }
  }

  // Method SignOut
  // Sign out the current user.
  // Returns void if successful, otherwise null.
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Sign-out error!: ${e.toString()}');
    }
  }
}
/*
AuthService:
=================
A lightweight authentication utility class to manage FirebaseAuth operations.
Includes methods for signing in (`signIn`) and signing out (`signOut`) using Firebase.
All auth logic is wrapped with error handling for robustness.
*/
