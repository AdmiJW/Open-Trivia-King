import 'package:flutter/material.dart';
import 'package:open_trivia_king/states/auth_state.dart';
import 'package:provider/provider.dart';

import 'package:open_trivia_king/states/user_state.dart';
import 'package:open_trivia_king/widgets/fade_in_with_delay.dart';
import 'package:open_trivia_king/widgets/rounded_elevated_button.dart';
import 'package:open_trivia_king/routes/settings/settings_signin.dart';
import 'package:open_trivia_king/routes/settings/settings_googleuser.dart';

class SettingsBody extends StatelessWidget {
  const SettingsBody({Key? key}) : super(key: key);

  //* Title
  static const Widget _title = FadeInWithDelay(
    delay: 0,
    duration: 500,
    child: Text("Settings",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 40,
        )),
  );

  //* Clear Local user data button
  Widget _getClearLocalUserDataButton(context, userState) =>
      RoundedElevatedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Clear local user data  "),
            Icon(Icons.delete_forever),
          ],
        ),
        onPressed: () => clearUserStateProcedure(context, userState),
        fontSize: 20,
        backgroundColor: Colors.red,
      );

  @override
  Widget build(BuildContext context) {
    UserState userState = Provider.of<UserState>(context);
    AuthState authState = Provider.of<AuthState>(context);

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      children: [
        _title,
        const SizedBox(
          height: 20,
        ),
        authState.authState == AuthStateEnum.loggedOut
            ? const SettingsSignIn()
            : const SettingsGoogleUser(),
        const Divider(height: 20),
        _getClearLocalUserDataButton(context, userState),
      ],
    );
  }

  //? ==============================================
  //? Settings Procedures
  //? =============================================

  void clearUserStateProcedure(BuildContext ctx, UserState userState) async {
    bool? confirmDelete = await showDialog<bool>(
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

    if (confirmDelete == null || !confirmDelete) return;
    await userState.resetUserState();

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
