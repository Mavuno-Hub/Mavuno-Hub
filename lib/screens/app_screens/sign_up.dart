// ignore_for_file: use_build_context_synchronously

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mavunohub/components/alert.dart';
import 'package:mavunohub/responsive/responsive_layout.dart';
import 'package:mavunohub/screens/app_screens/term_&_conditions.dart';
// import 'package:mavunohub/responsive/mobile_body.dart';
// import 'package:mavunohub/responsive/responsive_layout.dart';
// import 'package:mavunohub/screens/app_screens/log_in.dart';
import 'package:mavunohub/components/snacky.dart' as snackBarHelper;
import '../../components/custom_button.dart';
import '../../components/form_text.dart';
import '../../components/phone_field.dart';
import '../../components/snacky.dart';
import 'package:url_launcher/url_launcher.dart';
import 'log_in_page.dart';
import 'package:mavunohub/screens/app_screens/log_in_page.dart'
    show SnackBarHelper;
import 'package:mavunohub/components/snacky.dart' as snacky;

class SignUp extends StatefulWidget {
  const SignUp({super.key});

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
      body: const ResponsiveLayout(
        desktopBody: DesktopSignUp(),
        mobileBody: MobileSignUp(),
        tabletBody: TabletSignUp(),
      ),
      // body: const MobileSignUp(),
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
  bool _acceptTerms = false;

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
// final snacky = snacky.SnackBarHelper(context);
    final snacky = snackBarHelper.SnackBarHelper(context);
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
    if (!_acceptTerms) {
      snacky.showSnackBar("Accept the terms and conditions to Log inx",
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
        'terms_accepted': _acceptTerms,
      });

      // Send the password to the user's WhatsApp account
      await launchUrl(Uri.parse(
          'https://wa.me/$phone/?text=${Uri.encodeComponent('Your MavunoHub Account Password is: \n\n *$password*\n\nSave it for future logins')}'));

      // Navigate to the login screen
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LogInUser()));
      Alert.show(
        context,
        title: 'Password',
        message: password,
        isError: true,
      );
    } catch (e) {
      snacky.showSnackBar("An error occurred: $e", isError: true);
      print("An error occurred: $e");
    }
  }

  String generatePassword() {
    const String capitalLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String smallLetters = 'abcdefghijklmnopqrstuvwxyz';
    const String specialCharacters = '!@#\$%^&*()_-+=<>?';
    const String numbers = '0123456789';

    const String passwordString =
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

  @override
  Widget build(BuildContext context) {
    bool isChecked = false;
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
              SizedBox(
                width: 400,
                child: Column(
                  children: [
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
                  ],
                ),
              ),

              FormButton(
                text: 'Create Account',
                // action: _signUp
                action: () {
                  _signUp();
                },
              ),
            ]),
            Container(
                width: 300,
                height: 40,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        visualDensity: VisualDensity.compact,
                        checkColor: Theme.of(context).colorScheme.tertiary,
                        value: _acceptTerms,
                        onChanged: (bool? newValue) {
                          setState(() {
                            _acceptTerms = newValue ?? false;
                          });
                        },
                      ),
                      Text(
                        'I accept, ',
                        style: TextStyle(
                          fontFamily: 'Gilmer',
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          TermsAndConditionsDialog.show(context);
                        },
                        child: Text(
                          'the terms and conditions',
                          style: TextStyle(
                            fontFamily: 'Gilmer',
                            fontWeight: FontWeight.w700,
                            decoration:
                                TextDecoration.underline, // Add an underline
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                )),
            // Spacer(flex: 1,),
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
                                builder: (context) => MobileLogIn()));
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

class DesktopSignUp extends StatefulWidget {
  const DesktopSignUp({
    super.key,
  });

  @override
  State<DesktopSignUp> createState() => _DesktopSignUpState();
}

