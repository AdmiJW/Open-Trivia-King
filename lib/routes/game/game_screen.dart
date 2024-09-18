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
class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _confirmPop = false;

  @override
  Widget build(BuildContext context) {
    String gameMode = ModalRoute.of(context)!.settings.arguments as String;
    AudioController audioController = Provider.of<AudioController>(context);
    audioController.bgm.play();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: GameState(gameMode == 'Normal' ? 3 : null),
        ),
      ],
      // When the user wants to go back, ask for confirmation
      builder: (context, child) => PopScope(
        canPop: canPop(context),
        onPopInvoked: (didPop) {
          if (didPop) {
            stopGame(context);
          } else {
            showQuitConfirmationDialog(context);
          }
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
      ),
    );
  }

  Future<void> showQuitConfirmationDialog(BuildContext ctx) async {
    TextButton cancelButton = TextButton(
      onPressed: () => Navigator.pop(ctx),
      child: const Text("Cancel"),
    );
    TextButton exitButton = TextButton(
      onPressed: () {
        Navigator.pop(ctx);
        _confirmPop = true;
        Navigator.pop(ctx);
      },
      child: const Text("Exit to Home"),
    );

    await showDialog<void>(
        context: ctx,
        builder: (ctx) => AlertDialog(
              title: const Text("Quit Quiz?"),
              content: const Text("Your game data will be recorded"),
              actions: [
                cancelButton,
                exitButton,
              ],
            ));
  }

  // Getter to get canPop boolean
  bool canPop(BuildContext ctx) {
    GameState gameState = Provider.of<GameState>(ctx, listen: false);

    bool isGameOver = gameState.state == GameStates.gameOver;
    bool isError = gameState.state == GameStates.error;

    return isGameOver || isError || _confirmPop;
  }

  void stopGame(BuildContext ctx) {
    UserState userState = Provider.of<UserState>(ctx, listen: false);
    GameState gameState = Provider.of<GameState>(ctx, listen: false);
    AudioController audioController =
        Provider.of<AudioController>(ctx, listen: false);

    userState.updateUserStateFromGameSessionData(gameState.sessionData);
    audioController.bgm.pause();
    audioController.bgm.seek(0);
  }
}
