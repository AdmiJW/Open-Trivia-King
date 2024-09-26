import 'package:flutter/material.dart';
import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:open_trivia_king/states/game.dart';
import 'package:open_trivia_king/states/trivia.dart';
import 'package:open_trivia_king/widgets/expand_with_delay.dart';
import 'package:open_trivia_king/widgets/fade_in_with_delay.dart';

class GameSplashScreen extends HookConsumerWidget {
  const GameSplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameStateProvider);
    final trivia = ref.watch(triviaProvider);
    final gameNotifier = ref.watch(gameStateProvider.notifier);

    // After splash screen of 4 seconds, proceed to next state - Answering
    useEffect(() {
      final timer = Timer(const Duration(seconds: 4), () {
        gameNotifier.progress();
      });
      return () => timer.cancel();
    }, [gameNotifier]);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FadeInWithDelay(
          delay: 0,
          duration: 750,
          child: Text(
            "Question ${game.questionNo}",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10, width: double.infinity),
        ExpandWithDelay(
          delay: 500,
          duration: 750,
          child: Container(
            height: 1,
            width: 250,
            decoration: const BoxDecoration(color: Colors.black),
          ),
        ),
        const SizedBox(height: 50),
        FadeInWithDelay(
          delay: 1000,
          duration: 750,
          child: Text(
            trivia.value?.category ?? "Unknown Category",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
          ),
        ),
      ],
    );
  }
}
