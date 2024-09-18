import 'package:flutter/material.dart';
import 'dart:async';

//? A wrapper class for AnimatedSlide to have slide-in effect that automatically triggers after `delay` seconds

class SlideInWithDelay extends StatefulWidget {
  final Widget child;
  final int delay;
  final int duration;
  final Offset initialOffset;
  final Curve curve;

  const SlideInWithDelay({
    Key? key,
    required this.child,
    required this.delay,
    required this.duration,
    required this.initialOffset,
    this.curve = Curves.easeOut,
  }) : super(key: key);

  @override
  State<SlideInWithDelay> createState() => _SlideInWithDelayState();
}

class _SlideInWithDelayState extends State<SlideInWithDelay> {
  Offset _offset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _offset = widget.initialOffset;

    Future.delayed(Duration(milliseconds: widget.delay), () {
      setState(() => _offset = Offset.zero);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: Duration(milliseconds: widget.duration),
      curve: widget.curve,
      offset: _offset,
      child: widget.child,
    );
  }
}
