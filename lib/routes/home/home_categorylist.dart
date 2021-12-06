import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:open_trivia_king/states/category_state.dart';



class CategoryList extends StatelessWidget {
	const CategoryList({ Key? key }) : super(key: key);

	@override
	Widget build(BuildContext context) {
		var provider = Provider.of<CategoryState>(context);

		return ListView(
			children: [
				for (var category in provider.categorySelection.entries) 
					ListTile(
						title: Text( category.key ),
						trailing: Checkbox(
							value: category.value,
							onChanged: (_)=> provider.toggleCategorySelection(category.key),
						),
						onTap: ()=> provider.toggleCategorySelection(category.key),
					),
			],
		);
	}
}