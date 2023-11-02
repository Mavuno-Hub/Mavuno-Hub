import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataManager {
  static final UserDataManager _instance = UserDataManager._internal();
  late DocumentSnapshot userSnapshot;

  factory UserDataManager() {
    return _instance;
  }

  UserDataManager._internal();

  Future<void> fetchUserData(String usernameOrPhoneNumber) async {
    final userQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: usernameOrPhoneNumber)
        .get();

    if (userQuery.docs.isNotEmpty) {
      userSnapshot = userQuery.docs.first;
    } else {
      // Handle the case where the user is not found.
    }
  }

  Future<void> saveFarmSetup(Map<String, dynamic> formData) async {
    if (userSnapshot != null) {
      final farmSetupCollection = userSnapshot.reference.collection('farm_setup');
      await farmSetupCollection.add(formData);
    } else {
      // Handle the case where the user data is not available.
    }
  }
}
