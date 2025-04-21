import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// 🔌 Handles storing and fetching user info to/from Firestore
class UserService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  /// 💾 Save new user data after sign-up
  Future<void> createUserProfile({
    required String uid,
    required String email,
    String? name,
    String? gender,
    String? goal,
  }) async {
    try {
      await usersCollection.doc(uid).set({
        'email': email,
        'name': name ?? '',
        'gender': gender ?? '',
        'goal': goal ?? '',
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      print('⚠️ Error creating user profile: $e');
      rethrow;
    }
  }

  /// 🔍 Fetch user data by UID
  Future<Map<String, dynamic>> getUserProfile(String uid) async {
    try {
      final snapshot = await usersCollection.doc(uid).get();

      if (snapshot.exists && snapshot.data() != null) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        print("⚠️ No profile found for uid: $uid");
        return {}; // ✅ Safe empty map
      }
    } catch (e) {
      print('⚠️ Error fetching user profile: $e');
      return {}; // ✅ Return empty map instead of crashing
    }
  }
}
