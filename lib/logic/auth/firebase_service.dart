import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  Future<void> saveFormDataToFirestore(String userId, Map<String, dynamic> formData) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Add the provided data to Firestore using the provided user ID
      await firestore.collection('users').doc(userId).update({
        'farm_setup': formData,
      });
    } catch (e) {
      print('An error occurred: $e');
      rethrow;
    }
  }
}
