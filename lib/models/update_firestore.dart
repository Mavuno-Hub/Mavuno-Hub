import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class updateFirestore extends StatefulWidget {
  @override
  _updateFirestoreState createState() => _updateFirestoreState();
}

class _updateFirestoreState extends State<updateFirestore> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateServicesStatus() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();

      for (QueryDocumentSnapshot userSnapshot in querySnapshot.docs) {
        // Check if the user has the 'services' sub-collection
        bool hasServices = userSnapshot.reference.collection('assets').snapshots().isEmpty as bool;

        if (!hasServices) {
          QuerySnapshot servicesSnapshot = await userSnapshot.reference.collection('services').get();

          for (QueryDocumentSnapshot serviceSnapshot in servicesSnapshot.docs) {
            // Update 'status' field to 'online' for each document in 'services' sub-collection
            await serviceSnapshot.reference.update({'status': 'online'});
            print('Status updated for ${serviceSnapshot.id} in ${userSnapshot.id}');
          }
        }
      }
    } catch (e) {
      print('Error updating services status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Services Status'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            updateServicesStatus();
          },
          child: Text('Update Services Status'),
        ),
      ),
    );
  }
}
