// import 'package:firebase_auth/firebase_auth.dart';
// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:mavunohub/components/phone_field.dart';
import 'package:mavunohub/responsive/mobile_body.dart';
import 'package:mavunohub/responsive/responsive_layout.dart';
import 'package:mavunohub/screens/app_screens/log_in_page.dart';
import 'package:mavunohub/screens/app_screens/sign_in.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../auth/firebase_auth_service.dart';
import '../../components/alert.dart';
import '../../components/custom_button.dart';
import '../../components/form_text.dart';
import '../../components/password.dart';
import '../../components/snacky.dart';
import '../../responsive/desktop_body.dart';
import '../../responsive/tablet_body.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _resetPasswordState();
}

class _resetPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: const ResponsiveLayout(
        desktopBody: DesktopForgotPassword(),
        mobileBody: MobileForgotPassword(),
        tabletBody: TabletForgotPassword(),
      ),
    );
  }
}

class TabletForgotPassword extends StatefulWidget {
  const TabletForgotPassword({
    super.key,
  });

  @override
  State<TabletForgotPassword> createState() => _TabletForgotPasswordState();
}

class _TabletForgotPasswordState extends State<TabletForgotPassword> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // final TextEditingController _phonenumberController = TextEditingController();
  void _resetPassword() async {
    // String username = _usernameController.text;
    // String phonenumber = _phonenumberController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      // User is successfully created, show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Successfully Logged In',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Gilmer',
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 16),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
      );
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const TabletScaffold()));
      // Clear the form fields
      // Navigate to the ForgotPassword page
    } catch (e) {
      String errorMessage = "ForgotPassword error occurred. Please try again.";
      if (e is FirebaseAuthException) {
        if (e.code == 'invalid-email') {
          errorMessage = 'E-Mail is not registered to an account.';
        } else if (e.code == 'user-not-found') {
          errorMessage = 'User does not exist.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'The Password is invalid.';
        } else if (e.code == 'web-internal-error') {
          errorMessage = 'Technical Error.';
        }

        // You can handle other error codes here if needed.
      }

      // Show the error message in a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Gilmer',
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 16),
          ),
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final ap = Provider.of<AuthProvider>(context, listen: false);
    final formKey = GlobalKey<FormState>();

    return Center(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 1),
            Padding(
              padding: const EdgeInsets.all(8.0)
                  .add(const EdgeInsets.symmetric(vertical: 40)),
              child: Image.asset('assets/mavunohub_logo.png',
                  width: 250, height: 150),
            ),
            FormText(
              prefix: Icons.account_circle_rounded,
              title: 'Username or PhoneNumber',
              text: 'Username or PhoneNumber',
              controller: _emailController,
              validator: (value) {
                if (value == null) {
                  return 'Please Enter Username or Email';
                }
                return null;
              },
            ),
            PassWord(
              title: 'Enter Password',
              text: 'Enter Password',
              controller: _passwordController,
            ),
            FormButton(
              text: 'Log In',
              action: _resetPassword,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                // Wrap the row with Center
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center the row horizontally
                  children: [
                    Text(
                      'Don\'t have an Account?',
                      style: TextStyle(
                        fontFamily: 'Gilmer',
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        //   ap.isSignedIn ==
                        //           true // when true, then fetch shared preference data
                        // ? Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             const DesktopScaffold()))
                        //       : Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) => const SignIn()));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignIn()));
                      },
                      child: Text(
                        ' Sign Up',
                        style: TextStyle(
                          fontFamily: 'Gilmer',
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.tertiary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(flex: 1),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ForgotPassword()));
              },
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  fontFamily: 'Gilmer',
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.tertiary,
                  fontWeight: FontWeight.w800,
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

class MobileForgotPassword extends StatefulWidget {
  const MobileForgotPassword({
    super.key,
  });

  @override
  State<MobileForgotPassword> createState() => _MobileForgotPasswordState();
}

class _MobileForgotPasswordState extends State<MobileForgotPassword> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
  // final TextEditingController _phonenumberController = TextEditingController();

  void resetPassword(String phoneNumber) async {
    final usersRef = FirebaseFirestore.instance.collection("users");
    final userQuery = usersRef.where("phone", isEqualTo: phoneNumber);
    final userSnapshot = await userQuery.get();
    final snacky = SnackBarHelper(context);

    if (userSnapshot.docs.isNotEmpty) {
      // Generate a new password
      final newPassword = generatePassword();

      // Update the user's document with the new password
      final userDoc = userSnapshot.docs.first;
      await userDoc.reference.update({
        'password': newPassword,
      });

      // Send the new password to the user (e.g., via email or SMS)

      // Provide feedback to the user

      await launchUrl(Uri.parse(
          'https://wa.me/$phoneNumber/?text=${Uri.encodeComponent('Your MavunoHub Account Password is: \n\n *$newPassword*\n\nSave it for future logins')}'));

      // Navigate to the login screen
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const LogInUser()));
      Alert.show(
        context,
        title: 'Password',
        message: '$newPassword',
        isError: true,
      );
    } else {
      snacky.showSnackBar("User not found. Please check your phone number.",
          isError: true);
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

  @override
  Widget build(BuildContext context) {
    // final ap = Provider.of<AuthProvider>(context, listen: false);
    final formKey = GlobalKey<FormState>();

    return Center(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 1),
            Padding(
              padding: const EdgeInsets.all(8.0)
                  .add(const EdgeInsets.symmetric(vertical: 40)),
              child: Image.asset('assets/mavunohub_logo.png',
                  width: 250, height: 150),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                // Wrap the row with Center
                child: Text(
                  'Enter Phone number to reset Password',
                  style: TextStyle(
                    fontFamily: 'Gilmer',
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
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
            FormButton(
              text: 'Reset Password',
              action: () {
                final phoneNumber = _phonenumberController.text.trim();
                resetPassword(phoneNumber);
              },
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

class DesktopForgotPassword extends StatefulWidget {
  const DesktopForgotPassword({
    super.key,
  });

  @override
  State<DesktopForgotPassword> createState() => _DesktopForgotPasswordState();
}

class _DesktopForgotPasswordState extends State<DesktopForgotPassword> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // final TextEditingController _phonenumberController = TextEditingController();
  void _resetPassword() async {
    // String username = _usernameController.text;
    // String phonenumber = _phonenumberController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      // User is successfully created, show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Successfully Logged In',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Gilmer',
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 16),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
      );
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const DesktopScaffold()));
      // Clear the form fields
      // Navigate to the ForgotPassword page
    } catch (e) {
      String errorMessage = "ForgotPassword error occurred. Please try again.";
      if (e is FirebaseAuthException) {
        if (e.code == 'invalid-email') {
          errorMessage = 'E-Mail is not registered to an account.';
        } else if (e.code == 'user-not-found') {
          errorMessage = 'User does not exist.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'The Password is invalid.';
        } else if (e.code == 'web-internal-error') {
          errorMessage = 'Technical Error.';
        }

        // You can handle other error codes here if needed.
      }

      // Show the error message in a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Gilmer',
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 16),
          ),
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final ap = Provider.of<AuthProvider>(context, listen: false);
    final formKey = GlobalKey<FormState>();

    return Center(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 1),
            Padding(
              padding: const EdgeInsets.all(8.0)
                  .add(const EdgeInsets.symmetric(vertical: 40)),
              child: Image.asset('assets/mavunohub_logo.png',
                  width: 250, height: 150),
            ),
            FormText(
              prefix: Icons.account_circle_rounded,
              title: 'Username or PhoneNumber',
              text: 'Username or PhoneNumber',
              controller: _emailController,
              validator: (value) {
                if (value == null) {
                  return 'Please Enter Username or Email';
                }
                return null;
              },
            ),
            PassWord(
              title: 'Enter Password',
              text: 'Enter Password',
              controller: _passwordController,
            ),
            FormButton(
              text: 'Log In',
              action: _resetPassword,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                // Wrap the row with Center
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center the row horizontally
                  children: [
                    Text(
                      'Don\'t have an Account?',
                      style: TextStyle(
                        fontFamily: 'Gilmer',
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        //   ap.isSignedIn ==
                        //           true // when true, then fetch shared preference data
                        // ? Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             const DesktopScaffold()))
                        //       : Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) => const SignIn()));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignIn()));
                      },
                      child: Text(
                        ' Sign Up',
                        style: TextStyle(
                          fontFamily: 'Gilmer',
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.tertiary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(flex: 1),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ForgotPassword()));
              },
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  fontFamily: 'Gilmer',
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.tertiary,
                  fontWeight: FontWeight.w800,
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
