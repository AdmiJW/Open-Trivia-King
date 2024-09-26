import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:open_trivia_king/states/auth.dart';
import 'package:open_trivia_king/widgets/fade_in_with_delay.dart';
import 'package:open_trivia_king/widgets/rounded_elevated_button.dart';

class SettingsSignIn extends StatelessWidget {
  const SettingsSignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SignInWithGoogleButton(),
      ],
    );
  }
}

class SignInWithGoogleButton extends ConsumerWidget {
  const SignInWithGoogleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authStateProvider.notifier);

    onPressed() async {
      if (await authNotifier.signInWithGoogle() != null) {
        final auth = ref.read(authStateProvider);
        final displayName = auth.displayName;
        Fluttertoast.showToast(
          msg: "Signed in as ${displayName ?? "Anonymous"} successfully.",
        );
        return;
      }

      Fluttertoast.showToast(
        msg: "Sign in with Google failed.",
      );
    }

    return FadeInWithDelay(
      delay: 0,
      duration: 750,
      child: RoundedElevatedButton(
        fontSize: 20,
        backgroundColor: Colors.blue,
        yMargin: 2,
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Sign in with  "),
            Image.asset(
              'assets/images/google.png',
              height: 24,
              width: 24,
            ),
          ],
        ),
      ),
    );
  }
}
