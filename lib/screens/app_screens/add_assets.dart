import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mavunohub/components/Slider.dart';
import 'package:mavunohub/components/appbar.dart';
import 'package:mavunohub/components/form_options.dart';

import '../../components/custom_calendar.dart';
import '../../components/snacky.dart';
import '../../util/list.dart';

class AddAsset extends StatefulWidget {
  const AddAsset({
    super.key,
  });

  @override
  _AddAssetState createState() => _AddAssetState();
}

class _AddAssetState extends State<AddAsset> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _Assets = TextEditingController();
  final TextEditingController _condition = TextEditingController();
  final TextEditingController _duration = TextEditingController();
  bool isSliderInteracted = false; // Add a variable to track slider interaction

  DateTime?
      selectedEndDate; // Define a DateTime variable to store the selected date
  DateTime?
      selectedStartDate; // Define a DateTime variable to store the selected date

  // Function to set the selected date
  void onStartDateSelected(DateTime startDate, DateTime endDate) {
    setState(() {
      selectedStartDate =
          startDate; // You can choose to store the start date or end date, depending on your requirements.
    });
  }

  void onEndDateSelected(DateTime startDate, DateTime endDate) {
    setState(() {
      selectedEndDate =
          endDate; // You can choose to store the start date or end date, depending on your requirements.
    });
  }

  // Initialize Firebase
  final FirebaseApp app = Firebase.apps[0];

  // Define a reference to the Firestore collection
  final CollectionReference AddAssetCollection =
      FirebaseFirestore.instance.collection('farm_setup');

// Checks if the Asset already exists
  Future<bool> doesAssetExist(String Asset) async {
    final farm = FirebaseFirestore.instance.collection("farm_setup");
    final farmQuery = farm.where("Asset", isEqualTo: Asset);
    final farmSnapshot = await farmQuery.get();
    return farmSnapshot.size > 0;
  }

  // Function to save the form data to Firestore
  Future<void> saveFormDataToFirestore() async {
    final snacky = SnackBarHelper(context);
    // Condition to string
    String condition = _condition.text.toString();
    // Condition to string
    String duration = _duration.text.toString();
    // Condition to string
    String Asset = _Assets.text.toString();

    if (await doesAssetExist(Asset)) {
      snacky.showSnackBar(
          "You added the Asset already, Update to change status",
          isError: true);

      return;
    }
    if (condition.isEmpty) {
      snacky.showSnackBar("Condition is not stated", isError: true);
      return;
    }
    if (!isSliderInteracted) {
      snacky.showSnackBar("Set Condition on the Slider Condition widget",
          isError: true);
    }
    if (duration.isEmpty) {
      snacky.showSnackBar("Duration is not stated", isError: true);
      return;
    }
    if (Asset.isEmpty) {
      snacky.showSnackBar("Asset is not stated", isError: true);
      return;
    }

    try {
      await AddAssetCollection.add({
        'Asset': _Assets.text,
        'condition': _condition.text,
        'duration': _duration.text,
        'start': selectedStartDate,
        'end': selectedEndDate
      });
      // Show a success message or navigate to a different screen
      snacky.showSnackBar("Setup was successful", isError: false);
      // Clear the form fields if needed
    } on FirebaseException catch (e) {
      snacky.showSnackBar("An error occurred: $e", isError: true);
      print("An error occurred: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Assets'),
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
                        text: "Choose Assets",
                        hint: 'Assets I currently own'),
                    FormDropDown(
                        text: 'Select Asset',
                        list: services,
                        controller: _Assets),
                    const Subtitle(
                        text: "Condition",
                        hint:
                            'Condition of the Item (Rate condition from 1-10)'),
                    FormSlider(
                      text: 'text',
                      onChanged: (int value) {
                        // Collect the condition value here
                        _condition.text = value.toString();
                        isSliderInteracted =
                            true; // Set the variable to true when the slider is changed
                      },
                    ),
                    const Subtitle(
                        text: "Duration",
                        hint: 'Period of time to rent out asset'),
                    CustomCalendarView(
                        // minimumDate: minimumDate,
                        // maximumDate: widget.maximumDate,
                        // initialStartDate: DateTime(
                        //     2023, 10, 1), // Set your initial start date here
                        // initialEndDate: DateTime(2023, 10, 10), // S
                        // startEndDateChange: (DateTime startDateData,
                        //     DateTime endDateData) {
                        //   setState(() {
                        //     startDate = startDateData;
                        //     endDate = endDateData;
                        //   });
                        // },
                        durationChange: (duration) {
                          _duration.text = duration.toString();
                        },
                        selectEndDateChange: onEndDateSelected,
                        selectStartDateChange: onStartDateSelected),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  saveFormDataToFirestore();
                                }
                              },
                              child: Container(
                                // width:double.infinity,
                                width: 150,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color:
                                        Theme.of(context).colorScheme.tertiary),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'Save',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                // width:double.infinity,
                                width: 150,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'Redo',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
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

class Subtitle extends StatelessWidget {
  final String? text;
  final String? hint;
  const Subtitle({super.key, this.hint, this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0)
          .add(const EdgeInsets.only(top: 8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(text!,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Gilmer',
                  fontSize: 18)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              hint!,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Gilmer',
                  fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
