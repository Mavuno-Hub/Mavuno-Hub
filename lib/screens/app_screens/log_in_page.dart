import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavunohub/responsive/mobile_body.dart';
import 'package:mavunohub/responsive/responsive_layout.dart';
import 'package:mavunohub/screens/app_screens/sign_up.dart';
import 'package:mavunohub/components/custom_button.dart';
import 'package:mavunohub/components/form_text.dart';
import 'package:mavunohub/components/password.dart';
import 'package:mavunohub/components/snacky.dart';
import 'package:mavunohub/user_controller.dart';
import 'forgot_password.dart';

class LogInUser extends StatefulWidget {
  const LogInUser({Key? key});

  @override
  State<LogInUser> createState() => _LogInState();
}

class _LogInState extends State<LogInUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ResponsiveLayout(
        desktopBody: DesktopLogIn(),
        mobileBody: MobileLogIn(),
        tabletBody: TabletLogIn(),
      ),
    );
  }
}

class TabletLogIn extends StatefulWidget {
  const TabletLogIn({
    Key? key,
  });

  @override
  State<TabletLogIn> createState() => _TabletLogInState();
}

class _TabletLogInState extends State<TabletLogIn> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void login() async {
    final String identifier = _usernameController.text.trim();
    final String password = _passwordController.text.trim();
    SnackBarHelper snacky = SnackBarHelper(context);

    if (password.isEmpty && identifier.isEmpty) {
      snacky.showSnackBar("Please Enter Details to Log In", isError: true);
      return;
    } else if (password.isEmpty) {
      snacky.showSnackBar("Please Enter Password", isError: true);
    } else if (identifier.isEmpty) {
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

        if (usersByUsername.docs.isNotEmpty) {
          final userData =
              usersByUsername.docs.first.data() as Map<String, dynamic>;
          final username =
              userData['username'].split(' ')[0]; // Get the first word
          // Successfully logged in with username, pass user data to MobileScaffold
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MobileScaffold(username: username),
            ),
          );
          _usernameController.clear();
          _passwordController.clear();
        } else {
          // Username was not found, so check with phone number
          final QuerySnapshot usersByPhone = await FirebaseFirestore.instance
              .collection('users')
              .where('phone', isEqualTo: identifier)
              .where('password', isEqualTo: password)
              .get();

          if (usersByPhone.docs.isNotEmpty) {
            final userData =
                usersByPhone.docs.first.data() as Map<String, dynamic>;
            final username =
                userData['username'].split(' ')[0]; // Get the first word
            // Successfully logged in with phone number, pass user data to MobileScaffold
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MobileScaffold(username: username),
              ),
            );
            _usernameController.clear();
            _passwordController.clear();
          } else {
            // No matching user found with the provided credentials
            snacky.showSnackBar("Invalid Login details", isError: true);
            _usernameController.clear();
            _passwordController.clear();
          }
        }
      } on FirebaseException catch (e) {
        // Handle database query errors
        snacky.showSnackBar(e.toString(), isError: true);
      }
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
              padding: const EdgeInsets.all(8.0)
                  .add(const EdgeInsets.symmetric(vertical: 40)),
              child: Image.asset('assets/mavunohub_logo.png',
                  width: 250, height: 150),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
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
            Column(
              children: [
                SizedBox(
                  width: 400,
                  child: Column(
                    children: [
                      Material(
                        color: Theme.of(context).colorScheme.background,
                        child: FormText(
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
                      ),
                      PassWord(
                        title: 'Enter Password',
                        text: 'Enter Password',
                        controller: _passwordController,
                      ),
                    ],
                  ),
                )
              ],
            ),
            FormButton(
              text: 'Log In',
              action: login,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                            builder: (context) => const SignUp(),
                          ),
                        );
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ForgotPassword(),
                  ),
                );
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
    Key? key,
  });

  @override
  State<MobileLogIn> createState() => _MobileLogInState();
}

