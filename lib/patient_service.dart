import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PatientService {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final FirebaseAuth auth = FirebaseAuth.instance;

  // Create a patient profile
  static Future<void> createPatientProfile({
    required String name,
  }) async {
    final user = auth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    await db.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'name': name,
      'role': 'patient',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Link a patient to a caregiver
  static Future<void> linkPatientToCaregiver({
    required String patientUid,
  }) async {
    final caregiver = auth.currentUser;

    if (caregiver == null) {
      throw Exception('Caregiver is not logged in');
    }

    await db.collection('caregiver_patients').add({
      'caregiverId': caregiver.uid,
      'patientId': patientUid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Get patients linked to current caregiver
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyPatients() {
    final caregiver = auth.currentUser;

    if (caregiver == null) {
      return const Stream.empty();
    }

    return db
        .collection('caregiver_patients')
        .where('caregiverId', isEqualTo: caregiver.uid)
        .snapshots();
  }
    static Future<List<Map<String, dynamic>>> getPatientProfiles() async {
    final caregiver = auth.currentUser;

    if (caregiver == null) {
      return [];
    }

    final relationships = await db
        .collection('caregiver_patients')
        .where('caregiverId', isEqualTo: caregiver.uid)
        .get();

    List<Map<String, dynamic>> patients = [];

    for (final relationship in relationships.docs) {
      final patientId = relationship.data()['patientId'];

      final patientDoc = await db
          .collection('users')
          .doc(patientId)
          .get();

      if (patientDoc.exists && patientDoc.data() != null) {
        patients.add(patientDoc.data()!);
      }
    }

    return patients;
  }
}