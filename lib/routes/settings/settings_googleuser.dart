import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_trivia_king/states/auth.dart';
import 'package:open_trivia_king/states/firebase.dart';
import 'package:open_trivia_king/widgets/fade_in_with_delay.dart';
import 'package:open_trivia_king/widgets/rounded_elevated_button.dart';

class SettingsGoogleUser extends StatelessWidget {
  const SettingsGoogleUser({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Profile(),
        SizedBox(height: 30),
        SyncToCloudButton(),
        SyncFromCloudButton(),
        SignOutButton(),
      ],
    );
  }
}

class Profile extends ConsumerWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 40,
          foregroundImage: auth.profilePicUrl != null ? Image.network(auth.profilePicUrl!).image : null,
          child: Text(auth.displayName?[0] ?? "User"),
        ),
        const SizedBox(
          width: 20,
        ),
        Text(auth.displayName ?? "Anonymous", style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold))
      ],
    );
  }
}

class SyncToCloudButton extends ConsumerWidget {
  const SyncToCloudButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebase = ref.watch(firebaseProvider.notifier);

    return FadeInWithDelay(
        delay: 0,
        duration: 750,
        child: RoundedElevatedButton(
          onPressed: () async {
            Fluttertoast.showToast(
              msg: "Saving... Please wait",
            );
            await firebase.saveProfilePicToStorage();
            await firebase.saveToFirestore();
          },
          fontSize: 20,
          backgroundColor: Colors.blue,
          yMargin: 2,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Sync to cloud  "),
              Icon(Icons.upload),
            ],
          ),
        ));
  }
}

class SyncFromCloudButton extends ConsumerWidget {
  const SyncFromCloudButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebase = ref.watch(firebaseProvider.notifier);

    return FadeInWithDelay(
        delay: 250,
        duration: 750,
        child: RoundedElevatedButton(
          onPressed: () async {
            bool? confirmDelete = await showConfirmDialog(context);

            if (confirmDelete == null || !confirmDelete) return;

            await firebase.loadFromFirestore();
            await firebase.loadProfilePicFromStorage();
          },
          fontSize: 20,
          backgroundColor: Colors.blue,
          yMargin: 2,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Sync with cloud  "),
              Icon(Icons.download),
            ],
          ),
        ));
  }

  Future<bool?> showConfirmDialog(BuildContext ctx) async {
    return await showDialog<bool>(
        context: ctx,
        builder: (context) => AlertDialog(
              title: const Text("Sync with cloud?"),
              content: const Text("Your local game data will be overwritten"),
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
}

class SignOutButton extends ConsumerWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authStateProvider.notifier);

    return FadeInWithDelay(
        delay: 500,
        duration: 750,
        child: RoundedElevatedButton(
          onPressed: () async {
            await authNotifier.signOut();
            Fluttertoast.showToast(
              msg: "Signed out successfully.",
            );
          },
          fontSize: 20,
          backgroundColor: Colors.blue,
          yMargin: 2,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Log out  "),
              Icon(Icons.logout),
            ],
          ),
        ));
  }
}
