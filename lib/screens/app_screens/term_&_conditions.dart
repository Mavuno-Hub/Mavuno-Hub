// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mavunohub/styles/pallete.dart';

class TermsAndConditionsDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Row(
            children: [
              Icon(Icons.privacy_tip_rounded, color: Theme.of(context).colorScheme.onBackground),
              Text(
                ' Privacy Policy',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Gilmer',
                    fontSize: 18),
              )
            ],
          ),
          title: Center(
            child: Container(
              decoration: BoxDecoration(color: AppColor.yellow.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.all(8.0).add(EdgeInsets.symmetric(horizontal: 5)),
                child: Center(
                  child: const Text(
                    'By Creating an account, you are agreeing to our Terms & Conditions and Privacy Policy',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AppColor.yellow,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Gilmer',
                        fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 600, // Set the desired height
            child: const SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Title(text: '1. Acceptance of Terms'),
                  Content(
                    text:
                        'By accessing or using the Software, you agree to be bound by these Terms, which constitute a legally binding agreement. If you do not agree with these Terms, you must refrain from using the Software.',
                  ),
                  Title(text: '2. License and Access'),
                  Content(
                    text:
                        'We grant you a limited, non-exclusive, non-transferable, and revocable license to use the Software solely for your personal or internal business purposes. You may not:',
                  ),
                  Content(text: '- Modify, copy, or distribute the Software.'),
                  Content(
                      text: '- Reverse engineer or decompile the Software.'),
                  Content(
                    text:
                        '- Use the Software for any unlawful or unauthorized purpose.',
                  ),
                  Title(text: '3. User Accounts'),
                  Content(
                    text:
                        'To access certain features of the Software, you may be required to create a user account. You are responsible for safeguarding your account information, and you agree not to share your account credentials with others.',
                  ),
                  Title(text: '4. Privacy and Data'),
                  Content(
                    text:
                        'Our Privacy Policy explains how we collect, use, and protect your data. By using the Software, you consent to the practices outlined in our Privacy Policy.',
                  ),
                  Title(text: '5. Intellectual Property'),
                  Content(
                    text:
                        'All content, trademarks, and intellectual property within the Software are owned by us or our licensors. You may not use, reproduce, or distribute such content without our express written consent.',
                  ),
                  Title(text: '6. Updates and Changes'),
                  Content(
                    text:
                        'We may update, modify, or discontinue the Software at any time without notice. We are not liable for any loss resulting from these changes.',
                  ),
                  Title(text: '7. Termination'),
                  Content(
                    text:
                        'We reserve the right to terminate your access to the Software without notice if you violate these Terms or engage in harmful activities.',
                  ),
                  Title(text: '8. Disclaimers'),
                  Content(
                    text:
                        '- The Software is provided "as is" without warranties or guarantees.',
                  ),
                  Content(
                    text:
                        '- We do not guarantee that the Software will be uninterrupted, secure, or error-free.',
                  ),
                  Content(
                    text:
                        '- We are not responsible for the accuracy or completeness of content within the Software.',
                  ),
                  Title(text: '9. Limitation of Liability'),
                  Content(
                    text:
                        'We shall not be liable for any indirect, incidental, special, or consequential damages, or for any loss of profits, data, or goodwill, arising out of or in connection with the use of the Software.',
                  ),
                  Title(text: '10. Governing Law'),
                  Content(
                    text:
                        'These Terms are governed by and construed in accordance with the laws of [Your Jurisdiction]. Any disputes shall be resolved in the courts of [Your Jurisdiction].',
                  ),
                  Title(text: '11. Changes to Terms'),
                  Content(
                    text:
                        'We reserve the right to modify these Terms at any time. Updated terms will be posted within the Software, and your continued use signifies acceptance of the revised terms.',
                  ),
                  Title(text: '12. Contact Information'),
                  Content(
                    text:
                        'If you have questions or concerns about these terms, you may contact us at [Your Contact Information].',
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0)
                  .add(const EdgeInsets.only(bottom: 10)),
              child: Center(
                child: Container(
                  width: double.maxFinite,
                  height: 32,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color.fromARGB(26, 255, 174, 0)),
                  child: GestureDetector(
                    child: Center(
                      child: Text(
                        'Okay',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Gilmer',
                            fontSize: 18),
                      ),
                    ),
                    onTap: () {
                      // Handle the acceptance logic here
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class Content extends StatelessWidget {
  final String? text;

  const Content({
    this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      textAlign: TextAlign.start,
      style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
          fontWeight: FontWeight.w600,
          fontFamily: 'Gilmer',
          fontSize: 12),
    );
  }
}

class Title extends StatelessWidget {
  final String? text;
  const Title({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text!,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontWeight: FontWeight.w700,
            fontFamily: 'Gilmer',
            fontSize: 14),
      ),
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Terms & Conditions Example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                TermsAndConditionsDialog.show(context);
              },
              child: Text("Show Terms & Conditions"),
            ),
          ],
        ),
      ),
    );
  }
}
