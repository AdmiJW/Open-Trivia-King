import 'package:flutter/material.dart';



class MyTheme {
	static ThemeData get lightTheme => ThemeData(
		primaryColor: Colors.blue,
		scaffoldBackgroundColor: Colors.transparent,
		fontFamily: 'Sansation',

		appBarTheme: const AppBarTheme(
			backgroundColor: Colors.transparent,
			foregroundColor: Colors.black,
			shadowColor: Colors.transparent,
		),
	);
}