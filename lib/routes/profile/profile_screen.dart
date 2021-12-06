import 'package:flutter/material.dart';


import 'package:open_trivia_king/routes/profile/profile_body.dart';
import 'package:open_trivia_king/widgets/scaffold_with_asset_background.dart';



class ProfileScreen extends StatelessWidget {
	const ProfileScreen({ Key? key }) : super(key: key);

	static final _appBar = AppBar(
		title: const Text("Open Trivia King"),
		centerTitle: true,
	);


	@override
	Widget build(BuildContext context) {
		return ScaffoldWithAssetBackground(
			backgroundPath: "assets/images/wallpp.png",
			scaffold: Scaffold(
				appBar: _appBar,
				body: const ProfileBody(),
			), 
		);
	}
}