import 'package:flutter/material.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneField extends StatefulWidget {
  final String text;
  final String? hint;
  final TextEditingController? controller;
  final IconData? prefix;
  final IconData? suffix;
  final String? Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final VoidCallback? onClicked;
  final String? label;
  final TextInputType? keyboardType;

  const PhoneField({
    super.key,
    required this.text,
    this.hint,
    this.onChanged,
    this.controller,
    this.prefix,
    this.suffix,
    this.validator,
    this.onClicked,
    this.label,
    this.keyboardType,
    required String title,
  });

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Align(
        //   alignment: Alignment.centerLeft,
        //   child: Text(
        //     widget.text,
        //     textAlign: TextAlign.start,
        //     textDirection: TextDirection.ltr,
        //     style: TextStyle(
        //       fontSize: 14,
        //       color: AppColor.greyHK,
        //       fontFamily: "Gilmer",
        //       fontWeight: FontWeight.w400,
        //     ),
        //   ),
        // ),
        // const Padding(padding: EdgeInsets.symmetric(vertical: 3)),
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(left: 20, right: 20),
          padding: const EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Column(
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.all(10),
                  child: IntlPhoneField(
                    style: TextStyle(
                      fontFamily: 'Gilmer',
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.w700,
                    ),
                    inputFormatters: const [],
                    textAlignVertical: TextAlignVertical.center,
                    dropdownIcon: Icon(
                      Icons.arrow_drop_down,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    textAlign: TextAlign.start,
                    pickerDialogStyle: PickerDialogStyle(
                      countryCodeStyle: TextStyle(
                        fontFamily: 'Gilmer',
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.tertiary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    // ignore: deprecated_member_use
                    searchText: 'Select Country',
                    // showCountryFlag: true,
                    // showDropdownIcon: true,
                 
                    controller: widget.controller,
                    // validator: widget.validator,
                    // onChanged: widget.onChanged,
                    cursorColor: Theme.of(context).colorScheme.tertiary,
                    decoration: InputDecoration(
                      focusColor: Theme.of(context).colorScheme.tertiary,
                      border: InputBorder.none,
                      prefixIcon: Icon(widget.prefix,
                          color: Theme.of(context).colorScheme.tertiary),
                      fillColor: Theme.of(context).colorScheme.secondary,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 0),
                      ),
                      hintText: widget.text,
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                              fontSize: 15,
                              fontFamily: "Gilmer",
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).hintColor),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.tertiary,
                          width: 2,
                        ),
                      ),
                    ),
                    onChanged: (phone) {
                      print(phone.completeNumber);
                    },onCountryChanged: (country) {
                    print('Country changed to: ${country.name}');
                  }, languageCode: "en",focusNode: focusNode,
                    initialCountryCode: 'KE',
                    dropdownTextStyle: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                            fontSize: 15,
                            fontFamily: "Gilmer",
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onBackground),
                    // onChanged: (phone) {
                    //   print(phone.completeNumber);
                    // },
                  )),
            ],
          ),
        ),
        // Padding(padding: EdgeInsets.symmetric(vertical: 7)),
      ],
    );
  }
}
