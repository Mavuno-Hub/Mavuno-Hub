import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final RxString username = ''.obs;
  final RxString phone = ''.obs;

  // Method to update user data
  void updateUserData(String fetchUsername, String fetchPhone) {
    username.value = fetchUsername;
    phone.value = fetchPhone;
  }

  // Method to fetch user data from Firestore
  Future<void> fetchUserDataFromFirestore() async {
    try {
      // Replace this with your Firestore data retrieval logic
      // For example, if you have a 'users' collection with user documents:
      final userDocument = await FirebaseFirestore.instance
          .collection('users')
          .doc(username.value) // Assuming the document ID is the username
          .get();

      if (userDocument.exists) {
        final userData = userDocument.data() as Map<String, dynamic>;
        final fetchedUsername = userData['username'];
        final fetchedphone = userData['phone'];

        // Update the UserController with the retrieved data
        username.value = fetchedUsername;
        phone.value = fetchedphone;
      } else {
        // Handle the case where the user document does not exist
        // You can show an error message or take appropriate action
      }
    } catch (e) {
      // Handle any potential errors when fetching data
      print("Error fetching user data: $e");
      // You can also show an error message using SnackBarHelper
    }
  }

  @override
  void onInit() {
    super.onInit();
    // You can call fetchUserDataFromFirestore here if you want to load user data on app start
    // Example: fetchUserDataFromFirestore();
  }
}
