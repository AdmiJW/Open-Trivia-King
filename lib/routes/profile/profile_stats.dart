import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:open_trivia_king/states/user_state.dart';
import 'package:open_trivia_king/widgets/sliding_list_tile_with_delay.dart';

class ProfileStats extends StatelessWidget {
  static const int baseDelay = 600;

  const ProfileStats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserState userState = Provider.of<UserState>(context, listen: false);
    int iterateIndex = 0;

    return Column(
      children: [
        SlidingListTileWithDelay(
          title: "Total Answered",
          trailing: userState.totalQuestionsAnswered.toString(),
          delay: baseDelay,
        ),
        SlidingListTileWithDelay(
          title: "Total Corrects",
          trailing: userState.totalQuestionsAnsweredCorrectly.toString(),
          delay: baseDelay + 200,
        ),
        SlidingListTileWithDelay(
          title: "Highest Streak",
          trailing: userState.highestStreak.toString(),
          delay: baseDelay + 400,
        ),
        const Divider(height: 20),
        SlidingListTileWithDelay(
          title: "Most Answered Category",
          trailing: userState.getMostAnsweredCategory(),
          delay: baseDelay + 600,
        ),
        SlidingListTileWithDelay(
            title: "Most Proficient Category",
            trailing: userState.getMostProficientCategory(),
            delay: baseDelay + 800),
        const Divider(height: 20),
        for (String category in userState.categoriesAnswered.keys)
          SlidingListTileWithDelay(
            title: category,
            trailing: "${userState.categoriesAnsweredCorrectly[category]}/"
                "${userState.categoriesAnswered[category]}",
            delay: baseDelay + 1000 + (100 * iterateIndex++),
          ),
      ],
    );
  }
}
