import 'package:flutter/material.dart';

import 'package:open_trivia_king/routes/home/home_screen.dart';
import 'package:open_trivia_king/routes/profile/profile_screen.dart';
import 'package:open_trivia_king/routes/game/game_screen.dart';
import 'package:open_trivia_king/routes/settings/settings_screen.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (BuildContext ctx) => const HomeScreen(),
  '/profile': (BuildContext ctx) => const ProfileScreen(),
  '/game': (BuildContext ctx) => const GameScreen(),
  '/settings': (BuildContext ctx) => const SettingsScreen(),
};
