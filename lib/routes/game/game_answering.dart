import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:open_trivia_king/states/game.dart';
import 'package:open_trivia_king/states/trivia.dart';
import 'package:open_trivia_king/widgets/expand_with_delay.dart';
import 'package:open_trivia_king/widgets/fade_in_with_delay.dart';
import 'package:open_trivia_king/widgets/rounded_elevated_button.dart';

class GameQuestion extends HookConsumerWidget {
  const GameQuestion({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameStateProvider);
    final gameNotifier = ref.watch(gameStateProvider.notifier);

    useEffect(() {
      if (game.status != GameStatus.answerReveal) return null;
      final timer = Timer(const Duration(seconds: 5), () => gameNotifier.progress());
      return () => timer.cancel();
    }, [game.status]);

    return ListView(
      children: const [
        LivesIndicator(),
        SizedBox(
          height: 20,
        ),
        QuestionNumber(),
        SizedBox(
          height: 10,
        ),
        CategoryText(),
        SizedBox(
          height: 50,
        ),
        QuestionText(),
        SizedBox(
          height: 50,
        ),
        AnswerOptions(),
      ],
    );
  }
}

class LivesIndicator extends ConsumerWidget {
  const LivesIndicator({super.key});

  static const Icon emptyHeart = Icon(
    Icons.favorite_border,
    size: 50,
    color: Colors.grey,
  );

  static const Icon filledHeart = Icon(
    Icons.favorite,
    size: 50,
    color: Colors.pinkAccent,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);

    if (gameState.livesLeft == null) {
      return const FadeInWithDelay(
        delay: 0,
        duration: 750,
        child: Text(
          "Unlimited Mode",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 30, color: Colors.grey),
        ),
      );
    }

    return FadeInWithDelay(
      delay: 0,
      duration: 750,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (gameState.livesLeft! > 0) ? filledHeart : emptyHeart,
          (gameState.livesLeft! > 1) ? filledHeart : emptyHeart,
          (gameState.livesLeft! > 2) ? filledHeart : emptyHeart,
        ],
      ),
    );
  }
}

class QuestionNumber extends ConsumerWidget {
  const QuestionNumber({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameStateProvider);

    return FadeInWithDelay(
      delay: 0,
      duration: 750,
      child: Text(
        "Question ${game.questionNo}",
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class CategoryText extends ConsumerWidget {
  const CategoryText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trivia = ref.watch(triviaProvider);

    return FadeInWithDelay(
      delay: 1000,
      duration: 750,
      child: Text(
        trivia.value?.category ?? "Unknown Category",
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
      ),
    );
  }
}

class QuestionText extends ConsumerWidget {
  const QuestionText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trivia = ref.watch(triviaProvider);

    return FadeInWithDelay(
      delay: 1750,
      duration: 750,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          trivia.value?.question ?? "Error Occurred. Please restart the application",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 25),
        ),
      ),
    );
  }
}

class AnswerOptions extends ConsumerWidget {
  const AnswerOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trivia = ref.watch(triviaProvider);
    final game = ref.watch(gameStateProvider);
    final gameNotifer = ref.watch(gameStateProvider.notifier);

    List<dynamic> choices = trivia.value!.choices;
    int i = 0;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (String choice in choices)
              ExpandWithDelay(
                delay: 3000 + i++ * 250,
                duration: 500,
                child: RoundedElevatedButton(
                  text: choice,
                  fontSize: 20,
                  onPressed: () {
                    if (game.status == GameStatus.answering) {
                      gameNotifer.submitAnswer(choice);
                      gameNotifer.progress();
                    }
                  },
                  yMargin: 5,
                  xPadding: 5,
                  backgroundColor: (game.status == GameStatus.answering
                      ? Colors.blue
                      : trivia.value?.answer == choice
                          ? Colors.green
                          : Colors.red),
                ),
              ),
          ],
        ));
  }
}
