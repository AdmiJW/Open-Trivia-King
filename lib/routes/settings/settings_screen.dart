import 'package:flutter/material.dart';
import 'package:open_trivia_king/routes/settings/settings_body.dart';
import 'package:open_trivia_king/widgets/scaffold_with_asset_background.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithAssetBackground(
      fallbackBackgroundColor: Colors.lightBlue.shade50,
      backgroundPath: "assets/images/wallpp.png",
      scaffold: Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
          centerTitle: true,
        ),
        body: const SettingsBody(),
      ),
    );
  }
}
