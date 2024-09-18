import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:open_trivia_king/states/game_state.dart';
import 'package:open_trivia_king/widgets/expand_with_delay.dart';
import 'package:open_trivia_king/widgets/fade_in_with_delay.dart';

class GameSplashScreen extends StatelessWidget {
  const GameSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GameState gameState = Provider.of<GameState>(context, listen: false);

    // After splash screen of 4 seconds, proceed to next state - Answering
    Future.delayed(
      const Duration(seconds: 4),
      () => gameState.progressState(),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FadeInWithDelay(
          delay: 0,
          duration: 750,
          child: Text(
            "Question ${gameState.questionNo}",
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
            gameState.currTrivia?.category ?? "Unknown Category",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
          ),
        ),
      ],
    );
  }
}
