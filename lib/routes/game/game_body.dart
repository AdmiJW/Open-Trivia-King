import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:open_trivia_king/states/game_state.dart';
import 'package:open_trivia_king/routes/game/game_loading.dart';
import 'package:open_trivia_king/routes/game/game_splash.dart';
import 'package:open_trivia_king/routes/game/game_answering.dart';
import 'package:open_trivia_king/routes/game/game_error.dart';
import 'package:open_trivia_king/routes/game/game_gameover.dart';

//? The gamebody which is dependent on the four states in GameState (game_state.dart)
class GameBody extends StatelessWidget {
  const GameBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<GameState, GameStates>(
        selector: (ctx, gameState) => gameState.state,
        builder: (ctx, state, child) {
          switch (state) {
            case GameStates.loading:
              return const GameLoading();
            case GameStates.splashScreen:
              return const GameSplashScreen();
            case GameStates.answering:
            case GameStates.answerReveal:
              return const GameQuestion();
            case GameStates.gameOver:
              return const GameGameOver();
            case GameStates.error:
              return const GameError();
            default:
              return const Center(
                child: Text(
                  "Error occurred in GameState.\nPlease try restarting the application",
                  textAlign: TextAlign.center,
                ),
              );
          }
        });
  }
}
