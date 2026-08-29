import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BackendService {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<void> saveUser({
    required String role,
    required String companion,
  }) async {
    try {
      User? user = auth.currentUser;

      if (user == null) {
        final credential = await auth.signInAnonymously();
        user = credential.user;
      }

      if (user == null) {
        throw Exception('Could not create Firebase user');
      }

      print('Firebase UID: ${user.uid}');

      await db.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'role': role,
        'assistant': companion,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('USER SAVED TO FIRESTORE');
    } catch (e) {
      print('FIRESTORE ERROR: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>?> getUserProfile() async {
    final user = auth.currentUser;

    if (user == null) {
      return null;
    }

    final document = await db
        .collection('users')
        .doc(user.uid)
        .get();

    if (!document.exists) {
      return null;
    }

    return document.data();
  }
}