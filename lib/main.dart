//! General Packages
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:open_trivia_king/firebase_options.dart';

//! Other packages
import 'package:open_trivia_king/themes/theme.dart';

//! Top Level States
import 'package:open_trivia_king/states/category_state.dart';
import 'package:open_trivia_king/states/user_state.dart';
import 'package:open_trivia_king/states/audio_controller.dart';
import 'package:open_trivia_king/states/auth_state.dart';

//! Routes
import 'package:open_trivia_king/routes/routes.dart';


void main() async {
	WidgetsFlutterBinding.ensureInitialized();
	await Hive.initFlutter();

    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
    );

	runApp(const OpenTriviaKing());
}



//?===============================================================================
//? Top level widget - MaterialApp wrapped in top level state Provider wrapped
//?===============================================================================
class OpenTriviaKing extends StatelessWidget {
	const OpenTriviaKing({ Key? key }) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return MultiProvider(
			providers: [
				ChangeNotifierProvider.value(value: CategoryState()),
				ChangeNotifierProvider.value(value: UserState()),
				ChangeNotifierProvider.value(value: AudioController()),
				ChangeNotifierProvider.value(value: AuthState()),
			],

			//? The GestureDetector is to dismiss keyboard whenever user taps anywhere outside of text field.
			child: GestureDetector(
				child: MaterialApp(
					title: 'Open Trivia King',
					theme: MyTheme.lightTheme,
					routes: routes,
				),
				//? Attempts to unfocus the text field when tapped on area outside of text field
				onTap: () {
					FocusScopeNode currentFocus = FocusScope.of(context);

					if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
						FocusManager.instance.primaryFocus?.unfocus();
        			}
				}
			),
		);
	}
}