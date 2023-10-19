// // otp_screen.dart

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class OTPScreen extends StatefulWidget {
//   final String phoneNumber;
//   final String verificationId;

//   OTPScreen({required this.phoneNumber, required this.verificationId});

//   @override
//   _OTPScreenState createState() => _OTPScreenState();
// }

// class _OTPScreenState extends State<OTPScreen> {
//   final TextEditingController smsCodeController = TextEditingController();

//   // Function to complete phone number verification
//   void completePhoneNumberVerification() async {
//     String smsCode = smsCodeController.text;
//     String phoneNumber = widget.phoneNumber; // Get the phone number from the widget
//     String verificationId = widget.verificationId; // Get the verification ID from the widget

//     if (smsCode.isNotEmpty) {
//       try {
//         User? user = await signUpWithPhoneNumber(phoneNumber, verificationId, smsCode);

//         if (user != null) {
//           // Verification successful, you can navigate to a success screen or perform other actions.
//           // For example, navigate to the home screen.
//           // Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
//         } else {
//           // Handle unsuccessful verification
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                 'Verification failed. Please try again.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontFamily: 'Gilmer',
//                   fontWeight: FontWeight.w700,
//                   color: Theme.of(context).colorScheme.onBackground,
//                   fontSize: 16,
//                 ),
//               ),
//               backgroundColor: Theme.of(context).colorScheme.errorContainer,
//             ),
//           );
//         }
//       } catch (e) {
//         // Handle errors
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               'An error occurred. Please try again.',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontFamily: 'Gilmer',
//                 fontWeight: FontWeight.w700,
//                 color: Theme.of(context).colorScheme.onBackground,
//                 fontSize: 16,
//               ),
//             ),
//             backgroundColor: Theme.of(context).colorScheme.errorContainer,
//           ),
//         );
//       }
//     } else {
//       // Handle missing SMS code or show an error message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'Please enter the SMS code.',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontFamily: 'Gilmer',
//               fontWeight: FontWeight.w700,
//               color: Theme.of(context).colorScheme.onBackground,
//               fontSize: 16,
//             ),
//           ),
//           backgroundColor: Theme.of(context).colorScheme.errorContainer,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('OTP Verification'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Enter the SMS code sent to your phone number:',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             SizedBox(height: 20),
//             Container(
//               width: 200,
//               child: TextField(
//                 controller: smsCodeController,
//                 keyboardType: TextInputType.number,
//                 textAlign: TextAlign.center,
//                 decoration: InputDecoration(
//                   labelText: 'SMS Code',
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 completePhoneNumberVerification();
//               },
//               child: Text('Verify'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
