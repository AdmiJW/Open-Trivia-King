import 'package:flutter/material.dart';
import 'package:open_trivia_king/states/auth_state.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:open_trivia_king/widgets/fade_in_with_delay.dart';
import 'package:open_trivia_king/widgets/rounded_elevated_button.dart';


//? The section shown when the user haven't signed in



class SettingsSignIn extends StatelessWidget {
	const SettingsSignIn({ Key? key }) : super(key: key);



	//* Sign in with Google button
	Widget _getSignInWithGoogleButton(BuildContext context, AuthState authState)=> FadeInWithDelay(
		delay: 0,
		duration: 750,
		child: RoundedElevatedButton(
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
			onPressed: () async {
				if (await authState.signInWithGoogle() != null) {
					Fluttertoast.showToast(
						msg: "Signed in as ${authState.displayName ?? "Anonymous"} successfully.",
					);
				} else {
					Fluttertoast.showToast(msg: "Sign in with Google failed.",);
				}
			},
			fontSize: 20,
			primaryColor: Colors.blue,
			yMargin: 2,			
		),
	);


	@override
	Widget build(BuildContext context) {
		AuthState authState = Provider.of<AuthState>(context);

		return Column(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				_getSignInWithGoogleButton(context, authState),
			],
		);
  	}
}