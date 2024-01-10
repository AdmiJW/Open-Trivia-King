import 'package:flutter/material.dart';
import 'package:open_trivia_king/states/audio_controller.dart';
import 'package:provider/provider.dart';

import 'package:open_trivia_king/states/game_state.dart';
import 'package:open_trivia_king/states/user_state.dart';
import 'package:open_trivia_king/widgets/fade_in_with_delay.dart';
import 'package:open_trivia_king/widgets/sliding_list_tile_with_delay.dart';
import 'package:open_trivia_king/widgets/rounded_elevated_button.dart';

class GameGameOver extends StatelessWidget {
  const GameGameOver({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GameState gameState = Provider.of<GameState>(context, listen: false);
    UserState userState = Provider.of<UserState>(context, listen: false);
    AudioController audioController =
        Provider.of<AudioController>(context, listen: false);

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
              gameState.sessionData.totalCorrects.toString(),
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 120, fontWeight: FontWeight.bold),
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
            onPressed: () {
              userState
                  .updateUserStateFromGameSessionData(gameState.sessionData);
              audioController.bgm.pause();
              audioController.bgm.seek(0);
              Navigator.pop(context);
            },
          ),
        ),
        const SizedBox(height: 48),
        SlidingListTileWithDelay(
            title: "Total question(s) answered:",
            trailing: gameState.sessionData.totalAnswered.toString(),
            delay: 2000),
        SlidingListTileWithDelay(
            title: "Highest streak:",
            trailing: gameState.sessionData.highestStreak.toString(),
            delay: 2250),
        const Divider(height: 24),
        for (String category in gameState.sessionData.answeredByCategory.keys)
          SlidingListTileWithDelay(
            title: category,
            trailing: "${gameState.sessionData.correctsByCategory[category]}/"
                "${gameState.sessionData.answeredByCategory[category]}",
            delay: 2500 + i++ * 200,
          ),
      ],
    );
  }
}
