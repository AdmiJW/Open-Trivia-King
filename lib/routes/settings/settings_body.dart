import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:open_trivia_king/states/auth.dart';
import 'package:open_trivia_king/states/profile.dart';
import 'package:open_trivia_king/states/stats.dart';
import 'package:open_trivia_king/widgets/fade_in_with_delay.dart';
import 'package:open_trivia_king/widgets/rounded_elevated_button.dart';
import 'package:open_trivia_king/routes/settings/settings_signin.dart';
import 'package:open_trivia_king/routes/settings/settings_googleuser.dart';

class SettingsBody extends ConsumerWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      children: [
        const Title(),
        const SizedBox(
          height: 20,
        ),
        auth.status == AuthStatus.loggedOut ? const SettingsSignIn() : const SettingsGoogleUser(),
        const Divider(height: 20),
        const ClearLocalUserDataButton(),
      ],
    );
  }
}

class Title extends StatelessWidget {
  const Title({super.key});

  @override
  Widget build(BuildContext context) {
    return const FadeInWithDelay(
      delay: 0,
      duration: 500,
      child: Text("Settings",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40,
          )),
    );
  }
}

class ClearLocalUserDataButton extends ConsumerWidget {
  const ClearLocalUserDataButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RoundedElevatedButton(
      onPressed: () => clearUserStateProcedure(context, ref),
      fontSize: 20,
      backgroundColor: Colors.red,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Clear local user data  "),
          Icon(Icons.delete_forever),
        ],
      ),
    );
  }

  Future<void> clearUserStateProcedure(BuildContext ctx, WidgetRef ref) async {
    bool? confirm = await showConfirmDialog(ctx);

    if (confirm == null || !confirm) return;

    final profileNotifier = ref.read(profileStateProvider.notifier);
    final statsNotifier = ref.read(statsStateProvider.notifier);
    await profileNotifier.reset();
    await statsNotifier.reset();

    if (ctx.mounted) await showSuccessDialog(ctx);
  }

  Future<bool?> showConfirmDialog(BuildContext ctx) async {
    return await showDialog<bool>(
        context: ctx,
        builder: (context) => AlertDialog(
              title: const Text("Reset data?"),
              content: const Text(
                  "Are you sure you want to reset data? Your profile picture, username, and game data will be gone"
                  " and never be retrieved!"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('OK'),
                ),
              ],
            ));
  }

  Future<void> showSuccessDialog(BuildContext ctx) async {
    await showDialog<void>(
        context: ctx,
        builder: (context) => AlertDialog(
              title: const Text("Success"),
              content: const Text("User data successfully cleared."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ));
  }
}
