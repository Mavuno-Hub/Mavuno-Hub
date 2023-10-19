// import 'package:firebase_auth/firebase_auth.dart';
// ignore_for_file: use_build_context_synchronously, avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mavunohub/auth/auth_service.dart';
import 'package:mavunohub/responsive/mobile_body.dart';
import 'package:mavunohub/responsive/responsive_layout.dart';
import 'package:mavunohub/screens/app_screens/sign_in.dart';
import 'package:mavunohub/screens/app_screens/sign_up.dart';
import 'package:provider/provider.dart';
import '../../auth/firebase_auth_service.dart';
import '../../components/custom_button.dart';
import '../../components/form_text.dart';
import '../../components/password.dart';
import '../../components/snacky.dart';
import '../../responsive/desktop_body.dart';
import '../../responsive/tablet_body.dart';
import 'forgot_password.dart';

class LogInUser extends StatefulWidget {
  const LogInUser({Key? key}) : super(key: key);

  @override
  State<LogInUser> createState() => _LogInState();
}

class _LogInState extends State<LogInUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: const ResponsiveLayout(
        desktopBody: DesktopLogIn(),
        mobileBody: MobileLogIn(),
        tabletBody: TabletLogIn(),
      ),
    );
  }
}

class TabletLogIn extends StatefulWidget {
  const TabletLogIn({
    super.key,
  });

  @override
  State<TabletLogIn> createState() => _TabletLogInState();
}

class _TabletLogInState extends State<TabletLogIn> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // final TextEditingController _phonenumberController = TextEditingController();
  void _logIn() async {
    // String username = _usernameController.text;
    // String phonenumber = _phonenumberController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      User? user = await _auth.logInWithEmailAndPassword(email, password);

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
      // Navigate to the login page
    } catch (e) {
      String errorMessage = "Login error occurred. Please try again.";
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
                  'Welcome back, Log in to continue',
                  style: TextStyle(
                    fontFamily: 'Gilmer',
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
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
              action: _logIn,
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

class MobileLogIn extends StatefulWidget {
  const MobileLogIn({
    super.key,
  });

  @override
  State<MobileLogIn> createState() => _MobileLogInState();
}

class _MobileLogInState extends State<MobileLogIn> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // final TextEditingController _phonenumberController = TextEditingController();

  void login() async {
    final String identifier = _usernameController.text;
    final String password = _passwordController.text;
    SnackBarHelper snacky = SnackBarHelper(context);

    if (password.isEmpty && identifier.isEmpty) {
      print("Please Enter Details to Log In");
      _formKey.currentState?.reset();
      snacky.showSnackBar("Please Enter Details to Log In", isError: true);
      return;
    } else if (password.isEmpty) {
      print("Please Enter Password");
      snacky.showSnackBar("Please Enter Password", isError: true);
    } else if (identifier.isEmpty) {
      print("Please Enter either Username or phone number");
      snacky.showSnackBar("Please Enter either Username or phone number",
          isError: true);
    } else {
      try {
        // Check if the username exists
        final QuerySnapshot usersByUsername = await FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: identifier)
            .where('password', isEqualTo: password)
            .get();
            _usernameController.clear();
            _passwordController.clear();

        if (usersByUsername.docs.isNotEmpty) {
          // Successfully logged in with username, navigate to the dashboard page
          _formKey.currentState?.reset();
          print("Logged in successfully with username");
          snacky.showSnackBar("Logged in successfully", isError: false);
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const MobileScaffold()));
          _usernameController.clear();
          _passwordController.clear();
        } else {
          // Username was not found, so check with phone number
          final QuerySnapshot usersByPhone = await FirebaseFirestore.instance
              .collection('users')
              .where('phone', isEqualTo: identifier)
              .where('password', isEqualTo: password)
              .get();
              _usernameController.clear();
            _passwordController.clear();

          if (usersByPhone.docs.isNotEmpty) {
            // Successfully logged in with phone number, navigate to the dashboard page
            _formKey.currentState?.reset();
            print("Logged in successfully with phone number");
            snacky.showSnackBar("Logged in successfully", isError: false);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const MobileScaffold()));
            _usernameController.clear();
            _passwordController.clear();
          } else {
            // No matching user found with the provided credentials
            print("Invalid Login details");
            snacky.showSnackBar("Invalid Login details", isError: true);
            _usernameController.clear();
            _passwordController.clear();
          }
        }
      } on FirebaseException catch (e) {
        // Handle database query errors
        print('Error: $e');
        snacky.showSnackBar(e.toString(), isError: true);
      }
    }
  }

  // void _logInUser() async {
  //   final String username = _usernameController.text.trim();
  //   final String password = _passwordController.text.trim();
  //   SnackBarHelper snacky = SnackBarHelper(context);
  //   if (username.isEmpty) {
  //     print("Username is Empty");
  //     snacky.showSnackBar("Username is Empty", isError: true);
  //   } else if (password.isEmpty) {
  //     print("Password is empty");
  //     snacky.showSnackBar("Password is Empty", isError: true);
  //   } else if (password.isEmpty && username.isEmpty) {
  //     // This one finds the doc that contains the username
  //     QuerySnapshot snap = await FirebaseFirestore.instance
  //         .collection("users")
  //         .where("username", isEqualTo: username)
  //         .get();
  //     _formKey.currentState?.reset();
  //     try {
  //       if (snap.docs.isNotEmpty) {
  //         // Check if there are documents in the snapshot
  //         context.read<AuthService>().login(snap.docs[0]['email'], password);

  //         Navigator.of(context).push(
  //             MaterialPageRoute(builder: (context) => const MobileScaffold()));
  //         snacky.showSnackBar("Logged in successfuly", isError: false);
  //       } else if (snap.docs.isEmpty && password.isNotEmpty) {
  //         print("User doesn't Exist");
  //         snacky.showSnackBar("User doesn't exist", isError: true);
  //         // Handle the case where no user was found with the provided username.
  //       } else if (snap.docs.isNotEmpty && password.isEmpty) {
  //         print("Enter Password");
  //         snacky.showSnackBar("Enter Password", isError: true);
  //         // Handle the case where no user was found with the provided username.
  //       }
  //     } on FirebaseAuthException catch (e) {
  //       snacky.showSnackBar(e.toString(), isError: true);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // final ap = Provider.of<AuthProvider>(context, listen: false);

    SnackBarHelper snacky = SnackBarHelper(context);
    return Center(
      child: Form(
        key: _formKey,
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
                  'Welcome back, Log in to continue',
                  style: TextStyle(
                    fontFamily: 'Gilmer',
                    fontSize: 17,
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            FormText(
              prefix: Icons.account_circle_rounded,
              title: 'Username or PhoneNumber',
              text: 'Username or PhoneNumber',
              controller: _usernameController,
              validator: (value) {
                if (value == null) {
                  return 'Please Enter Username';
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
              action: login,
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
                                builder: (context) => const SignUp()));
                      },
                      child: Text(
                        ' Sign Up',
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

class DesktopLogIn extends StatefulWidget {
  const DesktopLogIn({
    super.key,
  });

  @override
  State<DesktopLogIn> createState() => _DesktopLogInState();
}

class _DesktopLogInState extends State<DesktopLogIn> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // final TextEditingController _phonenumberController = TextEditingController();
  void _logIn() async {
    // String username = _usernameController.text;
    // String phonenumber = _phonenumberController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      User? user = await _auth.logInWithEmailAndPassword(email, password);

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
      // Navigate to the login page
    } catch (e) {
      String errorMessage = "Login error occurred. Please try again.";
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
              action: _logIn,
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
