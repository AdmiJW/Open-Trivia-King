import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'package:open_trivia_king/routes/game/game_body.dart';
import 'package:open_trivia_king/states/game_state.dart';
import 'package:open_trivia_king/states/user_state.dart';
import 'package:open_trivia_king/states/audio_controller.dart';
import 'package:open_trivia_king/widgets/scaffold_with_asset_background.dart';



// TOp level Game Widget
// Conceptual Tree:
//		(Game State)
//		     |
//		(Will Pop State)
//			|
//		(Scaffold)--------------------------------------------------------------
//		/		   \			 \							\					\
//	(Loading)	(Splash Screen)    (ANSWERING Screen)	(ANSWER REVEAL Screen) (Game Over Screen)
class GameScreen extends StatelessWidget {
	const GameScreen({ Key? key }) : super(key: key);

	@override
	Widget build(BuildContext context) {
		String gameMode = ModalRoute.of(context)!.settings.arguments as String;
		AudioController audioController = Provider.of<AudioController>(context);
		audioController.bgm.play();

		return MultiProvider(
			providers: [
				ChangeNotifierProvider.value(value: GameState( gameMode == 'Normal'? 3: null),),
			],
			// When the user wants to go back, ask for confirmation
			builder: (context, child) => WillPopScope(
				onWillPop: _getOnWillPopHandler(context),
				child: ScaffoldWithAssetBackground(
					backgroundPath: "assets/images/wallpp.png",
					scaffold: Scaffold(
						appBar: AppBar(
							title: const Text("Open Trivia King"),
							centerTitle: true,
						),
						body: const GameBody(),
					),
				),
			),
		);
	}



	//? Get the onWillPop Event handler for the WillPopScope.
	//? When the quiz state is popped, update the user data with the GameSessionData in GameState
	Future<bool> Function() _getOnWillPopHandler(BuildContext ctx) {
		GameState gameState = Provider.of<GameState>(ctx, listen: false);
		UserState userState = Provider.of<UserState>(ctx, listen: false);
		AudioController audioController = Provider.of<AudioController>(ctx, listen: false);

		// If the state is not GameOver state, then we have to ask the user whether to return to homescreen or not.
		return () async {
			if (gameState.state == GameStates.GAME_OVER || gameState.state == GameStates.ERROR) {
				userState.updateUserStateFromGameSessionData( gameState.sessionData );
				audioController.bgm.pause();
				audioController.bgm.seek(0);
				return true;
			}

			return (await showDialog<bool>(
				context: ctx,
				builder: (ctx)=> AlertDialog(
					title: const Text("Quit Quiz?"),
				content: const Text("Your game data will be recorded"),
					actions: [
						TextButton(
							onPressed: ()=> Navigator.pop(ctx, false),
							child: const Text("Cancel"),
						),
						TextButton(
							onPressed: () {
								audioController.bgm.pause();
								audioController.bgm.seek(0);
								userState.updateUserStateFromGameSessionData( gameState.sessionData );
								Navigator.pop(ctx, true);
							},
							child: const Text("Exit to Home"),
						),
					],
				)
			))!;
		};
	}

}