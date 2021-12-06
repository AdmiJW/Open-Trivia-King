import 'package:flutter/material.dart';
import 'package:open_trivia_king/states/audio_controller.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'package:open_trivia_king/states/game_state.dart';
import 'package:open_trivia_king/widgets/expand_with_delay.dart';
import 'package:open_trivia_king/widgets/fade_in_with_delay.dart';
import 'package:open_trivia_king/widgets/rounded_elevated_button.dart';


class GameQuestion extends StatelessWidget {
	const GameQuestion({ Key? key }) : super(key: key);

	@override
	Widget build(BuildContext context) {
		GameState gameState = Provider.of<GameState>(context);
		AudioController audioController = Provider.of<AudioController>(context);

		// If it is answer reveal state, then automatically proceed after 5 seconds.
		if (gameState.state == GameStates.ANSWER_REVEAL) {
			Future.delayed(const Duration(seconds: 5), ()=> gameState.progressState());
		}

		return ListView(
			children: [
				getLivesLeftIndicator(gameState),
				const SizedBox(height: 20,),
				getQuestionTitleText(gameState),
				const SizedBox(height: 10,),
				getQuestionCategoryText(gameState),
				const SizedBox(height: 50,),
				getQuestionText(gameState),
				const SizedBox(height: 50,),
				getAnswerOptions(gameState, audioController),
			],
		);
	}






	static const Icon emptyHeart = Icon(
		Icons.favorite_border,
		size: 50,
		color: Colors.grey,
	);

	static const Icon filledHeart = Icon(
		Icons.favorite,
		size: 50,
		color: Colors.pinkAccent,
	);

	Widget getLivesLeftIndicator(GameState gameState) {
		if (gameState.livesLeft == null) {
			return const FadeInWithDelay(
				delay: 0,
				duration: 750,
				child: Text(
					"Unlimited Mode",
					textAlign: TextAlign.center,
					style: TextStyle(fontWeight: FontWeight.w300, fontSize: 30, color: Colors.grey),
				),
			);
		} 

		return FadeInWithDelay(
			delay: 0,
			duration: 750,
			child: Row(
				mainAxisAlignment: MainAxisAlignment.center,
				children: [
					(gameState.livesLeft! > 0)? filledHeart: emptyHeart,
					(gameState.livesLeft! > 1)? filledHeart: emptyHeart,
					(gameState.livesLeft! > 2)? filledHeart: emptyHeart,
				],
			),
		);
	}



	Widget getQuestionTitleText(GameState gameState)=> FadeInWithDelay(
		delay: 250, 
		duration: 750,
		child: Text(
			"Question ${gameState.questionNo}",
			textAlign: TextAlign.center,
			style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
		)
	);


	Widget getQuestionCategoryText(GameState gameState)=> FadeInWithDelay(
		delay: 500, 
		duration: 750,
		child: Text(
			gameState.currTrivia?.category ?? "Unknown Category",
			textAlign: TextAlign.center,
			style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
		)
	);



	Widget getQuestionText(GameState gameState)=> FadeInWithDelay(
		delay: 1750, 
		duration: 750,
		child: Padding(
			padding: const EdgeInsets.symmetric(horizontal: 10),
			child: Text(
				gameState.currTrivia?.question ?? "Error Occurred. Please restart the application",
				textAlign: TextAlign.center,
				style: const TextStyle(fontSize: 25),
			),
		)
	);


	Widget getAnswerOptions(GameState gameState, AudioController audioController) {
		List<dynamic> choices = gameState.currTrivia!.choices;
		int i = 0;

		return Padding(
			padding: const EdgeInsets.symmetric( horizontal: 16.0),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [
					for (String choice in choices)
						ExpandWithDelay(
							delay: 3000 + i++ * 250, 
							duration: 500,
							child: RoundedElevatedButton(
								text: choice,
								fontSize: 20,
								onPressed: (){
									if (gameState.state == GameStates.ANSWERING) {
										gameState.checkAnswerAndUpdateSessionData(audioController, choice);
										gameState.progressState();
									}
								},
								yMargin: 5,
								xPadding: 5,
								primaryColor: (
									gameState.state == GameStates.ANSWERING?
									Colors.blue:
									gameState.currTrivia?.answer == choice? Colors.green: Colors.red
								),
							),
						),
				],
			),
		);
	}

}