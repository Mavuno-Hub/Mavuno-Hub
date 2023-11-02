import 'package:cloud_firestore/cloud_firestore.dart';

class LoginBackend {
  Future<bool> login(String identifier, String password) async {
    try {
      final QuerySnapshot usersByUsername = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: identifier)
          .where('password', isEqualTo: password)
          .get();

      if (usersByUsername.docs.isNotEmpty) {
        // Successfully logged in with username
        return true;
      } else {
        final QuerySnapshot usersByPhone = await FirebaseFirestore.instance
            .collection('users')
            .where('phone', isEqualTo: identifier)
            .where('password', isEqualTo: password)
            .get();

        if (usersByPhone.docs.isNotEmpty) {
          // Successfully logged in with phone number
          return true;
        }
      }
    } on FirebaseException catch (e) {
      // Handle database query errors
      print('Error: $e');
    }
    return false;
  }
}
