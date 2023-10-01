import 'package:flutter/material.dart';
import 'Navigator.dart';
import 'text.dart';

class IconMenu extends StatefulWidget {
  @override
  State<IconMenu> createState() => _IconMenuState();
}

class _IconMenuState extends State<IconMenu> {
  final padding = EdgeInsets.symmetric(horizontal: 30);

  Widget build(BuildContext context) {
    final safeArea =
        EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top);
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                      text: 'Dashboard',
                      icon: Icons.dashboard,
                      onClicked: () => Navigator.pop(context)),
                  //  onClicked: () => Navigator.of(context).pop()),
          
                  buildMenuItem(
                    text: 'Common Items',
                    icon: Icons.library_books_sharp,
                    onClicked: () => selectedItem(context, 0),
                  ),
                  buildMenuItem(
                    text: 'M-Pesa',
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
          )),
    );
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
            child: Container(
                child: 
                // Image.asset("assets/mavunohub_logo.png", width: 50),
                Jina( text:'Mavuno Hub', rangi: Theme.of(context).colorScheme.onBackground,))),
      ]);
    });

Widget buildMenuItem({
  String? text,
  IconData? icon,
  VoidCallback? onClicked,
}) {
  final hoverColor = Colors.red;
  return Builder(builder: (context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.tertiary),
      dense: true,
      title: Transform.translate(
          offset: Offset(-20, 0),
          child: Jina(text: text!, rangi: Theme.of(context).colorScheme.onBackground)),
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
