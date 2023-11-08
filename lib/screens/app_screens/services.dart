import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mavunohub/components/appbar.dart';
import 'package:mavunohub/styles/pallete.dart';
import 'package:mavunohub/user_controller.dart';

class Services extends StatefulWidget {
  const Services({Key? key}) : super(key: key);

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  final UserController userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    userController.fetchUserDataFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: const CustomAppBar(title: 'Services'),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: CustomScrollView(
            slivers: <Widget>[
              // SliverAppBar(
              //   expandedHeight: 100.0,
              //   floating: true,
              //   pinned: false,
              //   flexibleSpace: FlexibleSpaceBar(
              //     title: Align(
              //       alignment: Alignment.centerLeft,
              //       child: Padding(
              //         padding: const EdgeInsets.symmetric(vertical: 25.0),
              //         child: Text(
              //           'Services',
              //           style: TextStyle(
              //             fontFamily: 'Gilmer',
              //             fontSize: 26,
              //             color: Theme.of(context).colorScheme.tertiary,
              //             fontWeight: FontWeight.w700,
              //           ),
              //           textAlign: TextAlign.start,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              SliverToBoxAdapter(
                child: SearchBar(handleSearch: (searchQuery) {
                  // Implement search logic here
                  // You can use searchQuery to filter Firestore data
                  // For example, you can call fetchDataFromFirestore(searchQuery)
                  // and update the data based on search results.
                }),
              ),
              // Use the UserController to retrieve the user's username
              SliverToBoxAdapter(
                child: FutureBuilder<String>(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final Function(String) handleSearch;

  const SearchBar({required this.handleSearch});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          maxLines: 1,
          minLines: 1,
          cursorColor: Theme.of(context).colorScheme.tertiary,
          style: TextStyle(
            fontFamily: 'Gilmer',
            fontSize: 14,
            color: Theme.of(context).colorScheme.onBackground,
            fontWeight: FontWeight.w300,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: "Search",
            hintStyle: TextStyle(
              fontSize: 14,
              color: Theme.of(context).hintColor,
              fontFamily: "Gilmer",
              fontWeight: FontWeight.w500,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Call the search function and pass the searchQuery
                handleSearch(''); // Replace '' with the actual search query
              },
            ),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 2,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
                width: 0,
              ),
            ),
            fillColor: Theme.of(context).colorScheme.secondary,
            filled: true,
            prefixIcon: Icon(Icons.search, color: Theme.of(context).hintColor),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.tertiary,
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
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
      // final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(username)
      //     .collection('farm_setup')
      //     .limit(10)
      //     .get();
      final QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      String userDocId = userQuery.docs.first.id;
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userDocId)
          .collection('farm_setup')
          // .orderBy('date',
          //     descending: true) // Order by 'date' in descending order
          .limit(10)
          .get();

      setState(() {
        services = querySnapshot.docs;
        isLoading = false;
      });

//  if(querySnapshot.docs.isNotEmpty){
// String userDocId = querySnapshot.docs.first.id;

//       // Create a reference to the 'farm_setup' subcollection
//       CollectionReference farmSetupCollection = FirebaseFirestore.instance
//           .collection('users')
//           .doc(userDocId)
//           .collection('farm_setup');

//  }
    } catch (e) {
      print(e);
    }
    // Load the first 10 services from the 'farm_setup' subcollection of a specific user
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
      // Display "No Service Added" message when the 'farm_setup' collection is empty or doesn't exist.
      return Container(
        height: 200,
        child: Center(
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
          condition: serviceData['condition'] ?? '',
          duration: int.tryParse(serviceData['duration'] ?? '0') ?? 0,
          startDate: serviceData['start']?.toDate() ?? DateTime.now(),
          endDate: serviceData['end']?.toDate() ?? DateTime.now(),
        );
      },
    );
  }
}

class ViewData extends StatelessWidget {
  final String service;
  final String condition;
  final int duration;
  final DateTime startDate;
  final DateTime endDate;

  ViewData({
    required this.service,
    required this.condition,
    required this.duration,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    // Define a date format
    final dateFormat = DateFormat('MMM d, y'); // Customize the format as needed

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
              color: Theme.of(context).colorScheme.tertiary,
              fontFamily: 'Gilmer',
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            'condition: ' + condition,
            style: TextStyle(
              color: Theme.of(context).hintColor,
              fontFamily: 'Gilmer',
              fontWeight: FontWeight.w700,
              fontSize: 10,
            ),
          ),
          trailing: Text(
            'Duration: $duration days',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontFamily: 'Gilmer',
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Start Date:       ${dateFormat.format(startDate)}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontFamily: 'Gilmer',
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'End Date:      ${dateFormat.format(endDate)}',
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
            )
          ],
        ),
      ),
    );
  }
}
