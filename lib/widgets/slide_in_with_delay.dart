import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SlideInWithDelay extends HookWidget {
  final Widget child;
  final int delay;
  final int duration;
  final Offset initialOffset;
  final Curve curve;

  const SlideInWithDelay({
    super.key,
    required this.child,
    required this.delay,
    required this.duration,
    required this.initialOffset,
    this.curve = Curves.easeOut,
  });

  @override
  Widget build(BuildContext context) {
    final offset = useState(initialOffset);
    final timer = useState<Timer?>(null);

    useEffect(() {
      timer.value = Timer(Duration(milliseconds: delay), () {
        offset.value = Offset.zero;
      });
      return () => timer.value?.cancel();
    }, []);

    return AnimatedSlide(
      duration: Duration(milliseconds: duration),
      curve: curve,
      offset: offset.value,
      child: child,
    );
  }
}
