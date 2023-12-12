import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mavunohub/components/appbar.dart';
import 'package:mavunohub/responsive/mobile_body.dart';
import 'package:mavunohub/screens/app_screens/billing&transactions.dart';
import 'package:mavunohub/screens/app_screens/services.dart';
import 'package:mavunohub/styles/pallete.dart';
import 'package:mavunohub/user_controller.dart';

class ViewServices extends StatefulWidget {
  const ViewServices({Key? key}) : super(key: key);

  @override
  State<ViewServices> createState() => _ViewServicesState();
}

class _ViewServicesState extends State<ViewServices> {
  final UserController userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    userController.fetchUserDataFromFirestore();
  }

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: const CustomAppBar(title: 'Services'),
          body: Center(
            child: SizedBox(
              width: 420,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TabBar(
                      dividerColor: Theme.of(context).colorScheme.tertiary,
                      indicatorColor: Theme.of(context).colorScheme.tertiary,
                      labelStyle: TextStyle(
                        fontFamily: 'Gilmer',
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.w700,
                      ),
                      tabs: const [
                        Tab(text: 'All Services'),
                        Tab(text: 'Online'),
                        Tab(text: 'Booked'),
                      ],
                      labelColor: Theme.of(context).colorScheme.tertiary,
                      unselectedLabelColor:
                          Theme.of(context).colorScheme.onBackground,
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          buildAllServicesTab(),
                          onlineServices(),
                          bookedServices(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAllServicesTab() {
    return ListView(
      children: [
        FutureBuilder<String>(
          future: userController.getUsername(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final username = snapshot.data;
              if (username != null) {
                // Pass the username to the ServiceList
                return ServiceList(username: username);
              } else {
                // Handle the case where username is null (e.g., user not authenticated)
                return Text('User not authenticated');
              }
            } else {
              // Loading indicator while fetching username
              return CircularProgressIndicator();
            }
          },
        ),
      ],
    );
  }

  Widget onlineServices() {
    return FutureBuilder<String>(
      future: userController.getUsername(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final username = snapshot.data;
          if (username != null) {
            return FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchServicesWithStatus(username, 'Online'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final List<Map<String, dynamic>> onlineServices =
                      snapshot.data ?? [];
                  if (onlineServices.isNotEmpty) {
                    return ListView.builder(
                      itemCount: onlineServices.length,
                      itemBuilder: (context, index) {
                        final serviceData = onlineServices[index];
                        return ViewData(
                          service: serviceData['service'] ?? '',
                          condition: serviceData['condition'] ?? '',
                          status: serviceData['status'] ?? '',
                          duration:
                              int.tryParse(serviceData['duration'] ?? '0') ?? 0,
                          startDate:
                              serviceData['start']?.toDate() ?? DateTime.now(),
                          endDate:
                              serviceData['end']?.toDate() ?? DateTime.now(),
                        );
                      },
                    );
                  } else {
                    return Container(
                      height: 200,
                      child: Center(
                        child: Text("No Online Services"),
                      ),
                    );
                  }
                } else {
                  return CircularProgressIndicator();
                }
              },
            );
          } else {
            return Text('User not authenticated');
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget bookedServices() {
    return FutureBuilder<String>(
      future: userController.getUsername(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final username = snapshot.data;
          if (username != null) {
            return FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchServicesWithStatus(username, 'Booked'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final List<Map<String, dynamic>> bookedServices =
                      snapshot.data ?? [];
                  if (bookedServices.isNotEmpty) {
                    return ListView.builder(
                      itemCount: bookedServices.length,
                      itemBuilder: (context, index) {
                        final serviceData = bookedServices[index];
                        return ViewData(
                          service: serviceData['service'] ?? '',
                          condition: serviceData['condition'] ?? '',
                          status: serviceData['status'] ?? '',
                          duration:
                              int.tryParse(serviceData['duration'] ?? '0') ?? 0,
                          startDate:
                              serviceData['start']?.toDate() ?? DateTime.now(),
                          endDate:
                              serviceData['end']?.toDate() ?? DateTime.now(),
                        );
                      },
                    );
                  } else {
                    return Container(
                      height: 200,
                      child: Center(
                        child: Text("No Booked Services"),
                      ),
                    );
                  }
                } else {
                  return CircularProgressIndicator();
                }
              },
            );
          } else {
            return Text('User not authenticated');
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchServicesWithStatus(
      String username, String status) async {
    try {
      final QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      String userDocId = userQuery.docs.first.id;
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userDocId)
          .collection('services')
          .where('status', isEqualTo: status)
          .limit(10)
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchBookedServices(
      String username) async {
    try {
      final QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      String userDocId = userQuery.docs.first.id;
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userDocId)
          .collection('services')
          .where('status', isEqualTo: 'Booked')
          .limit(10)
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
}

class ServiceList extends StatefulWidget {
  final String username;

  ServiceList({required this.username});

  @override
  _ServiceListState createState() => _ServiceListState(username: username);
}

class _ServiceListState extends State<ServiceList> {
  final String username;
  List<QueryDocumentSnapshot> services = [];

  _ServiceListState({required this.username});

  bool isLoading = true;
  final UserController userController = Get.find();
  @override
  void initState() {
    super.initState();
    loadServices();
  }

  Future<void> loadServices() async {
    try {
      final QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      String userDocId = userQuery.docs.first.id;
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userDocId)
          .collection('services')
          // .orderBy('date',
          //     descending: true) // Order by 'date' in descending order
          .limit(10)
          .get();

      setState(() {
        services = querySnapshot.docs;
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
    // Load the first 10 services from the 'services' subcollection of a specific user
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // Display a loading indicator while data is being fetched.
      return Container(
        height: 400,
        child: const Center(
          child: CircularProgressIndicator(color: AppColor.yellow),
        ),
      );
    } else if (services.isEmpty) {
      // Display "No Service Added" message when the 'services' collection is empty or doesn't exist.
      return Container(
        height: 200,
        child: const Center(
          child: Text("No Service Added"),
        ),
      );
    }

    // Build and return the ListView with service data.
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final serviceData = services[index].data() as Map<String, dynamic>;
        return ViewData(
          service: serviceData['service'] ?? '',
           status: serviceData['status'] ?? '',
          condition: serviceData['condition'] ?? '',
          duration: int.tryParse(serviceData['duration'] ?? '0') ?? 0,
          startDate: serviceData['start']?.toDate() ?? DateTime.now(),
          endDate: serviceData['end']?.toDate() ?? DateTime.now(), 
        );
      },
    );
  }
}

// ViewData Widget remains unchanged as per the original.
Color getStatusColor(String status, BuildContext context) {
  if (status == 'Online') {
    return Theme.of(context).colorScheme.surface;
  } else if (status == 'Deactivated') {
    return Theme.of(context).colorScheme.errorContainer;
  } else if (status == 'Booked') {
    return Theme.of(context).colorScheme.tertiary;
  } else if (status.isEmpty) {
    return Theme.of(context).colorScheme.secondary;
  }
  // Default color if status is neither 'Online' nor 'Booked'
  return Theme.of(context).colorScheme.surface;
}


// getStatusAction(String status, BuildContext context) {
//   if (status == 'Booked') {
//     Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Billing()));
//   } else {
//     // Navigate to another screen or handle differently if the status is not 'Booked'
//     Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Services()));
//   }
// }


class ViewData extends StatelessWidget {
  final String service;
  final String condition;
  final int duration;
  final DateTime startDate;
  final String status;
  final DateTime endDate;

  ViewData({
    required this.service,
    required this.condition,
    required this.status,
    required this.duration,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    // Define a date format
    final dateFormat = DateFormat('MMM d, y'); // Customize the format as needed
    Color statusColor = getStatusColor(status, context);
    // Function() statusAction = getStatusAction(status, context);

    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        color: Theme.of(context).colorScheme.secondary,
        child: ExpansionTile(
          shape: Border(),
          title: Text(
            service,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontFamily: 'Gilmer',
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          subtitle: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: statusColor.withOpacity(0.05)),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Center(
                child: Row(
                  children: [
                    Text(
                      ' Status: ',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontFamily: 'Gilmer',
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontFamily: 'Gilmer',
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          trailing: SizedBox(
            width: 150,
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 15,
                        child: Row(
                          children: [
                            Text(
                              'Last Changed:',
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontFamily: 'Gilmer',
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 15,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Text(
                              ' ${dateFormat.format(startDate)}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary,
                                fontFamily: 'Gilmer',
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(flex: 1),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MobileScaffold()));
                    },
                    // onTap: statusAction,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 3.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0)
                                .add(EdgeInsets.symmetric(horizontal: 8)),
                            child: Row(
                              children: [
                                Text(
                                  'More',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    fontFamily: 'Gilmer',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                                // Icon(Icons.arrow_right, color: Theme.of(context).colorScheme.background,size: 15,)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: Container(
                              width: 100,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Theme.of(context)
                                    .colorScheme
                                    .tertiary
                                    .withOpacity(0.05),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0)
                                    .add(EdgeInsets.symmetric(horizontal: 8)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text(
                                        'Book',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          fontFamily: 'Gilmer',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: Container(
                              width: 100,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Theme.of(context)
                                    .colorScheme
                                    .tertiary
                                    .withOpacity(0.05),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0)
                                    .add(EdgeInsets.symmetric(horizontal: 8)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text(
                                        'Deactivate',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          fontFamily: 'Gilmer',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
