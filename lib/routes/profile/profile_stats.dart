import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:open_trivia_king/states/stats.dart';
import 'package:open_trivia_king/widgets/sliding_list_tile_with_delay.dart';

class ProfileStats extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsStateProvider);
    int totalQuestionsAnswered = stats.totalQuestionsAnswered;
    int totalQuestionsAnsweredCorrectly = stats.totalQuestionsAnsweredCorrectly;
    int highestStreak = stats.highestStreak;
    String mostAnsweredCategory = stats.mostAnsweredCategory;
    String mostProficientCategory = stats.mostProficientCategory;
    Map<String, int> categoriesAnswered = stats.categoriesAnswered;
    Map<String, int> categoriesAnsweredCorrectly = stats.categoriesAnsweredCorrectly;
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
        for (String category in categoriesAnswered.keys)
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
