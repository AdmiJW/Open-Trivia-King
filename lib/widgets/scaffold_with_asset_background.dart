import 'package:flutter/material.dart';

class ScaffoldWithAssetBackground extends StatelessWidget {
  final String backgroundPath;
  final Scaffold scaffold;

  const ScaffoldWithAssetBackground({
    Key? key,
    required this.scaffold,
    required this.backgroundPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          backgroundPath,
          fit: BoxFit.cover,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
        scaffold,
      ],
    );
  }
}
