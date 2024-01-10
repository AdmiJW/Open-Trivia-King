import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:open_trivia_king/widgets/drawer_listtile.dart';

/// Navigation Drawer for the Home Screen
class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  // Drawer Header
  static const _headerTitleTextStyle =
      TextStyle(fontWeight: FontWeight.w100, fontSize: 40, color: Colors.white);
  static final drawerHeader = DrawerHeader(
    decoration: BoxDecoration(
        gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.blue.shade300,
        Colors.blue.shade600,
      ],
    )),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: const [
        Text('MENU', style: _headerTitleTextStyle),
      ],
    ),
  );

  // Drawer Items
  static const List<String> itemTitles = ['Profile', 'Settings', 'Exit'];
  static const List<IconData> itemIcons = [
    Icons.person,
    Icons.settings,
    Icons.close
  ];
  List<void Function()?> getItemTapHandlers(BuildContext ctx) => [
        () {
          Navigator.pop(ctx); // Pop away the drawer (to close it)
          Navigator.of(ctx).pushNamed('/profile');
        },
        () {
          Navigator.pop(ctx);
          Navigator.of(ctx).pushNamed('/settings');
        },
        () {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        },
      ];

  @override
  Widget build(BuildContext context) {
    var itemTapHandlers = getItemTapHandlers(context);

    var drawerItems = <Widget>[
      drawerHeader,
      for (int i = 0; i < itemTitles.length; ++i)
        DrawerListTile(
          xPadding: 16,
          title: itemTitles[i],
          leadingIcon: itemIcons[i],
          iconColor: Colors.black,
          onTap: itemTapHandlers[i],
        ),
      const SizedBox(
        height: 40,
      ),
      const Text(
        "Application by AdmiJW",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w300, color: Colors.grey),
      ),
    ];

    return Drawer(
      child: ListView(
        children: drawerItems,
      ),
    );
  }
}
