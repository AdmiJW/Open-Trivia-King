import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:open_trivia_king/widgets/rounded_elevated_button.dart';
import 'package:open_trivia_king/routes/home/home_categorylist.dart';
import 'package:open_trivia_king/states/category.dart';

class AppBody extends ConsumerWidget {
  const AppBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Title(),
        const QuickControls(),
        const Expanded(child: CategoryList()),
        const SizedBox(
          height: 4,
        ),
        StartQuizButton(routeCallback: (route) => routeCallback(context, ref, route)),
        UnlimitedQuizButton(routeCallback: (route) => routeCallback(context, ref, route)),
        const SizedBox(
          height: 4,
        ),
      ],
    );
  }

  void routeCallback(BuildContext ctx, WidgetRef ref, String route) {
    final category = ref.read(categoryStateProvider);

    if (!category.isAnySelected) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text("Please select at least one category!")),
      );
      return;
    }

    Navigator.of(ctx).pushNamed(route);
  }
}

class Title extends StatelessWidget {
  const Title({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Select Categories',
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
    );
  }
}

/// A row representing a button group consisting of "Select All" and "Clear All" button
class QuickControls extends ConsumerWidget {
  const QuickControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryNotifier = ref.watch(categoryStateProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(children: [
        Expanded(
          child: RoundedElevatedButton(
            text: 'Clear All',
            onPressed: () => categoryNotifier.setAllTo(false),
            fontSize: 15,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: RoundedElevatedButton(
            text: 'Select All',
            onPressed: () => categoryNotifier.setAllTo(true),
            fontSize: 15,
          ),
        ),
      ]),
    );
  }
}

class StartQuizButton extends StatelessWidget {
  final void Function(String) routeCallback;

  const StartQuizButton({super.key, required this.routeCallback});

  @override
  Widget build(BuildContext context) {
    return RoundedElevatedButton(
      text: "Start Quiz",
      xMargin: 50,
      yMargin: 2,
      xPadding: 0,
      yPadding: 5,
      backgroundColor: Colors.green.shade600,
      fontSize: 25,
      borderRadius: 30,
      onPressed: () => routeCallback('/game-normal'),
    );
  }
}

class UnlimitedQuizButton extends StatelessWidget {
  final void Function(String) routeCallback;

  const UnlimitedQuizButton({super.key, required this.routeCallback});

  @override
  Widget build(BuildContext context) {
    return RoundedElevatedButton(
      text: "Unlimited Mode",
      xMargin: 50,
      yMargin: 2,
      xPadding: 0,
      yPadding: 5,
      backgroundColor: Colors.amber.shade900,
      fontSize: 25,
      borderRadius: 30,
      onPressed: () => routeCallback('/game-unlimited'),
    );
  }
}
