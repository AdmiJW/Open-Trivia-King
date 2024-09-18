import 'package:flutter/material.dart';
import 'package:open_trivia_king/states/auth_state.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:open_trivia_king/states/user_state.dart';
import 'package:open_trivia_king/widgets/fade_in_with_delay.dart';
import 'package:open_trivia_king/widgets/rounded_elevated_button.dart';
import 'package:open_trivia_king/services/firebase_operations.dart';

//? The section shown when the user is logged in

class SettingsGoogleUser extends StatelessWidget {
  const SettingsGoogleUser({super.key});

  //* Simple Profile section
  Widget _getProfile(AuthState authState) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            foregroundImage: authState.profilePicUrl != null
                ? Image.network(authState.profilePicUrl!).image
                : null,
            child: Text(authState.displayName?[0] ?? "User"),
          ),
          const SizedBox(
            width: 20,
          ),
          Text(authState.displayName ?? "Anonymous",
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold))
        ],
      );

  //* Sync to cloud button
  Widget _getSyncToCloudButton(AuthState authState, UserState userState) =>
      FadeInWithDelay(
        delay: 0,
        duration: 750,
        child: RoundedElevatedButton(
          onPressed: () async {
            Fluttertoast.showToast(
              msg: "Saving... Please wait",
            );
            await saveProfilePicToStorage(authState, userState);
            await saveUserStateToFirestore(authState, userState);
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
        ),
      );

  //* Sync with cloud button
  Widget _getSyncFromCloudButton(
          BuildContext ctx, AuthState authState, UserState userState) =>
      FadeInWithDelay(
        delay: 250,
        duration: 750,
        child: RoundedElevatedButton(
          onPressed: () async {
            bool? confirmDelete = await showDialog<bool>(
                context: ctx,
                builder: (context) => AlertDialog(
                      title: const Text("Sync with cloud?"),
                      content: const Text(
                          "Your local game data will be overwritten"),
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

            if (confirmDelete == null || !confirmDelete) return;
            await loadUserStateFromFirestore(authState, userState);
            await loadProfilePicFromStorage(authState, userState);
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
        ),
      );

  //* Sign out button
  Widget _getSignOutButton(AuthState authState) => FadeInWithDelay(
        delay: 500,
        duration: 750,
        child: RoundedElevatedButton(
          onPressed: () async {
            await authState.signOut();
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
        ),
      );

  @override
  Widget build(BuildContext context) {
    AuthState authState = Provider.of<AuthState>(context);
    UserState userState = Provider.of<UserState>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _getProfile(authState),
        const SizedBox(height: 30),
        _getSyncToCloudButton(authState, userState),
        _getSyncFromCloudButton(context, authState, userState),
        _getSignOutButton(authState),
      ],
    );
  }
}
