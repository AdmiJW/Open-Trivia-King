import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:open_trivia_king/routes/game/game_body.dart';
import 'package:open_trivia_king/states/game_state.dart';
import 'package:open_trivia_king/states/user_state.dart';
import 'package:open_trivia_king/states/audio_controller.dart';
import 'package:open_trivia_king/widgets/scaffold_with_asset_background.dart';

// Top level Game Widget
// Conceptual Tree:
//		(Game State)
//		     |
//		(Will Pop State)
//			|
//		(Scaffold)--------------------------------------------------------------
//		/		   \			 \							\					\
//	(Loading)	(Splash Screen)    (ANSWERING Screen)	(ANSWER REVEAL Screen) (Game Over Screen)
class GameScreen extends StatelessWidget {
  final String _gameMode;

  const GameScreen({super.key, String gameMode = 'Normal'})
      : _gameMode = gameMode;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: GameState(_gameMode == 'Normal' ? 1 : null),
        ),
      ],
      builder: (ctx, child) => const GameScreenScaffold(),
    );
  }
}

class GameScreenScaffold extends StatelessWidget {
  const GameScreenScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    AudioController audioController =
        Provider.of<AudioController>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      audioController.bgm.play();
    });

    // When the user wants to go back, use PopScope to intercept.
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        GameState gameState = Provider.of<GameState>(context, listen: false);
        bool isGameOver = gameState.state == GameStates.gameOver;
        bool isError = gameState.state == GameStates.error;

        if (isGameOver || isError) return finishGame(context);
        bool? confirm = await showQuitConfirmation(context);
        if (confirm == true && context.mounted) finishGame(context);
      },
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
    );
  }

  Future<bool?> showQuitConfirmation(BuildContext ctx) async {
    return await showDialog<bool>(
      context: ctx,
      builder: (ctx) => AlertDialog(
        title: const Text("Quit Quiz?"),
        content: const Text("Your game data will be recorded"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text("Cancel")),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text("Quit")),
        ],
      ),
    );
  }

  void finishGame(BuildContext ctx) {
    saveGameStats(ctx);
    stopMusic(ctx);
    Navigator.popUntil(ctx, ModalRoute.withName('/'));
  }

  void saveGameStats(BuildContext ctx) {
    GameState gameState = Provider.of<GameState>(ctx, listen: false);
    UserState userState = Provider.of<UserState>(ctx, listen: false);
    userState.updateUserStateFromGameSessionData(gameState.sessionData);
  }

  void stopMusic(BuildContext ctx) {
    AudioController audioController =
        Provider.of<AudioController>(ctx, listen: false);
    audioController.bgm.pause();
    audioController.bgm.seek(0);
  }
}
