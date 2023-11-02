import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Services extends StatefulWidget {
  const Services({Key? key}) : super(key: key);

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  final CollectionReference farmSetupCollection =
      FirebaseFirestore.instance.collection('farm_setup');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 150.0,
            floating: true,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Services',
                style: TextStyle(
                  fontFamily: 'Gilmer',
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.tertiary,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SearchBar(handleSearch: (searchQuery) {
              // Implement search logic here
              // You can use searchQuery to filter Firestore data
              // For example, you can call fetchDataFromFirestore(searchQuery)
              // and update the data based on search results.
            }),
          ),
          SliverToBoxAdapter(
            child: ServiceList(),
          ),
        ],
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
  @override
  _ServiceListState createState() => _ServiceListState();
}

class _ServiceListState extends State<ServiceList> {
  List<QueryDocumentSnapshot> services = [];

  @override
  void initState() {
    super.initState();
    loadServices();
  }

  Future<void> loadServices() async {
    // Load the first 10 services from Firestore
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('farm_setup')
        // .orderBy('createdAt')
        .limit(10)
        .get();
    setState(() {
      services = querySnapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) {
      // Loading indicator or error message
      return CircularProgressIndicator();
    }

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
   return Padding(
  padding: const EdgeInsets.all(8.0),
  child: Card(
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
         padding: const EdgeInsets.all(8.0),
         child: Align(
          alignment: Alignment.topLeft,
           child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Text(
              'Additional content here',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontFamily: 'Gilmer',
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
            Text(
              'More additional content',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontFamily: 'Gilmer',
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
           ],),
         ),
       )
      ],
    ),
  ),
);

  }
}
