import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:open_trivia_king/states/category_state.dart';
import 'package:open_trivia_king/states/game_state.dart';
import 'package:open_trivia_king/widgets/fade_in_with_delay.dart';

class GameLoading extends StatelessWidget {
  const GameLoading({super.key});

  Future<void> fetch(BuildContext ctx) async {
    GameState gameState = Provider.of<GameState>(ctx, listen: false);
    CategoryState categoryState =
        Provider.of<CategoryState>(ctx, listen: false);

    try {
      await gameState
          .fetchQuestionIntoState(categoryState.getRandomSelectedCategory());
      gameState.progressState();
    } catch (error) {
      gameState.switchToErrorState(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetch(context);
    });

    return const FadeInWithDelay(
      delay: 0,
      duration: 750,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              width: double.infinity), // Use to expand column to screen width
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
