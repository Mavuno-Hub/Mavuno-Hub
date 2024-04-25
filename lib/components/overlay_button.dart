import 'package:flutter/material.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';
import 'package:provider/single_child_widget.dart';

class OverlayButton extends StatelessWidget {
  final TooltipController controller;
  final String title;
  final String? desc;

  const OverlayButton({
    Key? key,
    required this.controller,
    required this.title,
    this.desc
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final currentDisplayIndex = controller.nextPlayIndex + 1;
    final totalLength = controller.playWidgetLength;
    final hasNextItem = currentDisplayIndex < totalLength;
    final hasPreviousItem = currentDisplayIndex != 1;
    final canPause = currentDisplayIndex < totalLength;

    return Container(
      width: size.width * .7,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
      ),

      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(TextSpan(children: [
                  TextSpan(
                    text: title,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w700),
                  ),
                  WidgetSpan(
                    child: Opacity(
                      opacity: totalLength == 1 ? 0 : 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          '($currentDisplayIndex OF $totalLength)',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  )
                ])),
                // InkWell(
                //   onTap: () {
                //     controller.dismiss();
                //   },
                //   child: Icon(Icons.cancel_outlined,
                //       color: Theme.of(context).colorScheme.tertiary, size: 18),
                // )
              ],
            ),
          ),
          Text(desc ?? '', style: TextStyle(
              color: Theme.of(context).hintColor,
              fontWeight: FontWeight.w700
          ), ),
          const SizedBox(
            height: 16,
          ),

          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Opacity(
                opacity: hasPreviousItem ? 1 : 0,
                child: TextButton(
                  onPressed: () {
                    controller.previous();
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  child:  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Prev',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.background,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                ),
              ),
              Opacity(
                opacity: canPause ? 1 : 0,
                child: TextButton(
                  onPressed: () {
                    controller.pause();
                  },
                  style: TextButton.styleFrom(
                      backgroundColor:Theme.of(context).colorScheme.tertiary.withOpacity(0.08),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  child:  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      'Pause',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  controller.next();
                },
                style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    hasNextItem ? 'Next' : 'Got It',
                    style:  TextStyle(
                      color: Theme.of(context).colorScheme.background,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}