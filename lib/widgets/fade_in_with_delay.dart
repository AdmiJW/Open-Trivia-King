import 'dart:async';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';

class FadeInWithDelay extends HookWidget {
  final Widget child;
  final int delay;
  final int duration;
  final Curve curve;

  const FadeInWithDelay({
    super.key,
    required this.child,
    required this.delay,
    required this.duration,
    this.curve = Curves.linear,
  });

  @override
  Widget build(BuildContext context) {
    final opacity = useState(0.0);
    final timer = useState<Timer?>(null);

    useEffect(() {
      timer.value = Timer(Duration(milliseconds: delay), () {
        opacity.value = 1;
      });
      return () => timer.value?.cancel();
    }, []);

    return AnimatedOpacity(
      duration: Duration(milliseconds: duration),
      curve: curve,
      opacity: opacity.value,
      child: child,
    );
  }
}
