import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:open_trivia_king/states/game_state.dart';

// Error screen.
class GameError extends StatelessWidget {
  const GameError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GameState gameState = Provider.of<GameState>(context, listen: false);

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
            gameState.errorMessage ?? "Unkwown error",
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
          )
        ],
      ),
    );
  }
}
