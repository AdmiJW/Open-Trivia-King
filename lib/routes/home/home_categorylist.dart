import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:open_trivia_king/states/category.dart';

class CategoryList extends ConsumerWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(categoryStateProvider);
    final categoryNotifier = ref.watch(categoryStateProvider.notifier);

    return ListView(
      children: [
        for (var category in category.selections.entries)
          ListTile(
            title: Text(category.key),
            trailing: Checkbox(
              value: category.value,
              onChanged: (_) => categoryNotifier.toggle(category.key),
            ),
            onTap: () => categoryNotifier.toggle(category.key),
          ),
      ],
    );
  }
}
