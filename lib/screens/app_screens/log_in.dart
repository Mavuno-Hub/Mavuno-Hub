// // import 'package:firebase_auth/firebase_auth.dart';
// // ignore_for_file: use_build_context_synchronously, avoid_print

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:mavunohub/responsive/mobile_body.dart';
// import 'package:mavunohub/responsive/responsive_layout.dart';
// import 'package:mavunohub/screens/app_screens/sign_in.dart';
// import '../../auth/firebase_auth_service.dart';
// import '../../components/custom_button.dart';
// import '../../components/form_text.dart';
// import '../../components/password.dart';
// import '../../responsive/desktop_body.dart';
// import '../../responsive/tablet_body.dart';
// import 'forgot_password.dart';

// class LogIn extends StatefulWidget {
//   const LogIn({Key? key}) : super(key: key);

//   @override
//   State<LogIn> createState() => _LogInState();
// }

// class _LogInState extends State<LogIn> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       body: const ResponsiveLayout(
//         desktopBody: DesktopLogIn(),
//         mobileBody: MobileLogIn(),
//         tabletBody: TabletLogIn(),
//       ),
//     );
//   }
// }

// class TabletLogIn extends StatefulWidget {
//   const TabletLogIn({
//     super.key,
//   });

//   @override
//   State<TabletLogIn> createState() => _TabletLogInState();
// }

// class _TabletLogInState extends State<TabletLogIn> {
//   final FirebaseAuthService _auth = FirebaseAuthService();
//   final TextEditingController _emailController = TextEditingController();
//   // final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   // final TextEditingController _phonenumberController = TextEditingController();
//   void _logIn() async {
//     // String username = _usernameController.text;
//     // String phonenumber = _phonenumberController.text;
//     String email = _emailController.text;
//     String password = _passwordController.text;

//     try {
//       User? user = await _auth.logInWithEmailAndPassword(email, password);

//       // User is successfully created, show a snackbar
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'Successfully Logged In',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//                 fontFamily: 'Gilmer',
//                 fontWeight: FontWeight.w700,
//                 color: Theme.of(context).colorScheme.onBackground,
//                 fontSize: 16),
//           ),
//           backgroundColor: Theme.of(context).colorScheme.surface,
//         ),
//       );
//       Navigator.of(context).push(
//           MaterialPageRoute(builder: (context) => const TabletScaffold()));
//       // Clear the form fields
//       // Navigate to the login page
//     } catch (e) {
//       String errorMessage = "Login error occurred. Please try again.";
//       if (e is FirebaseAuthException) {
//         if (e.code == 'invalid-email') {
//           errorMessage = 'E-Mail is not registered to an account.';
//         } else if (e.code == 'user-not-found') {
//           errorMessage = 'User does not exist.';
//         } else if (e.code == 'wrong-password') {
//           errorMessage = 'The Password is invalid.';
//         } else if (e.code == 'web-internal-error') {
//           errorMessage = 'Technical Error.';
//         }

//         // You can handle other error codes here if needed.
//       }

//       // Show the error message in a snackbar
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             errorMessage,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//                 fontFamily: 'Gilmer',
//                 fontWeight: FontWeight.w700,
//                 color: Theme.of(context).colorScheme.onBackground,
//                 fontSize: 16),
//           ),
//           backgroundColor: Theme.of(context).colorScheme.errorContainer,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final ap = Provider.of<AuthProvider>(context, listen: false);
//     final _formKey = GlobalKey<FormState>();

