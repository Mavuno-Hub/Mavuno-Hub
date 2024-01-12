import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavunohub/components/Slider.dart';
import 'package:mavunohub/components/appbar.dart';
import 'package:mavunohub/components/form_options.dart';
import 'package:mavunohub/components/custom_calendar.dart';
import 'package:mavunohub/components/snacky.dart';
import 'package:mavunohub/screens/app_screens/view_services.dart';
import 'package:mavunohub/user_controller.dart';
import 'package:mavunohub/util/list.dart';

class AddService extends StatefulWidget {
  const AddService({Key? key});

  @override
  _FarmSetupState createState() => _FarmSetupState();
}

class _FarmSetupState extends State<AddService> {
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


  int conditionValue;
  if (int.tryParse(condition) is int) {
    conditionValue = int.parse(condition);
    if (conditionValue < 1 || conditionValue > 10) {
      snacky.showSnackBar("Condition should be a number between 1 and 10", isError: true);
      return;
    }
  }
  String username = userController.username.value;

  if (username == null || username.isEmpty) {
    snacky.showSnackBar("Username is invalid", isError: true);
    return;
  }
   if (condition.isEmpty || duration.isEmpty || service.isEmpty) {
    snacky.showSnackBar("Please fill in all fields", isError: true);
    return;
  }try {
    final QuerySnapshot userQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    if (userQuery.docs.isNotEmpty) {
      String userDocId = userQuery.docs.first.id;

      CollectionReference farmSetupCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userDocId)
          .collection('services');

      // Check if the service already exists for this user
      QuerySnapshot serviceQuery = await farmSetupCollection
          .where('service', isEqualTo: _services.text)
          .get();

      if (serviceQuery.docs.isNotEmpty) {
        // Service already exists, show error message or handle accordingly
        snacky.showSnackBar("Service already exists for this user", isError: true);
      } else {
        // Service does not exist, add it to the collection
        await farmSetupCollection.add({
          'service': _services.text,
          'condition': _condition.text,
          'duration': _duration.text,
          'start': selectedStartDate,
          'status': 'online',
          'end': selectedEndDate,
        });
        snacky.showSnackBar("Farm setup was successful", isError: false);
        setState(() {
          selectedStartDate = null;
          selectedEndDate = null;
        });
      }
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
                              width: 140,
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
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: ((context) => const ViewServices())));
                            },
                            child: Container(
                              width: 140,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                              child: Center(
                                child: Text(
                                  'View',
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
                          // GestureDetector(
                          //   onTap: () {},
                          //   child: Container(
                          //     width: 150,
                          //     height: 40,
                          //     decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(8),
                          //       color: Theme.of(context).colorScheme.secondary,
                          //     ),
                          //     child: Center(
                          //       child: Text(
                          //         'Redo',
                          //         style: TextStyle(
                          //           fontWeight: FontWeight.w700,
                          //           fontSize: 18,
                          //           color:
                          //               Theme.of(context).colorScheme.tertiary,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
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
