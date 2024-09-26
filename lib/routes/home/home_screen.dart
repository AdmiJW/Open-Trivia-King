import 'package:flutter/material.dart';

import 'package:open_trivia_king/widgets/scaffold_with_asset_background.dart';
import 'package:open_trivia_king/routes/home/home_drawer.dart';
import 'package:open_trivia_king/routes/home/home_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
        drawer: const AppDrawer(),
        body: const AppBody(),
      ),
    );
  }
}