//     return Center(
//       child: Form(
//         key: _formKey,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const Spacer(flex: 1),
//             Padding(
//               padding: const EdgeInsets.all(8.0)
//                   .add(const EdgeInsets.symmetric(vertical: 40)),
//               child: Image.asset('assets/mavunohub_logo.png',
//                   width: 250, height: 150),
//             ),
//             FormText(
//               prefix: Icons.account_circle_rounded,
//               title: 'Username or PhoneNumber',
//               text: 'Username or PhoneNumber',
//               controller: _emailController,
//               validator: (value) {
//                 if (value == null) {
//                   return 'Please Enter Username or Email';
//                 }
//                 return null;
//               },
//             ),
//             PassWord(
//               title: 'Enter Password',
//               text: 'Enter Password',
//               controller: _passwordController,
//             ),
//             FormButton(
//               text: 'Log In',
//               action: _logIn,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Center(
//                 // Wrap the row with Center
//                 child: Row(
//                   mainAxisAlignment:
//                       MainAxisAlignment.center, // Center the row horizontally
//                   children: [
//                     Text(
//                       'Don\'t have an Account?',
//                       style: TextStyle(
//                         fontFamily: 'Gilmer',
//                         fontSize: 16,
//                         color: Theme.of(context).colorScheme.onBackground,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         //   ap.isSignedIn ==
//                         //           true // when true, then fetch shared preference data
//                         // ? Navigator.push(
//                         //     context,
//                         //     MaterialPageRoute(
//                         //         builder: (context) =>
//                         //             const DesktopScaffold()))
//                         //       : Navigator.push(
//                         //           context,
//                         //           MaterialPageRoute(
//                         //               builder: (context) => const SignIn()));
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const SignIn()));
//                       },
//                       child: Text(
//                         ' Sign Up',
//                         style: TextStyle(
//                           fontFamily: 'Gilmer',
//                           fontSize: 12,
//                           color: Theme.of(context).colorScheme.tertiary,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const Spacer(flex: 1),
//             GestureDetector(
//               onTap: () {
//                 Navigator.of(context).push(MaterialPageRoute(
//                     builder: (context) => const ForgotPassword()));
//               },
//               child: Text(
//                 'Forgot Password?',
//                 style: TextStyle(
//                   fontFamily: 'Gilmer',
//                   fontSize: 15,
//                   color: Theme.of(context).colorScheme.tertiary,
//                   fontWeight: FontWeight.w800,
//                 ),
//               ),
//             ),
//             const Spacer(flex: 1),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class MobileLogIn extends StatefulWidget {
//   const MobileLogIn({
//     super.key,
//   });

//   @override
//   State<MobileLogIn> createState() => _MobileLogInState();
// }

// class _MobileLogInState extends State<MobileLogIn> {
//   final FirebaseAuthService _auth = FirebaseAuthService();
//   final TextEditingController _emailController = TextEditingController();
//   // final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   // final TextEditingController _phonenumberController = TextEditingController();
  
//   void _logIn() async {
//     // String username = _usernameController.text;
//     // String phonenumber = _phonenumberController.text;
//     String email = _emailController.text;
//     String password = _passwordController.text;

//     try {
//       User? user = await _auth.logInWithEmailAndPassword(email, password);

//       // User is successfully created, show a snackbar
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'Successfully Logged In',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//                 fontFamily: 'Gilmer',
//                 fontWeight: FontWeight.w700,
//                 color: Theme.of(context).colorScheme.onBackground,
//                 fontSize: 16),
//           ),
//           backgroundColor: Theme.of(context).colorScheme.surface,
//         ),
//       );
//       Navigator.of(context).push(
//           MaterialPageRoute(builder: (context) => const MobileScaffold()));
//       // Clear the form fields
//       // Navigate to the login page
//     } catch (e) {
//       String errorMessage = "Login error occurred. Please try again.";
//       if (e is FirebaseAuthException) {
//         if (e.code == 'invalid-email') {
//           errorMessage = 'E-Mail is not registered to an account.';
//         } else if (e.code == 'user-not-found') {
//           errorMessage = 'User does not exist.';
//         } else if (e.code == 'wrong-password') {
//           errorMessage = 'The Password is invalid.';
//         } else if (e.code == 'web-internal-error') {
//           errorMessage = 'Technical Error.';
//         }

//         // You can handle other error codes here if needed.
//       }

