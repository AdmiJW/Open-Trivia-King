import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:open_trivia_king/states/game.dart';

// Error screen.
class GameError extends ConsumerWidget {
  const GameError({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameStateProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 30),
          const SizedBox(
            height: 30,
            width: double.infinity,
          ),
          Text(
            game.errorMessage ?? "Unkwown error",
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
          )
        ],
      ),
    );
  }
}