class _MobileLogInState extends State<MobileLogIn> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final UserController userController = Get.find(); // Access the UserController
void login() async {
  final String identifier = _usernameController.text?.trim() ?? '';
  final String password = _passwordController.text?.trim() ?? '';
  SnackBarHelper snacky = SnackBarHelper(context);

  if (password.isEmpty || identifier.isEmpty) {
    snacky.showSnackBar("Please Enter Both Username and Password", isError: true);
    return;
  } else {
    try {
      final usersQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: identifier)
          .where('password', isEqualTo: password)
          .get();

      if (usersQuery.docs.isNotEmpty) {
        final userData = usersQuery.docs.first.data() as Map<String, dynamic>;
        final fetchUsername = userData['username']?.split(' ')[0] ?? '';
        final newEmail = userData['email'] ?? '';

        // Update the UserController with user data
        userController.updateUserData(fetchUsername, newEmail);
        userController.fetchUserDataFromFirestore();

        // Successfully logged in, navigate to the dashboard
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MobileScaffold(username: fetchUsername),
          ),
        );
        _usernameController.clear();
        _passwordController.clear();
      } else {
        // No matching user found with the provided credentials
        snacky.showSnackBar("Invalid Login Details", isError: true);
      }
    } on FirebaseException catch (e) {
      snacky.showSnackBar(e.toString(), isError: true);
    }
  }
}
  



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
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
              Material(
                color: Theme.of(context).colorScheme.background,
                child: Column(
                  children: [
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
                  ],
                ),
              ),
              FormButton(
                text: 'Log In',
                action: login,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                              builder: (context) => const SignUp(),
                            ),
                          );
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ForgotPassword(),
                    ),
                  );
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
      ),
    );
  }
}

class DesktopLogIn extends StatefulWidget {
  const DesktopLogIn({
    Key? key,
  });

  @override
  State<DesktopLogIn> createState() => _DesktopLogInState();
}

class _DesktopLogInState extends State<DesktopLogIn> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void login() async {
    final String identifier = _usernameController.text.trim();
    final String password = _passwordController.text.trim();
    SnackBarHelper snacky = SnackBarHelper(context);

    if (password.isEmpty && identifier.isEmpty) {
      snacky.showSnackBar("Please Enter Details to Log In", isError: true);
      return;
    } else if (password.isEmpty) {
      snacky.showSnackBar("Please Enter Password", isError: true);
    } else if (identifier.isEmpty) {
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

        if (usersByUsername.docs.isNotEmpty) {
          final userData =
              usersByUsername.docs.first.data() as Map<String, dynamic>;
          final username =
              userData['username'].split(' ')[0]; // Get the first word
          // Successfully logged in with username, navigate to the dashboard page
          snacky.showSnackBar("Logged in successfully", isError: false);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MobileScaffold(username: username),
            ),
          );
          _usernameController.clear();
          _passwordController.clear();
        } else {
          // Username was not found, so check with phone number
          final QuerySnapshot usersByPhone = await FirebaseFirestore.instance
              .collection('users')
              .where('phone', isEqualTo: identifier)
              .where('password', isEqualTo: password)
              .get();

          if (usersByPhone.docs.isNotEmpty) {
            final userData =
                usersByPhone.docs.first.data() as Map<String, dynamic>;
            final username =
                userData['username'].split(' ')[0]; // Get the first word
            // Successfully logged in with phone number, navigate to the dashboard page
            snacky.showSnackBar("Logged in successfully", isError: false);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MobileScaffold(username: username),
              ),
            );
            _usernameController.clear();
            _passwordController.clear();
          } else {
            // No matching user found with the provided credentials
            snacky.showSnackBar("Invalid Login details", isError: true);
            _usernameController.clear();
            _passwordController.clear();
          }
        }
      } on FirebaseException catch (e) {
        // Handle database query errors
        snacky.showSnackBar(e.toString(), isError: true);
      }
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
              padding: const EdgeInsets.all(8.0)
                  .add(const EdgeInsets.symmetric(vertical: 40)),
              child: Image.asset('assets/mavunohub_logo.png',
                  width: 250, height: 150),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
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
            Column(
              children: [
                SizedBox(
                  width: 400,
                  child: Column(
                    children: [
                      Material(
                        color: Theme.of(context).colorScheme.background,
                        child: FormText(
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
                      ),
                      PassWord(
                        title: 'Enter Password',
                        text: 'Enter Password',
                        controller: _passwordController,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            FormButton(
              text: 'Log In',
              action: login,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                            builder: (context) => const SignUp(),
                          ),
                        );
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ForgotPassword(),
                  ),
                );
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
