  // void _signUp() async {
  //   final snacky = snackBarHelper.SnackBarHelper(context);
  //   final String username = _usernameController.text.trim();
  //   final String phone = _phonenumberController.text.trim();


  //   if (username.isEmpty) {
  //     snacky.showSnackBar("Username is empty", isError: true);
  //     return;
  //   }

  //   if (phone.isEmpty) {
  //     snacky.showSnackBar("Phone number is empty", isError: true);
  //     return;
  //   }

  //   try {
  //     final user = FirebaseAuth.instance.currentUser;

  //     if (user == null) {
  //       snacky.showSnackBar("User not authenticated. Please log in.",
  //           isError: true);
  //       return;
  //     }
  //     // Sends code to Whatsapp
  //     String autoPass = generatePassword();
  //     String message =
  //         'Your MavunoHub Account Password is \n  $autoPass'; // Replace with your message
  //     String sender = _phonenumberController.text.trim();
  //     String url =
  //         'https://wa.me/$sender/?text=${Uri.encodeComponent(message)}';

  //     launchUrl(Uri.parse(url));

  //     // Reset the form
  //     _formKey.currentState?.reset();

  //     await FirebaseFirestore.instance
  //         .collection("users")
  //         .add({'username': username, 'phone': phone, "password": autoPass});


  //     snacky.showSnackBar("Account successfully created", isError: false);

  //     // Navigate to the login screen
  //     Navigator.of(context)
  //         .push(MaterialPageRoute(builder: (context) => const LogInUser()));
  //   } on FirebaseAuthException catch (e) {
  //     snacky.showSnackBar("Firebase Authentication Error: ${e.message}");
  //     print("Firebase Authentication Error: ${e.message}");
  //   } catch (e) {
  //     snacky.showSnackBar("An error occurred: $e");
  //     print("An error occurred: $e");
  //   }
  // }


  // String generatePassword() {
  //   final String capitalLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  //   final String smallLetters = 'abcdefghijklmnopqrstuvwxyz';
  //   final String specialCharacters = '!@#\$%^&*()_-+=<>?';
  //   final String numbers = '0123456789';

  //   final String passwordString =
  //       '$capitalLetters$smallLetters$specialCharacters$numbers';

  //   final random = Random.secure();

  //   // Generate one capital letter
  //   final capitalLetter = capitalLetters[random.nextInt(capitalLetters.length)];

  //   // Generate one small letter
  //   final smallLetter = smallLetters[random.nextInt(smallLetters.length)];

  //   // Generate one special character
  //   final specialCharacter =
  //       specialCharacters[random.nextInt(specialCharacters.length)];

  //   // Generate seven numbers
  //   final numbersList = List.generate(7, (index) {
  //     final randomIndex = random.nextInt(numbers.length);
  //     return numbers[randomIndex];
  //   });

  //   // Shuffle the numbers to randomize their order
  //   numbersList.shuffle(random);

  //   // Combine all the components to form the password
  //   final passwordComponents = <String>[
  //     capitalLetter,
  //     smallLetter,
  //     specialCharacter,
  //     ...numbersList
  //   ];
  //   passwordComponents.shuffle(random);

  //   final password = passwordComponents.join(); // Convert the list to a string

  //   return password;
  // }

  // void main() {
  //   final password = generatePassword();
  //   print('Generated Password: $password');
  // }
