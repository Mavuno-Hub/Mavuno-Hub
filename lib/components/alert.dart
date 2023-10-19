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
          title:Text(
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
                    fontSize: 28,
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: message));
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Copy Password',
                          style: TextStyle(
                              fontFamily: 'Gilmer',
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.background),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Close',
                        style: TextStyle(
                            fontFamily: 'Gilmer',
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.tertiary),
                      )),
                ],
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
