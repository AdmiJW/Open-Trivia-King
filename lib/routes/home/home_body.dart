import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:open_trivia_king/states/category_state.dart';
import 'package:open_trivia_king/widgets/rounded_elevated_button.dart';
import 'package:open_trivia_king/routes/home/home_categorylist.dart';


/// The main body of the Home Screen
/// Consist of title, buttons, and CategoryList
class AppBody extends StatelessWidget {
	const AppBody({ Key? key }) : super(key: key);


	@override
	Widget build(BuildContext context) {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				_title,
				const _ClearSelectAllButtonGroup(),
				const Expanded(child: CategoryList()),
				const SizedBox(height: 4,),
				_getStartQuizButton(context),
				_getUnlimitedQuizButton(context),
				const SizedBox(height: 4,),
			],
		);
	}


	// Title
	static const _titleStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 35 );

	final _title = const Text(
		'Select Categories',
		textAlign: TextAlign.center,
		style: _titleStyle,
	);



	// Buttons
	RoundedElevatedButton _getStartQuizButton(BuildContext context) {
		var categoryProvider = Provider.of<CategoryState>(context, listen: false);

		return RoundedElevatedButton(
			text: "Start Quiz",
			xMargin: 50, yMargin: 2,
			xPadding: 0, yPadding: 5,
			primaryColor: Colors.green.shade600,
			fontSize: 25,
			borderRadius: 30,
			onPressed: ()=> goToGameRoute(context, categoryProvider, 'Normal'),	
		);
	}

	RoundedElevatedButton _getUnlimitedQuizButton(BuildContext context) {
		var categoryProvider = Provider.of<CategoryState>(context, listen: false);

		return RoundedElevatedButton(
			text: "Unlimited Mode",
			xMargin: 50, yMargin: 2,
			xPadding: 0, yPadding: 5,
			primaryColor: Colors.amber.shade900,
			fontSize: 25,
			borderRadius: 30,
			onPressed: ()=> goToGameRoute(context, categoryProvider, 'Unlimited'),
		);
	} 
	

	void goToGameRoute(BuildContext ctx, CategoryState categoryProvider, String gameMode) {
		if (!categoryProvider.isAnyCategorySelected() ) {
			ScaffoldMessenger.of(ctx).showSnackBar(
				const SnackBar( content: Text("Please select at least one category!") ),
			);
		} else {
			Navigator.of(ctx).pushNamed('/game', arguments: gameMode);
		}
	}
}





/// A row representing a button group consisting of "Select All" and "Clear All" button
class _ClearSelectAllButtonGroup extends StatelessWidget {
 	const _ClearSelectAllButtonGroup({ Key? key }) : super(key: key);

  	@override
	Widget build(BuildContext context) {
		var categoryProvider = Provider.of<CategoryState>(context, listen: false);

		List<Widget> children = [
			Expanded(
				child: RoundedElevatedButton(
					text: 'Clear All',
					onPressed: ()=> categoryProvider.setAllCategoryTo(false),
					fontSize: 15,
				),
			),
			const SizedBox(width: 10,),
			Expanded(
				child: RoundedElevatedButton(
					text: 'Select All',
					onPressed: ()=> categoryProvider.setAllCategoryTo(true),
					fontSize: 15,
				),
			),
		];
		
		return Padding(
			padding: const EdgeInsets.symmetric(horizontal: 10),
			child: Row( children: children ),
		);
	}
}
