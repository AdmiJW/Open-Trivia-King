import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:open_trivia_king/states/category.dart';
import 'package:open_trivia_king/states/game.dart';
import 'package:open_trivia_king/widgets/fade_in_with_delay.dart';

class GameLoading extends HookConsumerWidget {
  const GameLoading({super.key});

  Future<void> fetch(WidgetRef ref) async {
    final gameNotifier = ref.read(gameStateProvider.notifier);
    final category = ref.read(categoryStateProvider);
    await gameNotifier.fetchNewQuestion(category.randomSelectedCategory);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        fetch(ref);
      });
      return;
    }, [ref]);

    return const FadeInWithDelay(
      delay: 0,
      duration: 750,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: double.infinity), // Use to expand column to screen width
          CircularProgressIndicator(),
          SizedBox(
            height: 20,
          ),
          Text(
            "Fetching question from Open Trivia DB...",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
