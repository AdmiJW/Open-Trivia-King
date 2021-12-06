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
	const GameBody({ Key? key }) : super(key: key);


	@override
	Widget build(BuildContext context) {
		return Selector<GameState, GameStates>(
			selector: (ctx, gameState)=> gameState.state,
			builder: (ctx, state, child) {
				switch (state) {
					case GameStates.LOADING:
						return const GameLoading();
					case GameStates.SPLASH_SCREEN:
						return const GameSplashScreen();
					case GameStates.ANSWERING:
					case GameStates.ANSWER_REVEAL:
						return const GameQuestion();
					case GameStates.GAME_OVER:
						return const GameGameOver();
					case GameStates.ERROR:
						return const GameError();
					default: 
						return const Center(
							child: Text(
								"Error occurred in GameState.\nPlease try restarting the application",
								textAlign: TextAlign.center,
							),
						);
				}
			}
		);
	}
}