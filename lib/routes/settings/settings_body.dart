import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'package:open_trivia_king/states/user_state.dart';
import 'package:open_trivia_king/widgets/fade_in_with_delay.dart';
import 'package:open_trivia_king/widgets/rounded_elevated_button.dart';



class SettingsBody extends StatelessWidget {
	const SettingsBody({ Key? key }) : super(key: key);


	static const Widget title = FadeInWithDelay( 
		delay: 0, 
		duration: 500,
		child: Text(
			"Settings",
			textAlign: TextAlign.center,
			style: TextStyle(
				fontWeight: FontWeight.bold,
				fontSize: 40,
			)
		),
	);


	@override
	Widget build(BuildContext context) {
		UserState userState = Provider.of<UserState>(context);

		return ListView(
			padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
			children: [
				title,
				const SizedBox(height: 20,),
				FadeInWithDelay(
					delay: 500,
					duration: 750,
					child: RoundedElevatedButton(
						text: "Clear user data",
						onPressed: ()=> clearUserStateProcedure(context, userState),
						fontSize: 20,
						primaryColor: Colors.red,
					),
				)
			],
		);
  	}


	void clearUserStateProcedure(BuildContext ctx, UserState userState) async {
		bool? confirmDelete = await showDialog<bool>(
			context: ctx,
			builder: (context)=> AlertDialog(
				title: const Text("Reset data?"),
				content: const Text(
					"Are you sure you want to reset data? Your profile picture, username, and game data will be gone"
					" and never be retrieved!"
				),
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
			)
		);
		
		if (confirmDelete == null || !confirmDelete) return;
		await userState.resetUserState();

		await showDialog<void>(
			context: ctx,
			builder: (context)=> AlertDialog(
				title: const Text("Success"),
				content: const Text(
					"User data successfully cleared."
				),
				actions: [
					TextButton(
						onPressed: () => Navigator.pop(context),
						child: const Text('OK'),
					),
				],
			)
		);
	}
}