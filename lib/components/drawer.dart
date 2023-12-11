import 'package:flutter/material.dart';
import 'package:mavunohub/screens/app_screens/assets.dart';
import '../screens/app_screens/services.dart';
import '../screens/app_screens/news.dart';
import '../screens/app_screens/view_services.dart';
import 'navrouter.dart';
import 'text.dart';

class IconMenu extends StatefulWidget {
  const IconMenu({super.key});

  @override
  State<IconMenu> createState() => _IconMenuState();
}

class _IconMenuState extends State<IconMenu> {
  final padding = const EdgeInsets.symmetric(horizontal: 30);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: Column(children: [
              // Container(
              //   padding: const EdgeInsets.all(8)
              //       .add(const EdgeInsets.only(left: 10))
              //       .add(safeArea)
              //       .add(const EdgeInsets.only(top: 5)),
              //   color: Theme.of(context).colorScheme.primary,
              //   child: buildHeader(),
              // ),
              Container(
                color: Colors.transparent,
                child: Column(
                  children: <Widget>[
                    buildMenuItem(
                        text: 'Services',
                        icon: Icons.room_service,
                        onClicked: () {
                           Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ViewServices(),
                              ));
                        }),
                    //  onClicked: () => Navigator.of(context).pop()),

                    buildMenuItem(
                      text: 'Assets',
                      icon: Icons.sell_rounded,
                       onClicked: () {
                           Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const Assets(),
                              ));
                        }
                    ),
                    buildMenuItem(
                      text: 'To-Dos',
                      icon: Icons.add_alert_rounded,
                      onClicked: () => selectedItem(context, 3),
                    ),
                    buildMenuItem(
                      text: 'Analytics',
                      icon: Icons.assessment,
                      onClicked: () => selectedItem(context, 3),
                    ),
                    buildMenuItem(
                      text: 'News',
                      icon: Icons.newspaper_rounded,
                      onClicked: () {
                           Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>  News(),
                              ));
                        }),
                    
                    buildMenuItem(
                      text: 'Settings',
                      icon: Icons.monetization_on,
                      onClicked: () => selectedItem(context, 3),
                    ),
                    /*
               *
               *
                buildMenuItem(
                  text: 'Admin',
                  icon: Icons.admin_panel_settings,
                  onClicked: () => selectedItem(context, 1),
                ),
        
                buildMenuItem(
                  text: 'Setup',
                  icon: Icons.settings_sharp,
                  onClicked: () => selectedItem(context, 2),
                ),
               *
               * */
                  ],
                ),
              ),
            ]),
          ),
        ));
  }
}

Widget buildHeader() => //  isCollapsed
//  Image.asset("assets/mavunohub_logo.png"),
    Builder(builder: (context) {
      return Row(children: [
        GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, Navigation.dashboard);
            },
            child: Jina(
              text: 'Mavuno Hub',
              rangi: Theme.of(context).colorScheme.onBackground,
            )),
      ]);
    });

Widget buildMenuItem({
  String? text,
  IconData? icon,
  VoidCallback? onClicked,
}) {
  const hoverColor = Colors.red;
  return Builder(builder: (context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.tertiary),
      dense: true,
      title: Transform.translate(
          offset: const Offset(-20, 0),
          child: Jina(
              text: text!, rangi: Theme.of(context).colorScheme.onBackground)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  });
}

void selectedItem(BuildContext context, int index) {
  switch (index) {
    case 0:
      // Navigator.of(context).push(MaterialPageRoute(
      //   builder: (context) => Common_Items(),
      // ));

      break;
    case 1:
      // Navigator.of(context).push(MaterialPageRoute(
      //   builder: (context) => Admin(),
      // ));

      break;
    case 2:
      // Navigator.of(context).push(MaterialPageRoute(
      //   builder: (context) => Setup(),
      // ));

      break;

    case 3:
      // Navigator.of(context).push(MaterialPageRoute(
      //   builder: (context) => MPesa(),
      // ));

      break;
  }
}
