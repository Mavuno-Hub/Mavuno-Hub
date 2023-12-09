import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mavunohub/components/appbar.dart';
import 'package:mavunohub/responsive/mobile_body.dart';
import 'package:mavunohub/screens/app_screens/news.dart';
import 'package:mavunohub/styles/pallete.dart';
import 'package:mavunohub/user_controller.dart';

class Assets extends StatefulWidget {
  const Assets({Key? key}) : super(key: key);

  @override
  State<Assets> createState() => _AssetsState();
}

class _AssetsState extends State<Assets> {
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
        appBar: const CustomAppBar(title: 'Assets'),
        body: Center(
          child: SizedBox(
            width: 420,
            child: Padding(
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
                  //           'Assets',
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
      //     .collection('assets')
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
          .collection('assets')
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

//       // Create a reference to the 'assets' subcollection
//       CollectionReference farmSetupCollection = FirebaseFirestore.instance
//           .collection('users')
//           .doc(userDocId)
//           .collection('assets');

//  }
    } catch (e) {
      print(e);
    }
    // Load the first 10 services from the 'assets' subcollection of a specific user
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
      // Display "No Asset Added" message when the 'assets' collection is empty or doesn't exist.
      return Container(
        height: 200,
        child: const Center(
          child: Text("No Asset Added"),
        ),
      );
    }

    // Build and return the ListView with asset data.
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final serviceData = services[index].data() as Map<String, dynamic>;
        return ViewData(
          asset: serviceData['asset'] ?? '',
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
  final String asset;
  final String condition;
  final int duration;
  final DateTime startDate;
  final DateTime endDate;

  ViewData({
    required this.asset,
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
            asset,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontFamily: 'Gilmer',
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          // subtitle: Text(
          //   'condition: ' + condition,
          //   style: TextStyle(
          //     color: Theme.of(context).hintColor,
          //     fontFamily: 'Gilmer',
          //     fontWeight: FontWeight.w700,
          //     fontSize: 10,
          //   ),
          // ),
         subtitle: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: AppColor.valid.withOpacity(0.05)),
           child: Padding(
             padding: const EdgeInsets.all(3.0),
             child: Center(
               child: Row(
                 children: [
                   Text(
                     ' Status:',
                     style: TextStyle(
                       color: Theme.of(context).colorScheme.onBackground,
                       fontFamily: 'Gilmer',
                       fontWeight: FontWeight.w700,
                       fontSize: 12,
                       
                     ),
                   ),
                   const Text(
                     ' Online',
                     style: TextStyle(
                       color: AppColor.valid,
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
                            // Text(
                            //   '$duration',
                            //   style: TextStyle(
                            //     color: Theme.of(context).colorScheme.tertiary,
                            //     fontFamily: 'Gilmer',
                            //     fontWeight: FontWeight.w700,
                            //     fontSize: 12,
                            //   ),
                            // ),
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
                            // Text(
                            //   ' $condition',
                            //   style: TextStyle(
                            //     color: Theme.of(context).colorScheme.tertiary,
                            //     fontFamily: 'Gilmer',
                            //     fontWeight: FontWeight.w700,
                            //     fontSize: 12,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(flex: 1),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MobileScaffold()));
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 3.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0).add(EdgeInsets.symmetric(horizontal: 8)),
                            child: Row(
                              children: [
                                Text(
                                  'More',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.background,
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
