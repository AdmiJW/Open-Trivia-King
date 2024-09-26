import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:open_trivia_king/firebase_options.dart';
import 'package:open_trivia_king/data/theme.dart';
import 'package:open_trivia_king/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: UnfocusTextFieldOnTapOutside(
        child: OpenTriviaKing(),
      ),
    ),
  );
}

class UnfocusTextFieldOnTapOutside extends StatelessWidget {
  final Widget? child;

  const UnfocusTextFieldOnTapOutside({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: child,
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        bool hasPrimaryFocus = currentFocus.hasPrimaryFocus;
        bool hasFocusedChild = currentFocus.focusedChild != null;

        if (!hasPrimaryFocus && hasFocusedChild) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
    );
  }
}

class OpenTriviaKing extends StatelessWidget {
  const OpenTriviaKing({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Open Trivia King',
      theme: AppTheme.lightTheme,
      routes: routes,
    );
  }
}
