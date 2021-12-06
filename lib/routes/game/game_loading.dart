import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:open_trivia_king/states/category_state.dart';
import 'package:open_trivia_king/states/game_state.dart';
import 'package:open_trivia_king/widgets/fade_in_with_delay.dart';




class GameLoading extends StatelessWidget {
	const GameLoading({ Key? key }) : super(key: key);

	@override
	Widget build(BuildContext context) {
		
		GameState gameState = Provider.of<GameState>(context, listen: false);
		CategoryState categoryState = Provider.of<CategoryState>(context, listen: false);

		// Upon entering this state, begin fetch the new trivia question
		gameState.
			fetchQuestionIntoState( categoryState.getRandomSelectedCategory() )
			.then((_)=> gameState.progressState())
			.onError((error, stackTrace) => gameState.switchToErrorState( error.toString() ) );


		return FadeInWithDelay(
			delay: 0,
			duration: 750,
			child: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				crossAxisAlignment: CrossAxisAlignment.center,
				children: const [
					SizedBox(width: double.infinity),	// Use to expand column to screen width
					CircularProgressIndicator(),
					SizedBox(height: 20,),
					Text(
						"Fetching question from Open Trivia DB...",
						textAlign: TextAlign.center,
					),
				],
			),
		);
	}
}