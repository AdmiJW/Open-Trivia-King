import 'package:flutter/material.dart';
import 'package:open_trivia_king/widgets/slide_in_with_delay.dart';

class SlidingListTileWithDelay extends StatelessWidget {
  final String title, trailing;
  final double verticalPadding;
  final int delay;
  final int duration;
  final Offset initialOffset;

  const SlidingListTileWithDelay({
    super.key,
    required this.title,
    required this.trailing,
    required this.delay,
    this.verticalPadding = 15,
    this.duration = 750,
    this.initialOffset = const Offset(-2, 0),
  });

  @override
  Widget build(BuildContext context) {
    return SlideInWithDelay(
      delay: delay,
      duration: duration,
      initialOffset: initialOffset,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              flex: 2,
              child: Text(
                trailing,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
