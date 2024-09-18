import 'package:flutter/material.dart';
import 'package:open_trivia_king/routes/settings/settings_body.dart';

import 'package:open_trivia_king/widgets/scaffold_with_asset_background.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static final _appBar = AppBar(
    title: const Text("Open Trivia King"),
    centerTitle: true,
  );

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithAssetBackground(
      backgroundPath: "assets/images/wallpp.png",
      scaffold: Scaffold(
        appBar: _appBar,
        body: const SettingsBody(),
      ),
    );
  }
}
