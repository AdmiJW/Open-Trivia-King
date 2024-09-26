import 'dart:async';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';

class ExpandWithDelay extends HookWidget {
  final Widget child;
  final int delay;
  final int duration;
  final double initialScale;
  final Curve curve;

  const ExpandWithDelay({
    super.key,
    required this.child,
    required this.delay,
    required this.duration,
    this.initialScale = 0,
    this.curve = Curves.easeOut,
  });

  @override
  Widget build(BuildContext context) {
    final scale = useState(initialScale);
    final timer = useState<Timer?>(null);

    useEffect(() {
      timer.value = Timer(Duration(milliseconds: delay), () {
        scale.value = 1;
      });
      return () => timer.value?.cancel();
    }, []);

    return AnimatedScale(
      duration: Duration(milliseconds: duration),
      scale: scale.value,
      curve: curve,
      child: child,
    );
  }
}
