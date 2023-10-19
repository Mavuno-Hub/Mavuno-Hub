import 'package:flutter/material.dart';
import 'package:mavunohub/responsive/responsive_layout.dart';

class OTP extends StatefulWidget {
  
  final String verificationId; 
  const OTP({super.key, 
    required this.verificationId

  });

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: const ResponsiveLayout(
        desktopBody: DesktopOTP(),
        mobileBody: MobileOTP(),
        tabletBody: TabletOTP(),
      ),
    );
  }
}

class TabletOTP extends StatelessWidget {
  const TabletOTP({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center();
  }
}

class MobileOTP extends StatefulWidget {

  const MobileOTP({
    super.key,
  });

  @override
  State<MobileOTP> createState() => _MobileOTPState();
}

class _MobileOTPState extends State<MobileOTP> {
  @override
  Widget build(BuildContext context) {
    return const Center();
  }
}

class DesktopOTP extends StatelessWidget {
  const DesktopOTP({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Stack();
  }
}

// import 'package:flutter/material.dart';

// class OTPScreen extends StatefulWidget {
//   @override
//   _OTPScreenState createState() => _OTPScreenState();
// }

// class _OTPScreenState extends State<OTPScreen> {
//   TextEditingController otpController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       appBar: AppBar(
//         title: Text('OTP Verification'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Enter the OTP sent to your phone number',
//               style: TextStyle(fontSize: 18),
//             ),
//             SizedBox(height: 20),
//             TextField(
//               controller: otpController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: 'OTP',
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Add code to verify the OTP here
//               },
//               child: Text('Verify OTP'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
