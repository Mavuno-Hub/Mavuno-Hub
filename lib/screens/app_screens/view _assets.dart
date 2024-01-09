import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mavunohub/components/appbar.dart';
import 'package:mavunohub/responsive/mobile_body.dart';
import 'package:mavunohub/screens/app_screens/billing&transactions.dart';
import 'package:mavunohub/screens/app_screens/Assets.dart';
import 'package:mavunohub/styles/pallete.dart';
import 'package:mavunohub/user_controller.dart';

class ViewAssets extends StatefulWidget {
  const ViewAssets({Key? key}) : super(key: key);

  @override
  State<ViewAssets> createState() => _ViewAssetsState();
}

class _ViewAssetsState extends State<ViewAssets> {
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
          appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_rounded,
                    color: Theme.of(context).colorScheme.tertiary),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text(
                'View Assets',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ViewAssets()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Icon(
                            Icons.refresh,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            'Refresh',
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
              ]),
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
                    //  overlayColor: Theme.of(context).colorScheme.tertiary,
                      labelStyle: TextStyle(
                        fontFamily: 'Gilmer',
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.w700,
                      ),
                      tabs: const [
                        Tab(text: 'All Assets'),
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
                          buildAllAssetsTab(),
                          onlineAssets(),
                          bookedAssets(),
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

  Widget buildAllAssetsTab() {
    return RefreshIndicator(
        color: Theme.of(context).colorScheme.tertiary,
        onRefresh: () async {
          // Fetch data from Firestore for the 'All Assets' tab
          userController.fetchUserDataFromFirestore();
        },
        child: ListView(
          children: [
            FutureBuilder<String>(
              future: userController.getUsername(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final username = snapshot.data;
                  if (username != null) {
                    // Pass the username to the AssetList
                    return AssetList(username: username);
                  } else {
                    // Handle the case where username is null (e.g., user not authenticated)
                    return const Text('User not authenticated');
                  }
                } else {
                  // Loading indicator while fetching username
                  return const Center(
                      child: CircularProgressIndicator(color: AppColor.yellow));
                }
              },
            ),
          ],
        ));
  }

  Widget onlineAssets() {
    return RefreshIndicator(
        onRefresh: () async {
          // Fetch data from Firestore for the 'Online Assets' tab
          final username = await userController.getUsername();
          if (username != null) {
            setState(() {}); // Refresh the state to trigger FutureBuilder
          }
        },
        child: FutureBuilder<String>(
          future: userController.getUsername(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final username = snapshot.data;
              if (username != null) {
                return FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchAssetsWithStatus(username, 'Online'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      final List<Map<String, dynamic>> onlineAssets =
                          snapshot.data ?? [];
                      if (onlineAssets.isNotEmpty) {
                        return ListView.builder(
                          itemCount: onlineAssets.length,
                          itemBuilder: (context, index) {
                            final AssetData = onlineAssets[index];
                            return ViewData(
                              Asset: AssetData['asset'] ?? '',
                              condition: AssetData['condition'] ?? '',
                              status: AssetData['status'] ?? '',
                              duration:
                                  int.tryParse(AssetData['duration'] ?? '0') ??
                                      0,
                              startDate: AssetData['start']?.toDate() ??
                                  DateTime.now(),
                              endDate:
                                  AssetData['end']?.toDate() ?? DateTime.now(),
                            );
                          },
                        );
                      } else {
                        return Container(
                          height: 200,
                          child: Center(
                            child: Text("No Online Assets"),
                          ),
                        );
                      }
                    } else {
                      return const Center(
                          child: CircularProgressIndicator(
                              color: AppColor.yellow));
                    }
                  },
                );
              } else {
                return Text('User not authenticated');
              }
            } else {
              return Center(
                  child: CircularProgressIndicator(color: AppColor.yellow));
            }
          },
        ));
  }

  Widget bookedAssets() {
    return RefreshIndicator(
        onRefresh: () async {
          // Fetch data from Firestore for the 'Booked Assets' tab
          final username = await userController.getUsername();
          if (username != null) {
            setState(() {}); // Refresh the state to trigger FutureBuilder
          }
        },
        child: FutureBuilder<String>(
          future: userController.getUsername(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final username = snapshot.data;
              if (username != null) {
                return FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchAssetsWithStatus(username, 'Booked'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      final List<Map<String, dynamic>> bookedAssets =
                          snapshot.data ?? [];
                      if (bookedAssets.isNotEmpty) {
                        return ListView.builder(
                          itemCount: bookedAssets.length,
                          itemBuilder: (context, index) {
                            final AssetData = bookedAssets[index];
                            return ViewData(
                              Asset: AssetData['asset'] ?? '',
                              condition: AssetData['condition'] ?? '',
                              status: AssetData['status'] ?? '',
                              duration:
                                  int.tryParse(AssetData['duration'] ?? '0') ??
                                      0,
                              startDate: AssetData['start']?.toDate() ??
                                  DateTime.now(),
                              endDate:
                                  AssetData['end']?.toDate() ?? DateTime.now(),
                            );
                          },
                        );
                      } else {
                        return Container(
                          height: 200,
                          child: Center(
                            child: Text("No Booked Assets"),
                          ),
                        );
                      }
                    } else {
                      return Center(
                          child: CircularProgressIndicator(
                              color: AppColor.yellow));
                    }
                  },
                );
              } else {
                return Text('User not authenticated');
              }
            } else {
              return Center(
                  child: CircularProgressIndicator(color: AppColor.yellow));
            }
          },
        ));
  }

  Future<List<Map<String, dynamic>>> fetchAssetsWithStatus(
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
          .collection('Assets')
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

  Future<List<Map<String, dynamic>>> fetchBookedAssets(String username) async {
    try {
      final QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      String userDocId = userQuery.docs.first.id;
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userDocId)
          .collection('Assets')
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

class AssetList extends StatefulWidget {
  final String username;

  AssetList({required this.username});

  @override
  _AssetListState createState() => _AssetListState(username: username);
}

class _AssetListState extends State<AssetList> {
  final String username;
  List<QueryDocumentSnapshot> Assets = [];

  _AssetListState({required this.username});

  bool isLoading = true;
  final UserController userController = Get.find();
  @override
  void initState() {
    super.initState();
    loadAssets();
  }

  Future<void> loadAssets() async {
    try {
      final QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      String userDocId = userQuery.docs.first.id;
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userDocId)
          .collection('assets')
          // .orderBy('date',
          //     descending: true) // Order by 'date' in descending order
          .limit(10)
          .get();

      setState(() {
        Assets = querySnapshot.docs;
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
    // Load the first 10 Assets from the 'Assets' subcollection of a specific user
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
    } else if (Assets.isEmpty) {
      // Display "No Asset Added" message when the 'Assets' collection is empty or doesn't exist.
      return Container(
        height: 200,
        child: const Center(
          child: Text("No Asset Added"),
        ),
      );
    }

    // Build and return the ListView with Asset data.
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: Assets.length,
      itemBuilder: (context, index) {
        final AssetData = Assets[index].data() as Map<String, dynamic>;
        return ViewData(
          Asset: AssetData['asset'] ?? '',
          status: AssetData['status'] ?? '',
          condition: AssetData['condition'] ?? '',
          duration: int.tryParse(AssetData['duration'] ?? '0') ?? 0,
          startDate: AssetData['start']?.toDate() ?? DateTime.now(),
          endDate: AssetData['end']?.toDate() ?? DateTime.now(),
        );
      },
    );
  }
}

// ViewData Widget remains unchanged as per the original.
Color getStatusColor(String status, BuildContext context) {
  if (status == 'Online') {
    return Theme.of(context).colorScheme.surface;
  } else if (status == 'Inactive') {
    return Theme.of(context).colorScheme.errorContainer;
  } else if (status == 'Booked') {
    return Theme.of(context).colorScheme.tertiary;
  } else if (status.isEmpty) {
    return Theme.of(context).colorScheme.onBackground;
  }
  // Default color if status is neither 'Online' nor 'Booked'
  return Theme.of(context).colorScheme.surface;
}

// getStatusAction(String status, BuildContext context) {
//   if (status == 'Booked') {
//     Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Billing()));
//   } else {
//     // Navigate to another screen or handle differently if the status is not 'Booked'
//     Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Assets()));
//   }
// }

class ViewData extends StatelessWidget {
  final String Asset;
  final String condition;
  final int duration;
  final DateTime startDate;
  final String status;
  final DateTime endDate;

  ViewData({
    required this.Asset,
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
            Asset,
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
                color: Theme.of(context).colorScheme.tertiary.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Center(
                child: Row(
                  children: [
                    Text(
                      ' Condition: ',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontFamily: 'Gilmer',
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      condition,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
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
                      if (status == 'Booked') {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Billing(),
                        ));
                      } else {
                        // Navigate to another screen or handle differently if the status is not 'Booked'
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Assets(),
                        ));
                      }
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
                                  status == 'Booked' ? 'Pay' : 'More',
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
