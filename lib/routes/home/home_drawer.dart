import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:open_trivia_king/widgets/drawer_listtile.dart';

final List<String> _itemTitles = ['Profile', 'Settings', 'Exit'];
final List<IconData> _itemIcons = [Icons.person, Icons.settings, Icons.close];
final List<void Function() Function(BuildContext)> _itemTapHandlers = [
  (ctx) => () {
        Navigator.pop(ctx);
        Navigator.of(ctx).pushNamed('/profile');
      },
  (ctx) => () {
        Navigator.pop(ctx);
        Navigator.of(ctx).pushNamed('/settings');
      },
  (ctx) => () {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      },
];

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const AppDrawerHeader(),
          for (int i = 0; i < _itemTitles.length; ++i)
            DrawerListTile(
              xPadding: 16,
              title: _itemTitles[i],
              leadingIcon: _itemIcons[i],
              iconColor: Colors.black,
              onTap: _itemTapHandlers[i](context),
            ),
          const SizedBox(
            height: 40,
          ),
          const Text(
            "Application by AdmiJW",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class AppDrawerHeader extends StatelessWidget {
  const AppDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade300,
            Colors.blue.shade600,
          ],
        ),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('MENU', style: TextStyle(fontWeight: FontWeight.w100, fontSize: 40, color: Colors.white)),
        ],
      ),
    );
  }
}
