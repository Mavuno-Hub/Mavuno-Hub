// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mavunohub/user_controller.dart';

// class Status extends StatefulWidget {
//   @override
//   _StatusState createState() => _StatusState();
// }

// class _StatusState extends State<Status> {
//   final UserController userController = Get.find<UserController>();

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<int>(
//       future: userController.getServiceCount(), // Assuming you have a method in UserController to get the service count
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           final int serviceCount = snapshot.data ?? 0;

//           return Container(
//             padding: EdgeInsets.all(10.0),  
//             child: Text(
//               'Number of Services: $serviceCount',
//               style: TextStyle(
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           );
//         } else {
//           return Container(
//             padding: EdgeInsets.all(10.0),
//             child: CircularProgressIndicator(),
//           );
//         }
//       },
//     );
//   }
// }
