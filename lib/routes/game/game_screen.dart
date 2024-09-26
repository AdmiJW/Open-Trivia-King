import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:open_trivia_king/routes/game/game_body.dart';
import 'package:open_trivia_king/states/audio.dart';
import 'package:open_trivia_king/states/game.dart';
import 'package:open_trivia_king/states/stats.dart';
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
class GameScreen extends HookConsumerWidget {
  final String gameMode;

  const GameScreen({super.key, required this.gameMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audio = ref.watch(audioServiceProvider);
    final gameNotifier = ref.watch(gameStateProvider.notifier);
    final gameSessionNotifier = ref.watch(gameSessionProvider.notifier);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        gameNotifier.reset(gameMode);
        gameSessionNotifier.reset();
        audio.playBgm();
      });
      return;
    }, []);

    // When the user wants to go back, use PopScope to intercept.
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final game = ref.read(gameStateProvider);
        bool isGameOver = game.status == GameStatus.gameOver;
        bool isError = game.status == GameStatus.error;

        if (isGameOver || isError) return finishGame(context, ref);
        bool? confirm = await showQuitConfirmation(context);
        if (confirm == true && context.mounted) finishGame(context, ref);
      },
      child: ScaffoldWithAssetBackground(
        fallbackBackgroundColor: Colors.lightBlue.shade50,
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
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Quit")),
        ],
      ),
    );
  }

  Future<void> finishGame(BuildContext ctx, WidgetRef ref) async {
    final statsNotifier = ref.read(statsStateProvider.notifier);
    final gameSession = ref.read(gameSessionProvider);
    final audio = ref.read(audioServiceProvider);

    audio.stopBgm();
    await statsNotifier.updateFromGameSession(gameSession);
    if (ctx.mounted) Navigator.popUntil(ctx, ModalRoute.withName('/'));
  }
}
