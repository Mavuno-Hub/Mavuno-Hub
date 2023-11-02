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
 Future<String> getUsername() async {
    // Check if the username is already fetched, and return it if available
    if (username.isNotEmpty) {
      return username.value;
    }

    try {
      // If the username is not available, fetch it from Firestore
      final userDocument = await FirebaseFirestore.instance
          .collection('users')
          .doc(username.value) // Assuming the document ID is the username
          .get();

      if (userDocument.exists) {
        final userData = userDocument.data() as Map<String, dynamic>;
        final fetchedUsername = userData['username'];

        // Update the UserController with the retrieved username
        username.value = fetchedUsername;

        // Return the fetched username
        return fetchedUsername;
      } else {
        // Handle the case where the user document does not exist
        // You can show an error message or return a default value
        return 'User not found';
      }
    } catch (e) {
      // Handle any potential errors when fetching data
      print("Error fetching username: $e");
      // You can also show an error message using SnackBarHelper
      return 'Error fetching username';
    }
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
