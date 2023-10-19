// ignore_for_file: use_build_context_synchronously

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavunohub/auth/auth_service.dart';
import 'package:mavunohub/components/alert.dart';
import 'package:provider/provider.dart';
// import 'package:mavunohub/responsive/mobile_body.dart';
// import 'package:mavunohub/responsive/responsive_layout.dart';
// import 'package:mavunohub/screens/app_screens/log_in.dart';
import '../../components/custom_button.dart';
import '../../components/form_text.dart';
import '../../components/password.dart';
import '../../components/phone_field.dart';
import '../../components/snacky.dart';
import 'package:url_launcher/url_launcher.dart';
import 'log_in_page.dart';
// import 'verify_code.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      // body: const ResponsiveLayout(
      //   desktopBody: DesktopSignUp(),
      //   mobileBody: MobileSignUp(),
      //   tabletBody: TabletSignUp(),
      // ),
      body: const MobileSignUp(),
    );
  }
}

class MobileSignUp extends StatefulWidget {
  const MobileSignUp({
    super.key,
  });

  @override
  State<MobileSignUp> createState() => _MobileSignUpState();
}

class _MobileSignUpState extends State<MobileSignUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();

  // void _signUp() async {
  //   SnackBarHelper snacky = SnackBarHelper(context);
  //   final String username = _usernameController.text.trim();
  //   final String phone = _phonenumberController.text.trim();

  //   int screenState = 0;

  //   if (username.isEmpty) {
  //     snacky.showSnackBar("Username is Empty");
  //     return;
  //   } else if (phone.isEmpty) {
  //     snacky.showSnackBar("Phone number is Empty");
  //     return;
  //   } else {
  //     try {
  //       context
  //           .read<AuthService>()
  //           .signUp(
  //             username,
  //             phone,
  //           )
  //           .then((value) async {
  //         User? user = FirebaseAuth.instance.currentUser;
  //         _formKey.currentState?.reset();
  //         await FirebaseFirestore.instance.collection("users").add({
  //           // 'uid': user?.uid,
  //           'username': username,
  //           'email': email.toString().trim(),
  //           'password': password,
  //           'phone': phone
  //         });
  //       });
  //       // await _registerUser(username, phone, email, password);
  //       snacky.showSnackBar("Successfuly created Account", isError: false);
  //       // _formKey.currentState?.reset();
  //       Navigator.of(context)
  //           .push(MaterialPageRoute(builder: (context) => const LogInUser()));
  //     } on FirebaseAuthException catch (e) {
  //       snacky.showSnackBar(e.toString());
  //       print(e);
  //     }
  //   }
  // }

  Future<bool> doesUsernameExist(String username) async {
    final users = FirebaseFirestore.instance.collection("users");
    final usernameQuery = users.where("username", isEqualTo: username);
    final usernameSnapshot = await usernameQuery.get();
    return usernameSnapshot.size > 0;
  }

  Future<bool> doesPhoneNumberExist(String phone) async {
    final users = FirebaseFirestore.instance.collection("users");
    final phoneQuery = users.where("phone", isEqualTo: phone);
    final phoneSnapshot = await phoneQuery.get();
    return phoneSnapshot.size > 0;
  }

  void _signUp() async {
    final snacky = SnackBarHelper(context);
    
    final String username = _usernameController.text.trim();
    final String phone = _phonenumberController.text.trim();

    if (username.isEmpty) {
      snacky.showSnackBar("Username is empty", isError: true);
      return;
    }

    if (phone.isEmpty) {
      snacky.showSnackBar("Phone number is empty", isError: true);
      return;
    }

    if (await doesUsernameExist(username)) {
      snacky.showSnackBar("Username exists, use a different one",
          isError: true);

      return;
    }

    if (await doesPhoneNumberExist(phone)) {
      snacky.showSnackBar("Phone number exists, use a different one",
          isError: true);
      return;
    }

    try {
      // Generate a password
      final password = generatePassword();

      // Add the user's data to the database
      await FirebaseFirestore.instance.collection("users").add({
        'username': username,
        'phone': phone, // Store the phone number as a string
        'password': password,
      });

      // Send the password to the user's WhatsApp account
     await launchUrl(Uri.parse(
          'https://wa.me/$phone/?text=${Uri.encodeComponent('Your MavunoHub Account Password is: \n\n *$password*\n\nSave it for future logins')}'));

      // Navigate to the login screen
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const LogInUser()));
           Alert.show(
              context,
              title: 'Password',
              message:  '$password',
              isError: true,
            );
    } catch (e) {
      snacky.showSnackBar("An error occurred: $e", isError: true);
      print("An error occurred: $e");
    }
  }

  String generatePassword() {
    final String capitalLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final String smallLetters = 'abcdefghijklmnopqrstuvwxyz';
    final String specialCharacters = '!@#\$%^&*()_-+=<>?';
    final String numbers = '0123456789';

    final String passwordString =
        '$capitalLetters$smallLetters$specialCharacters$numbers';

    final random = Random.secure();

    // Generate one capital letter
    final capitalLetter = capitalLetters[random.nextInt(capitalLetters.length)];

    // Generate one small letter
    final smallLetter = smallLetters[random.nextInt(smallLetters.length)];

    // Generate one special character
    final specialCharacter =
        specialCharacters[random.nextInt(specialCharacters.length)];

    // Generate seven numbers
    final numbersList = List.generate(7, (index) {
      final randomIndex = random.nextInt(numbers.length);
      return numbers[randomIndex];
    });

    // Shuffle the numbers to randomize their order
    numbersList.shuffle(random);

    // Combine all the components to form the password
    final passwordComponents = <String>[
      capitalLetter,
      smallLetter,
      specialCharacter,
      ...numbersList
    ];
    passwordComponents.shuffle(random);

    final password = passwordComponents.join(); // Convert the list to a string

    return password;
  }

  void main() {
    final password = generatePassword();
    print('Generated Password: $password');
  }

  // Future<void> _registerUser(
  //     String username, String phone, String email, String password) async {
  //   await context.read<AuthService>().signUp(email, password, username, phone);
  //   User? user = FirebaseAuth.instance.currentUser;
  //   await FirebaseFirestore.instance.collection("users").doc(user?.uid).set({
  //     'uid': user?.uid,
  //     'email': email,
  //     'password': password,
  //     'username': username,
  //     'phone number': phone,
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 1),
            // image
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/mavunohub_logo.png',
                  width: 250, height: 150),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                // Wrap the row with Center
                child: Text(
                  'Create User Account to Log In',
                  style: TextStyle(
                    fontFamily: 'Gilmer',
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Column(children: [
              // username
              FormText(
                prefix: Icons.account_circle_rounded,
                title: 'Enter Username',
                text: 'Enter Username',
                validator: (value) {
                  if (value == null) {
                    return 'Please Enter Name';
                  }
                  return null;
                },
                controller: _usernameController,
              ),
              // phone
              PhoneField(
                prefix: Icons.phone_iphone_rounded,
                title: 'Enter PhoneNumber',
                text: 'Enter PhoneNumber',
                validator: (value) {
                  if (value == null) {
                    return 'Please Enter PhoneNumber';
                  }
                  return null;
                },
                keyboardType: const TextInputType.numberWithOptions(
                    signed: false, decimal: false),
                controller: _phonenumberController,
              ),
              // email
              // FormText(
              //   prefix: Icons.email_rounded,
              //   title: 'Enter E-Mail',
              //   text: 'Enter E-Mail',
              //   keyboardType: TextInputType.emailAddress,
              //   validator: (value) {
              //     if (value == null) {
              //       return 'Please Enter PhoneNumber';
              //     }
              //     return null;
              //   },
              //   controller: _emailController,
              // ),

              // PassWord(
              //   title: 'Create Password', // Updated the title to 'Password'
              //   text: 'Create Password',
              //   controller: _passwordController,
              //   generatePass: () {
              //     _passwordController.text = generatePassword();
              //     setState(() {});
              //   },
              // ),

              FormButton(
                text: 'Create Account',
                // action: _signUp
                action: () {
                  _signUp();
                },
              ),
            ]),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                // Wrap the row with Center
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center the row horizontally
                  children: [
                    Text(
                      'Already have an Account?',
                      style: TextStyle(
                        fontFamily: 'Gilmer',
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LogInUser()));
                      },
                      child: Text(
                        ' Log In',
                        style: TextStyle(
                          fontFamily: 'Gilmer',
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.tertiary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
