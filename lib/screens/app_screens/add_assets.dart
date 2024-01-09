import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:im_stepper/stepper.dart';
import 'package:mavunohub/components/Slider.dart';
import 'package:mavunohub/components/appbar.dart';
import 'package:mavunohub/components/form_options.dart';
import 'package:mavunohub/components/custom_calendar.dart';
import 'package:mavunohub/components/snacky.dart';
import 'package:mavunohub/user_controller.dart';
import 'package:mavunohub/util/list.dart';

class AddAsset extends StatefulWidget {
  const AddAsset({Key? key});

  @override
  _FarmSetupState createState() => _FarmSetupState();
}

class _FarmSetupState extends State<AddAsset> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _assets = TextEditingController();
  final TextEditingController _condition = TextEditingController();
  final TextEditingController _duration = TextEditingController();
  bool isSliderInteracted = false;
  DateTime? selectedEndDate;
  DateTime? selectedStartDate;
  // REQUIRED: USED TO CONTROL THE STEPPER.
  int activeStep = 0;
  // Initial step set to 0.
  int dotCount = 5;

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
 Row steps() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(dotCount, (index) {
        return ElevatedButton(
          child: Text('${index + 1}'),
          onPressed: () {
            setState(() {
              activeStep = index;
            });
          },
        );
      }),
    );
  }

  /// Returns the next button widget.
  Widget nextButton() {
    return ElevatedButton(
      child: Text('Next'),
      onPressed: () {
        /// ACTIVE STEP MUST BE CHECKED FOR (dotCount - 1) AND NOT FOR dotCount To PREVENT Overflow ERROR.
        if (activeStep < dotCount - 1) {
          setState(() {
            activeStep++;
          });
        }
      },
    );
  }

  /// Returns the previous button widget.
  Widget previousButton() {
    return ElevatedButton(
      child: Text('Prev'),
      onPressed: () {
        // activeStep MUST BE GREATER THAN 0 TO PREVENT OVERFLOW.
        if (activeStep > 0) {
          setState(() {
            activeStep--;
          });
        }
      },
    );
  }

  Future<void> saveFormDataToFirestore() async {
    final snacky = SnackBarHelper(context);
    String condition = _condition.text.toString();
    String duration = _duration.text.toString();
    String asset = _assets.text.toString();
    final UserController userController = Get.find();

    int conditionValue;
    if (int.tryParse(condition) is int) {
      conditionValue = int.parse(condition);
      if (conditionValue < 1 || conditionValue > 10) {
        snacky.showSnackBar("Condition should be a number between 1 and 10",
            isError: true);
        return;
      }
    }
    String username = userController.username.value;

    if (username == null || username.isEmpty) {
      snacky.showSnackBar("Username is invalid", isError: true);
      return;
    }
    if (condition.isEmpty || duration.isEmpty || asset.isEmpty) {
      snacky.showSnackBar("Please fill in all fields", isError: true);
      return;
    }
    try {
      final QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      if (userQuery.docs.isNotEmpty) {
        String userDocId = userQuery.docs.first.id;

        CollectionReference farmSetupCollection = FirebaseFirestore.instance
            .collection('users')
            .doc(userDocId)
            .collection('assets');

        // Check if the asset already exists for this user
        QuerySnapshot assetQuery = await farmSetupCollection
            .where('asset', isEqualTo: _assets.text)
            .get();

        if (assetQuery.docs.isNotEmpty) {
          // Asset already exists, show error message or handle accordingly
          snacky.showSnackBar("Asset already exists for this user",
              isError: true);
        } else {
          // Asset does not exist, add it to the collection
          await farmSetupCollection.add({
            'asset': _assets.text,
            'condition': _condition.text,
            'duration': _duration.text,
            'start': selectedStartDate,
            'end': selectedEndDate,
          });
          snacky.showSnackBar("Asset was added successfuly", isError: false);
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
      body: Column(
        children: [
          DotStepper(
            direction: Axis.horizontal,
            dotCount: dotCount,
            dotRadius: 18,

            /// THIS MUST BE SET. SEE HOW IT IS CHANGED IN NEXT/PREVIOUS BUTTONS AND JUMP BUTTONS.
            activeStep: activeStep,
            shape: Shape.stadium,
            spacing: 18,
            indicator: Indicator.shift,

            /// TAPPING WILL NOT FUNCTION PROPERLY WITHOUT THIS PIECE OF CODE.
            onDotTapped: (tappedDotIndex) {
              setState(() {
                activeStep = tappedDotIndex;
              });
            },

            // DOT-STEPPER DECORATIONS
            fixedDotDecoration: FixedDotDecoration(
              color: Theme.of(context).colorScheme.secondary,
            ),

            indicatorDecoration: IndicatorDecoration(
              // style: PaintingStyle.stroke,
              // strokeWidth: 8,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            lineConnectorDecoration: LineConnectorDecoration(
              color:Theme.of(context).colorScheme.secondary,
              strokeWidth: 0,
            ),
          ),
          SingleChildScrollView(
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
                          hint: 'Assets I currently own',
                        ),
                        FormDropDown(
                          text: 'Select Asset',
                          list: assets,
                          controller: _assets,
                        ),
                        const Subtitle(
                          text: "Condition",
                          hint:
                              'Condition of the Asset (Rate condition from 1-10)',
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
                                  width: 300,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
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
        ],
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