//       // Show the error message in a snackbar
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             errorMessage,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//                 fontFamily: 'Gilmer',
//                 fontWeight: FontWeight.w700,
//                 color: Theme.of(context).colorScheme.onBackground,
//                 fontSize: 16),
//           ),
//           backgroundColor: Theme.of(context).colorScheme.errorContainer,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final ap = Provider.of<AuthProvider>(context, listen: false);
//     final _formKey = GlobalKey<FormState>();

//     return Center(
//       child: Form(
//         key: _formKey,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const Spacer(flex: 1),
//             Padding(
//               padding: const EdgeInsets.all(8.0)
//                   .add(const EdgeInsets.symmetric(vertical: 40)),
//               child: Image.asset('assets/mavunohub_logo.png',
//                   width: 250, height: 150),
//             ),
//             FormText(
//               prefix: Icons.account_circle_rounded,
//               title: 'Username or PhoneNumber',
//               text: 'Username or PhoneNumber',
//               controller: _emailController,
//               validator: (value) {
//                 if (value == null) {
//                   return 'Please Enter Username or Email';
//                 }
//                 return null;
//               },
//             ),
//             PassWord(
//               title: 'Enter Password',
//               text: 'Enter Password',
//               controller: _passwordController,
//             ),
//             FormButton(
//               text: 'Log In',
//               action: _logIn,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Center(
//                 // Wrap the row with Center
//                 child: Row(
//                   mainAxisAlignment:
//                       MainAxisAlignment.center, // Center the row horizontally
//                   children: [
//                     Text(
//                       'Don\'t have an Account?',
//                       style: TextStyle(
//                         fontFamily: 'Gilmer',
//                         fontSize: 12,
//                         color: Theme.of(context).colorScheme.onBackground,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         //   ap.isSignedIn ==
//                         //           true // when true, then fetch shared preference data
//                         // ? Navigator.push(
//                         //     context,
//                         //     MaterialPageRoute(
//                         //         builder: (context) =>
//                         //             const MobileScaffold()))
//                         //       : Navigator.push(
//                         //           context,
//                         //           MaterialPageRoute(
//                         //               builder: (context) => const SignIn()));
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const SignIn()));
//                       },
//                       child: Text(
//                         ' Sign Up',
//                         style: TextStyle(
//                           fontFamily: 'Gilmer',
//                           fontSize: 14,
//                           color: Theme.of(context).colorScheme.tertiary,
//                           fontWeight: FontWeight.w800,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const Spacer(flex: 1),
//             GestureDetector(
//               onTap: () {
//                 Navigator.of(context).push(MaterialPageRoute(
//                     builder: (context) => const ForgotPassword()));
//               },
//               child: Text(
//                 'Forgot Password?',
//                 style: TextStyle(
//                   fontFamily: 'Gilmer',
//                   fontSize: 15,
//                   color: Theme.of(context).colorScheme.tertiary,
//                   fontWeight: FontWeight.w800,
//                 ),
//               ),
//             ),
//             const Spacer(flex: 1),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class DesktopLogIn extends StatefulWidget {
//   const DesktopLogIn({
//     super.key,
//   });

//   @override
//   State<DesktopLogIn> createState() => _DesktopLogInState();
// }

// class _DesktopLogInState extends State<DesktopLogIn> {
//   final FirebaseAuthService _auth = FirebaseAuthService();
//   final TextEditingController _emailController = TextEditingController();
//   // final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   // final TextEditingController _phonenumberController = TextEditingController();
//   void _logIn() async {
//     // String username = _usernameController.text;
//     // String phonenumber = _phonenumberController.text;
//     String email = _emailController.text;
//     String password = _passwordController.text;

//     try {
//       User? user = await _auth.logInWithEmailAndPassword(email, password);

