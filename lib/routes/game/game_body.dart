import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:open_trivia_king/states/game.dart';
import 'package:open_trivia_king/routes/game/game_loading.dart';
import 'package:open_trivia_king/routes/game/game_splash.dart';
import 'package:open_trivia_king/routes/game/game_answering.dart';
import 'package:open_trivia_king/routes/game/game_error.dart';
import 'package:open_trivia_king/routes/game/game_gameover.dart';

class GameBody extends ConsumerWidget {
  const GameBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameStateProvider);

    if (game.status == GameStatus.loading) return const GameLoading();
    if (game.status == GameStatus.splashScreen) return const GameSplashScreen();
    if (game.status == GameStatus.answering || game.status == GameStatus.answerReveal) return const GameQuestion();
    if (game.status == GameStatus.gameOver) return const GameGameOver();
    if (game.status == GameStatus.error) return const GameError();

    return const Center(
      child: Text(
        "Error occurred in GameState.\nPlease try restarting the application",
        textAlign: TextAlign.center,
      ),
    );
  }
}
