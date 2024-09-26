import 'package:flutter/material.dart';

import 'package:open_trivia_king/routes/profile/profile_body.dart';
import 'package:open_trivia_king/widgets/scaffold_with_asset_background.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithAssetBackground(
      fallbackBackgroundColor: Colors.lightBlue.shade50,
      backgroundPath: "assets/images/wallpp.png",
      scaffold: Scaffold(
        appBar: AppBar(
          title: const Text("Open Trivia King"),
          centerTitle: true,
        ),
        body: const ProfileBody(),
      ),
    );
  }
}
