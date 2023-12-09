import 'package:flutter/material.dart';
import 'package:mavunohub/screens/app_screens/add_assets.dart';
import 'package:mavunohub/screens/app_screens/add_service.dart';
import 'package:mavunohub/screens/app_screens/farm_setup.dart';
import 'package:mavunohub/styles/pallete.dart';

class SnackBarHelper {
  final BuildContext context;

  SnackBarHelper(this.context);

  void showCustomSnackBarWithMenu() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true, // Ensures it takes up the whole screen height
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity! < 0) {
              // Swiped up (close the snackbar)
              Navigator.of(context).pop();
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Theme.of(context).colorScheme.background,
            ),
            child: ListView(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              children: <Widget>[
                buildCustomMenuItem(
                  "Add Service",
                  () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AddService(),
                    ));
                  },
                ),
                buildCustomMenuItem(
                  "Add Asset",
                  () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AddAsset(),
                    ));
                  },
                ),
                // Add more menu items here
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildCustomMenuItem(String title, Function() onPressed) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      color: Theme.of(context).colorScheme.tertiary.withOpacity(0.03),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
              fontFamily: 'Gilmer',
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: AppColor.yellow),
        ),
        onTap: onPressed,
      ),
    );
  }
}
