import 'package:flutter/material.dart';

import 'package:open_trivia_king/widgets/fade_in_with_delay.dart';
import 'package:open_trivia_king/routes/profile/profile_avatar.dart';
import 'package:open_trivia_king/routes/profile/profile_username.dart';
import 'package:open_trivia_king/routes/profile/profile_stats.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({Key? key}) : super(key: key);

  static const Widget title = FadeInWithDelay(
    delay: 0,
    duration: 500,
    child: Text("Profile",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 40,
        )),
  );

  static const Widget profilePic = FadeInWithDelay(
    delay: 250,
    duration: 500,
    child: ProfileAvatar(),
  );

  static const Widget profileUsername = FadeInWithDelay(
    delay: 500,
    duration: 500,
    child: ProfileUsername(),
  );

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      children: const [
        title,
        SizedBox(
          height: 20,
        ),
        profilePic,
        SizedBox(height: 20),
        profileUsername,
        SizedBox(height: 20),
        ProfileStats(),
      ],
    );
  }
}
