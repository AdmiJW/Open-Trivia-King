import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:open_trivia_king/states/game.dart';
import 'package:open_trivia_king/states/audio.dart';
import 'package:open_trivia_king/states/stats.dart';
import 'package:open_trivia_king/widgets/fade_in_with_delay.dart';
import 'package:open_trivia_king/widgets/sliding_list_tile_with_delay.dart';
import 'package:open_trivia_king/widgets/rounded_elevated_button.dart';

class GameGameOver extends ConsumerWidget {
  const GameGameOver({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audio = ref.watch(audioServiceProvider);
    final gameSession = ref.watch(gameSessionProvider);
    final statsNotifier = ref.watch(statsStateProvider.notifier);

    int i = 0;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      children: [
        const SizedBox(height: 12),
        const FadeInWithDelay(
            delay: 0,
            duration: 750,
            child: Text(
              "Game Over",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            )),
        const SizedBox(height: 64),
        const FadeInWithDelay(
            delay: 500,
            duration: 750,
            child: Text(
              "Final Score",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
            )),
        const SizedBox(height: 4),
        FadeInWithDelay(
            delay: 1000,
            duration: 750,
            child: Text(
              gameSession.totalCorrects.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 120, fontWeight: FontWeight.bold),
            )),
        const SizedBox(height: 32),
        FadeInWithDelay(
          delay: 1250,
          duration: 750,
          child: RoundedElevatedButton(
            text: "Return to Home",
            borderRadius: 20,
            fontSize: 20,
            yPadding: 10,
            onPressed: () async {
              await statsNotifier.updateFromGameSession(gameSession);
              audio.stopBgm();
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ),
        const SizedBox(height: 48),
        SlidingListTileWithDelay(
            title: "Total question(s) answered:", trailing: gameSession.totalAnswered.toString(), delay: 2000),
        SlidingListTileWithDelay(title: "Highest streak:", trailing: gameSession.highestStreak.toString(), delay: 2250),
        const Divider(height: 24),
        for (String category in gameSession.answeredByCategory.keys)
          SlidingListTileWithDelay(
            title: category,
            trailing: "${gameSession.correctsByCategory[category]}/"
                "${gameSession.answeredByCategory[category]}",
            delay: 2500 + i++ * 200,
          ),
      ],
    );
  }
}
