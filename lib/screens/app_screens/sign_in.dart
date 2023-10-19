// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mavunohub/auth/firebase_auth_service.dart';
import 'package:mavunohub/responsive/responsive_layout.dart';
import 'package:mavunohub/screens/app_screens/log_in_page.dart';
import '../../components/custom_button.dart';
import '../../components/form_text.dart';
import '../../components/password.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: const ResponsiveLayout(
        desktopBody: DesktopSignIn(),
        mobileBody: MobileSignIn(),
        tabletBody: TabletSignIn(),
      ),
    );
  }
}

class TabletSignIn extends StatefulWidget {
  const TabletSignIn({
    super.key,
  });

  @override
  State<TabletSignIn> createState() => _TabletSignInState();
}

class _TabletSignInState extends State<TabletSignIn> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
  // This asynchronous function handles user registration with Firebase Authentication.

  final FirebaseAuthService _auth = FirebaseAuthService();

  void _signUpWithEmail() async {
    // String username = _usernameController.text;
    // String phonenumber = _phonenumberController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      User? user = await _auth.signUpWithEmailAndPassword(email, password);

      // User is successfully created, show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Successfully created, Now Log In',
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
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const LogInUser()));
      // Clear the form fields
      // Navigate to the login page
    } catch (e) {
      String errorMessage = "An error occurred. Please try again.";
      if (e is FirebaseAuthException) {
        if (e.code == 'weak-password') {
          errorMessage =
              'Password is too weak. Please use a stronger password.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'An account with this email already exists.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'The E-Mail is invalid.';
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

  void _signUpWithPhoneNumber() async {
    String phoneNumber = _phonenumberController.text;

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Successfully created, Now Log In',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Gilmer',
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 16,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
      );
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const LogInUser()));
      // Clear the form fields
      _phonenumberController.clear();
      // Navigate to the login page
    } catch (e) {
      String errorMessage = "An error occurred. Please try again.";
      if (e is FirebaseAuthException) {
        if (e.code == 'your-error-code') {
          errorMessage = 'Your custom error message.';
        } else {
          // Handle other error codes if needed.
        }
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
              fontSize: 16,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
        ),
      );
    }
  }

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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/mavunohub_logo.png',
                  width: 250, height: 150),
            ),
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
            FormText(
              prefix: Icons.email_rounded,
              title: 'Enter Email',
              text: 'Enter Email',
              validator: (value) {
                if (value == null) {
                  return 'Please Enter Name';
                }
                return null;
              },
              controller: _emailController,
            ),
            FormText(
              prefix: Icons.phone_iphone_rounded,
              title: 'Enter PhoneNumber',
              text: 'Enter PhoneNumber',
              validator: (value) {
                if (value == null) {
                  return 'Please Enter Name';
                }
                return null;
              },
              controller: _phonenumberController,
            ),
            PassWord(
              title: 'Create Password', // Updated the title to 'Password'
              text: 'Create Password',
              controller: _passwordController,
            ),
            // PassWord(
            //   title: 'Confirm Password', // Updated the title to 'Password'
            //   text: 'Confirm Password',
            //   controller: _passwordController,
            // ),
            FormButton(
              text: 'Create Account',
              action: _signUpWithEmail,
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
                      'Already have an Account?',
                      style: TextStyle(
                        fontFamily: 'Gilmer',
                        fontSize: 12,
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
                          fontSize: 13,
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

class MobileSignIn extends StatefulWidget {
  const MobileSignIn({
    super.key,
  });

  @override
  State<MobileSignIn> createState() => _MobileSignInState();
}

class _MobileSignInState extends State<MobileSignIn> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
  // This asynchronous function handles user registration with Firebase Authentication.

  final FirebaseAuthService _auth = FirebaseAuthService();

  void _signUpWithEmail() async {
    // String username = _usernameController.text;
    // String phonenumber = _phonenumberController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      User? user = await _auth.signUpWithEmailAndPassword(email, password);

      // User is successfully created, show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Successfully created, Now Log In',
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
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const LogInUser()));
      // Clear the form fields
      // Navigate to the login page
    } catch (e) {
      String errorMessage = "An error occurred. Please try again.";
      if (e is FirebaseAuthException) {
        if (e.code == 'weak-password') {
          errorMessage =
              'Password is too weak. Please use a stronger password.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'An account with this email already exists.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'The E-Mail is invalid.';
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

  void _signUpWithPhoneNumber() async {
    String phoneNumber = _phonenumberController.text;

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Successfully created, Now Log In',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Gilmer',
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 16,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
      );
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const LogInUser()));
      // Clear the form fields
      _phonenumberController.clear();
      // Navigate to the login page
    } catch (e) {
      String errorMessage = "An error occurred. Please try again.";
      if (e is FirebaseAuthException) {
        if (e.code == 'your-error-code') {
          errorMessage = 'Your custom error message.';
        } else {
          // Handle other error codes if needed.
        }
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
              fontSize: 16,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
        ),
      );
    }
  }

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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/mavunohub_logo.png',
                  width: 250, height: 150),
            ),
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
            FormText(
              prefix: Icons.email_rounded,
              title: 'Enter Email',
              text: 'Enter Email',
              validator: (value) {
                if (value == null) {
                  return 'Please Enter Name';
                }
                return null;
              },
              controller: _emailController,
            ),
            FormText(
              prefix: Icons.phone_iphone_rounded,
              title: 'Enter PhoneNumber',
              text: 'Enter PhoneNumber',
              validator: (value) {
                if (value == null) {
                  return 'Please Enter Name';
                }
                return null;
              },
              controller: _phonenumberController,
            ),
            PassWord(
              title: 'Create Password', // Updated the title to 'Password'
              text: 'Create Password',
              controller: _passwordController,
            ),
            // PassWord(
            //   title: 'Confirm Password', // Updated the title to 'Password'
            //   text: 'Confirm Password',
            //   controller: _passwordController,
            // ),
            FormButton(
              text: 'Create Account',
              action: _signUpWithEmail,
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
                      'Already have an Account?',
                      style: TextStyle(
                        fontFamily: 'Gilmer',
                        fontSize: 12,
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
                          fontSize: 13,
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

class DesktopSignIn extends StatefulWidget {
  const DesktopSignIn({
    super.key,
  });

  @override
  State<DesktopSignIn> createState() => _DesktopSignInState();
}

class _DesktopSignInState extends State<DesktopSignIn> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
  // This asynchronous function handles user registration with Firebase Authentication.

  final FirebaseAuthService _auth = FirebaseAuthService();

  void _signUpWithEmail() async {
    // String username = _usernameController.text;
    // String phonenumber = _phonenumberController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      User? user = await _auth.signUpWithEmailAndPassword(email, password);

      // User is successfully created, show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Successfully created, Now Log In',
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
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const LogInUser()));
      // Clear the form fields
      // Navigate to the login page
    } catch (e) {
      String errorMessage = "An error occurred. Please try again.";
      if (e is FirebaseAuthException) {
        if (e.code == 'weak-password') {
          errorMessage =
              'Password is too weak. Please use a stronger password.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'An account with this email already exists.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'The E-Mail is invalid.';
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

  void _signUpWithPhoneNumber() async {
    String phoneNumber = _phonenumberController.text;

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Successfully created, Now Log In',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Gilmer',
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 16,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
      );
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const LogInUser()));
      // Clear the form fields
      _phonenumberController.clear();
      // Navigate to the login page
    } catch (e) {
      String errorMessage = "An error occurred. Please try again.";
      if (e is FirebaseAuthException) {
        if (e.code == 'your-error-code') {
          errorMessage = 'Your custom error message.';
        } else {
          // Handle other error codes if needed.
        }
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
              fontSize: 16,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
        ),
      );
    }
  }

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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/mavunohub_logo.png',
                  width: 250, height: 150),
            ),
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
            FormText(
              prefix: Icons.email_rounded,
              title: 'Enter Email',
              text: 'Enter Email',
              validator: (value) {
                if (value == null) {
                  return 'Please Enter Name';
                }
                return null;
              },
              controller: _emailController,
            ),
            FormText(
              prefix: Icons.phone_iphone_rounded,
              title: 'Enter PhoneNumber',
              text: 'Enter PhoneNumber',
              validator: (value) {
                if (value == null) {
                  return 'Please Enter Name';
                }
                return null;
              },
              controller: _phonenumberController,
            ),
            PassWord(
              title: 'Create Password', // Updated the title to 'Password'
              text: 'Create Password',
              controller: _passwordController,
            ),
            // PassWord(
            //   title: 'Confirm Password', // Updated the title to 'Password'
            //   text: 'Confirm Password',
            //   controller: _passwordController,
            // ),
            FormButton(
              text: 'Create Account',
              action: _signUpWithEmail,
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
                      'Already have an Account?',
                      style: TextStyle(
                        fontFamily: 'Gilmer',
                        fontSize: 12,
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
                          fontSize: 13,
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
