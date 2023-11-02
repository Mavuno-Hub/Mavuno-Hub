import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mavunohub/components/Slider.dart';
import 'package:mavunohub/components/appbar.dart';
import 'package:mavunohub/components/form_options.dart';
import 'package:mavunohub/components/custom_calendar.dart';
import 'package:mavunohub/components/snacky.dart';
import 'package:mavunohub/screens/app_screens/add_assets.dart';
import 'package:mavunohub/user_controller.dart';
import 'package:mavunohub/util/list.dart';

import 'package:mavunohub/logic/services/data_manager.dart';

class FarmSetup extends StatefulWidget {
  const FarmSetup({Key? key});

  @override
  _FarmSetupState createState() => _FarmSetupState();
}

class _FarmSetupState extends State<FarmSetup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _services = TextEditingController();
  final TextEditingController _condition = TextEditingController();
  final TextEditingController _duration = TextEditingController();
  bool isSliderInteracted = false;
  DateTime? selectedEndDate;
  DateTime? selectedStartDate;

  void onStartDateSelected(DateTime startDate, DateTime endDate) {
    setState(() {
      selectedStartDate = startDate;
    });
  }

  void onEndDateSelected(DateTime startDate, DateTime endDate) {
    setState(() {
      selectedEndDate = endDate;
    });
  }

Future<void> saveFormDataToFirestore() async {
  final snacky = SnackBarHelper(context);
  String condition = _condition.text.toString();
  String duration = _duration.text.toString();
  String service = _services.text.toString();
  final UserController userController = Get.find();

  if (condition.isEmpty || duration.isEmpty || service.isEmpty) {
    snacky.showSnackBar("Please fill in all fields", isError: true);
    return;
  }

  String username = userController.username.value;

  if (username == null || username.isEmpty) {
    snacky.showSnackBar("Username is invalid", isError: true);
    return;
  }

  try {
    final QuerySnapshot userQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    if (userQuery.docs.isNotEmpty) {
      // Get the user's document ID
      String userDocId = userQuery.docs.first.id;

      // Create a reference to the 'farm_setup' subcollection
      CollectionReference farmSetupCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userDocId)
          .collection('farm_setup');

      // Add form data to the 'farm_setup' subcollection
      await farmSetupCollection.add({
        'service': _services.text,
        'condition': _condition.text,
        'duration': _duration.text,
        'start': selectedStartDate,
        'end': selectedEndDate,
      });
      snacky.showSnackBar("Farm setup was successful", isError: false);

      // Clear the form fields if needed
      _services.clear();
      _condition.clear();
      _duration.clear();
      setState(() {
        selectedStartDate = null;
        selectedEndDate = null;
      });
    } else {
      snacky.showSnackBar("User not found", isError: true);
    }
  } on FirebaseException catch (e) {
    snacky.showSnackBar("An error occurred: $e", isError: true);
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Farm Setup'),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: 360,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Subtitle(
                      text: "Choose Services",
                      hint: 'Assets I currently own',
                    ),
                    FormDropDown(
                      text: 'Select Service',
                      list: services,
                      controller: _services,
                    ),
                    const Subtitle(
                      text: "Condition",
                      hint:
                          'Condition of the Service (Rate condition from 1-10)',
                    ),
                    FormSlider(
                      text: 'text',
                      onChanged: (int value) {
                        _condition.text = value.toString();
                        isSliderInteracted = true;
                      },
                    ),
                    const Subtitle(
                      text: "Duration",
                      hint: 'Period of time to rent out asset',
                    ),
                    CustomCalendarView(
                      durationChange: (duration) {
                        _duration.text = duration.toString();
                      },
                      selectEndDateChange: onEndDateSelected,
                      selectStartDateChange: onStartDateSelected,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                              saveFormDataToFirestore();
                              }
                            },
                            child: Container(
                              width: 150,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                              child: Center(
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 150,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              child: Center(
                                child: Text(
                                  'Redo',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                              ),
                            ),
                          ),
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
}
