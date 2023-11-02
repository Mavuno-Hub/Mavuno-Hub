import 'package:flutter/material.dart';

class NewsFeed extends StatelessWidget {
  final String? imageUrl;
  final String? title;
  final String? shortDescription;
  final VoidCallback? onClicked;

  const NewsFeed(
      {super.key,
      this.imageUrl,
      this.title,
      this.shortDescription,
      this.onClicked});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: GestureDetector(
        onTap: onClicked,
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
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
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Theme.of(context).colorScheme.background,
                              ),
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.all(2.0)
                          .add(const EdgeInsets.symmetric(horizontal: 4)),
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              shortDescription ?? "No News",
                              style: TextStyle(
                                fontFamily: "Gilmer",
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                              textAlign: TextAlign.left,
                            ),
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
                    Padding(
                      padding: const EdgeInsets.all(2.0)
                          .add(const EdgeInsets.symmetric(horizontal: 4)),
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              shortDescription ??
                                  "Description of the News Feed",
                              style: TextStyle(
                                  fontFamily: "Gilmer",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).hintColor),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0).add(
                          const EdgeInsets.symmetric(horizontal: 4)
                              .add(const EdgeInsets.only(top: 12)
                              .add(const EdgeInsets.only(bottom: 4))),
                        ),
                        child: Row(
                          children: [
                            Container(
                              child: Text(
                                "Click to view more",
                                style: TextStyle(
                                  fontFamily: "Gilmer",
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Icon(
                              Icons.arrow_right_rounded,
                              size: 18,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                            const Spacer(flex: 1),
                          ],
                        ),
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
