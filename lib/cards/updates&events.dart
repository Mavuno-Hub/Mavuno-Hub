import 'package:flutter/material.dart';

class Updates extends StatelessWidget {
  final String? imageUrl;
  final String? title;
  final String? shortDescription;
  final VoidCallback? onClicked;

  const Updates({super.key, this.imageUrl, this.title, this.shortDescription, this.onClicked});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: GestureDetector(
        onTap: onClicked,
        child: Column(
          children: [
            Container(
              height: 107,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    imageUrl != null
                        ? Container(
                            child: Image.network(
                              imageUrl!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Container(
                              height: 67,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color:
                                    Theme.of(context).colorScheme.background,
                              ),
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.all(4.0)
                          .add(const EdgeInsets.symmetric(horizontal: 4)),
                      child: Row(
                        children: [
                          Text(
                            shortDescription ?? "No Event",
                            style: TextStyle(
                              fontFamily: "Gilmer",
                              fontSize: 16,
                             fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          const Spacer(flex: 1),
                          Icon(
                            Icons.more_horiz,
                            size: 16,
                            color: Theme.of(context).colorScheme.tertiary,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