class _DesktopSignUpState extends State<DesktopSignUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
  bool _acceptTerms = false;

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
    final snacky = snackBarHelper.SnackBarHelper(context);
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
    if (!_acceptTerms) {
      snacky.showSnackBar("Accept the terms and conditions to Log inx",
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
        'terms_accepted': _acceptTerms,
      });

      // Send the password to the user's WhatsApp account
      await launchUrl(Uri.parse(
          'https://wa.me/$phone/?text=${Uri.encodeComponent('Your MavunoHub Account Password is: \n\n *$password*\n\nSave it for future logins')}'));

      // Navigate to the login screen
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LogInUser()));
      Alert.show(
        context,
        title: 'Password',
        message: password,
        isError: true,
      );
    } catch (e) {
      snacky.showSnackBar("An error occurred: $e", isError: true);
      print("An error occurred: $e");
    }
  }

  String generatePassword() {
    const String capitalLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String smallLetters = 'abcdefghijklmnopqrstuvwxyz';
    const String specialCharacters = '!@#\$%^&*()_-+=<>?';
    const String numbers = '0123456789';

    const String passwordString =
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

  @override
  Widget build(BuildContext context) {
    bool isChecked = false;
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
              SizedBox(
                width: 400,
                child: Column(
                  children: [
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
                  ],
                ),
              ),

              FormButton(
                text: 'Create Account',
                // action: _signUp
                action: () {
                  _signUp();
                },
              ),
            ]),
            Container(
                width: 300,
                height: 40,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        visualDensity: VisualDensity.compact,
                        checkColor: Theme.of(context).colorScheme.tertiary,
                        value: _acceptTerms,
                        onChanged: (bool? newValue) {
                          setState(() {
                            _acceptTerms = newValue ?? false;
                          });
                        },
                      ),
                      Text(
                        'I accept, ',
                        style: TextStyle(
                          fontFamily: 'Gilmer',
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          TermsAndConditionsDialog.show(context);
                        },
                        child: Text(
                          'the terms and conditions',
                          style: TextStyle(
                            fontFamily: 'Gilmer',
                            fontWeight: FontWeight.w700,
                            decoration:
                                TextDecoration.underline, // Add an underline
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                )),
            // Spacer(flex: 1,),
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
                                builder: (context) => LogInUser()));
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

class TabletSignUp extends StatefulWidget {
  const TabletSignUp({
    super.key,
  });

  @override
  State<TabletSignUp> createState() => _TabletSignUpState();
}

class _TabletSignUpState extends State<TabletSignUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
  bool _acceptTerms = false;

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
    final snacky = snackBarHelper.SnackBarHelper(context);

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
    if (!_acceptTerms) {
      snacky.showSnackBar("Accept the terms and conditions to Log inx",
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
        'terms_accepted': _acceptTerms,
      });

      // Send the password to the user's WhatsApp account
      await launchUrl(Uri.parse(
          'https://wa.me/$phone/?text=${Uri.encodeComponent('Your MavunoHub Account Password is: \n\n *$password*\n\nSave it for future logins')}'));

      // Navigate to the login screen
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LogInUser()));
      Alert.show(
        context,
        title: 'Password',
        message: password,
        isError: true,
      );
    } catch (e) {
      snacky.showSnackBar("An error occurred: $e", isError: true);
      print("An error occurred: $e");
    }
  }

  String generatePassword() {
    const String capitalLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String smallLetters = 'abcdefghijklmnopqrstuvwxyz';
    const String specialCharacters = '!@#\$%^&*()_-+=<>?';
    const String numbers = '0123456789';

    const String passwordString =
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

  @override
  Widget build(BuildContext context) {
    bool isChecked = false;
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
              SizedBox(
                width: 400,
                child: Column(
                  children: [
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
                  ],
                ),
              ),

              FormButton(
                text: 'Create Account',
                // action: _signUp
                action: () {
                  _signUp();
                },
              ),
            ]),
            Container(
                width: 300,
                height: 40,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        visualDensity: VisualDensity.compact,
                        checkColor: Theme.of(context).colorScheme.tertiary,
                        value: _acceptTerms,
                        onChanged: (bool? newValue) {
                          setState(() {
                            _acceptTerms = newValue ?? false;
                          });
                        },
                      ),
                      Text(
                        'I accept, ',
                        style: TextStyle(
                          fontFamily: 'Gilmer',
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          TermsAndConditionsDialog.show(context);
                        },
                        child: Text(
                          'the terms and conditions',
                          style: TextStyle(
                            fontFamily: 'Gilmer',
                            fontWeight: FontWeight.w700,
                            decoration:
                                TextDecoration.underline, // Add an underline
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                )),
            // Spacer(flex: 1,),
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
                                builder: (context) => TabletLogIn()));
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
