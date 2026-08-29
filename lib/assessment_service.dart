import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AssessmentService {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final FirebaseAuth auth = FirebaseAuth.instance;

  // Save a completed assessment
  static Future<String?> saveAssessment({
    required Map<String, dynamic> answers,
    required int score,
    required String result,
  }) async {
    final user = auth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    final document = await db.collection('assessments').add({
      'userId': user.uid,
      'answers': answers,
      'score': score,
      'result': result,
      'timestamp': FieldValue.serverTimestamp(),
    });

    return document.id;
  }

  // Get assessments of the current user
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyAssessments() {
    final user = auth.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    return db
        .collection('assessments')
        .where('userId', isEqualTo: user.uid)
        .snapshots();
  }
    static Future<List<Map<String, dynamic>>> getPatientAssessments(
    String patientId,
  ) async {
    final snapshot = await db
        .collection('assessments')
        .where('userId', isEqualTo: patientId)
        .get();

    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data(),
      };
    }).toList();
  }
}