//       // User is successfully created, show a snackbar
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'Successfully Logged In',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//                 fontFamily: 'Gilmer',
//                 fontWeight: FontWeight.w700,
//                 color: Theme.of(context).colorScheme.onBackground,
//                 fontSize: 16),
//           ),
//           backgroundColor: Theme.of(context).colorScheme.surface,
//         ),
//       );
//       Navigator.of(context).push(
//           MaterialPageRoute(builder: (context) => const DesktopScaffold()));
//       // Clear the form fields
//       // Navigate to the login page
//     } catch (e) {
//       String errorMessage = "Login error occurred. Please try again.";
//       if (e is FirebaseAuthException) {
//         if (e.code == 'invalid-email') {
//           errorMessage = 'E-Mail is not registered to an account.';
//         } else if (e.code == 'user-not-found') {
//           errorMessage = 'User does not exist.';
//         } else if (e.code == 'wrong-password') {
//           errorMessage = 'The Password is invalid.';
//         } else if (e.code == 'web-internal-error') {
//           errorMessage = 'Technical Error.';
//         }

//         // You can handle other error codes here if needed.
//       }

//       // Show the error message in a snackbar
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             errorMessage,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//                 fontFamily: 'Gilmer',
//                 fontWeight: FontWeight.w700,
//                 color: Theme.of(context).colorScheme.onBackground,
//                 fontSize: 16),
//           ),
//           backgroundColor: Theme.of(context).colorScheme.errorContainer,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final ap = Provider.of<AuthProvider>(context, listen: false);
//     final _formKey = GlobalKey<FormState>();

//     return Center(
//       child: Form(
//         key: _formKey,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const Spacer(flex: 1),
//             Padding(
//               padding: const EdgeInsets.all(8.0)
//                   .add(const EdgeInsets.symmetric(vertical: 40)),
//               child: Image.asset('assets/mavunohub_logo.png',
//                   width: 250, height: 150),
//             ),
//             FormText(
//               prefix: Icons.account_circle_rounded,
//               title: 'Username or PhoneNumber',
//               text: 'Username or PhoneNumber',
//               controller: _emailController,
//               validator: (value) {
//                 if (value == null) {
//                   return 'Please Enter Username or Email';
//                 }
//                 return null;
//               },
//             ),
//             PassWord(
//               title: 'Enter Password',
//               text: 'Enter Password',
//               controller: _passwordController,
//             ),
//             FormButton(
//               text: 'Log In',
//               action: _logIn,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Center(
//                 // Wrap the row with Center
//                 child: Row(
//                   mainAxisAlignment:
//                       MainAxisAlignment.center, // Center the row horizontally
//                   children: [
//                     Text(
//                       'Don\'t have an Account?',
//                       style: TextStyle(
//                         fontFamily: 'Gilmer',
//                         fontSize: 16,
//                         color: Theme.of(context).colorScheme.onBackground,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         //   ap.isSignedIn ==
//                         //           true // when true, then fetch shared preference data
//                         // ? Navigator.push(
//                         //     context,
//                         //     MaterialPageRoute(
//                         //         builder: (context) =>
//                         //             const DesktopScaffold()))
//                         //       : Navigator.push(
//                         //           context,
//                         //           MaterialPageRoute(
//                         //               builder: (context) => const SignIn()));
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const SignIn()));
//                       },
//                       child: Text(
//                         ' Sign Up',
//                         style: TextStyle(
//                           fontFamily: 'Gilmer',
//                           fontSize: 12,
//                           color: Theme.of(context).colorScheme.tertiary,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const Spacer(flex: 1),
//             GestureDetector(
//               onTap: () {
//                 Navigator.of(context).push(MaterialPageRoute(
//                     builder: (context) => const ForgotPassword()));
//               },
//               child: Text(
//                 'Forgot Password?',
//                 style: TextStyle(
//                   fontFamily: 'Gilmer',
//                   fontSize: 15,
//                   color: Theme.of(context).colorScheme.tertiary,
//                   fontWeight: FontWeight.w800,
//                 ),
//               ),
//             ),
//             const Spacer(flex: 1),
//           ],
//         ),
//       ),
//     );
//   }
// }
