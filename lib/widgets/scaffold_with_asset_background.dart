import 'package:flutter/material.dart';

class ScaffoldWithAssetBackground extends StatelessWidget {
  final Color fallbackBackgroundColor;
  final String backgroundPath;
  final Scaffold scaffold;

  const ScaffoldWithAssetBackground({
    super.key,
    required this.fallbackBackgroundColor,
    required this.scaffold,
    required this.backgroundPath,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: fallbackBackgroundColor,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
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
