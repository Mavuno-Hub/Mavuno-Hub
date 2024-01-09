import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Alert {
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    bool isError = true,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
      
          title: Text(
            title,
            style: TextStyle(
                fontFamily: 'Gilmer',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Theme.of(context).colorScheme.tertiary),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: TextStyle(
                    fontFamily: 'Gilmer',
                    fontWeight: FontWeight.w700,
                    fontSize: 32,
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              const SizedBox(height: 16),
              Center(
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: message));
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 80,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.tertiary,
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Copy',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Gilmer',
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.background),
                            overflow: TextOverflow.fade,),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap:  () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 80,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(24, 255, 255, 255),
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Close',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Gilmer',
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.tertiary),
                            overflow: TextOverflow.fade,),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

void showErrorAlert(BuildContext context, String message) {
  Alert.show(
    context,
    title: "Error",
    message: message,
  );
}
