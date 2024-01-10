import 'package:flutter/material.dart';
import 'dart:async';

//? A wrapper class for AnimatedOpacity to have fade-in effect that automatically triggers after `delay` seconds

class FadeInWithDelay extends StatefulWidget {
  final Widget child;
  final int delay;
  final int duration;
  final Curve curve;

  const FadeInWithDelay({
    Key? key,
    required this.child,
    required this.delay,
    required this.duration,
    this.curve = Curves.linear,
  }) : super(key: key);

  @override
  _FadeInWithDelayState createState() => _FadeInWithDelayState();
}

class _FadeInWithDelayState extends State<FadeInWithDelay> {
  double _opacity = 0;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: widget.delay), () {
      setState(() => _opacity = 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: widget.duration),
      curve: widget.curve,
      opacity: _opacity,
      child: widget.child,
    );
  }
}
