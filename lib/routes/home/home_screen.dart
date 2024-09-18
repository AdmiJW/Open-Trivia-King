import 'package:flutter/material.dart';

import 'package:open_trivia_king/widgets/scaffold_with_asset_background.dart';
import 'package:open_trivia_king/routes/home/home_drawer.dart';
import 'package:open_trivia_king/routes/home/home_body.dart';

/// Top level widget for home screen route.
/// Split further into
/// 	|- Home Drawer
/// 	|- Home Body
/// 		|- CategoryList
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
        drawer: const AppDrawer(),
        body: const AppBody(),
      ),
    );
  }
}
