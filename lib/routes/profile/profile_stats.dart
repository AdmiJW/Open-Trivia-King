import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:open_trivia_king/states/user_state.dart';
import 'package:open_trivia_king/widgets/sliding_list_tile_with_delay.dart';

class ProfileStats extends StatelessWidget {
  static const int baseDelay = 600;
  static const int delayIncrement = 50;

  const ProfileStats({super.key});

  Widget getListTile(String title, Object trailing, int index) {
    return SlidingListTileWithDelay(
      title: title,
      trailing: trailing.toString(),
      delay: baseDelay + (delayIncrement * index),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserState userState = Provider.of<UserState>(context, listen: false);
    int totalQuestionsAnswered = userState.totalQuestionsAnswered;
    int totalQuestionsAnsweredCorrectly =
        userState.totalQuestionsAnsweredCorrectly;
    int highestStreak = userState.highestStreak;
    String mostAnsweredCategory = userState.getMostAnsweredCategory();
    String mostProficientCategory = userState.getMostProficientCategory();
    Map<String, int> categoriesAnswered = userState.categoriesAnswered;
    Map<String, int> categoriesAnsweredCorrectly =
        userState.categoriesAnsweredCorrectly;
    int iterationIndex = 0;

    return Column(
      children: [
        getListTile("Total Answered", totalQuestionsAnswered, 0),
        getListTile("Total Corrects", totalQuestionsAnsweredCorrectly, 1),
        getListTile("Highest Streak", highestStreak, 2),
        const Divider(height: 20),
        getListTile("Most Answered Category", mostAnsweredCategory, 3),
        getListTile("Most Proficient Category", mostProficientCategory, 4),
        const Divider(height: 20),
        for (String category in userState.categoriesAnswered.keys)
          getListTile(
            category,
            "${categoriesAnsweredCorrectly[category]}/"
            "${categoriesAnswered[category]}",
            5 + (iterationIndex++),
          ),
      ],
    );
  }
}
