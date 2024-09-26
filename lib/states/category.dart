import 'dart:math';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:open_trivia_king/data/categories.dart';

final categoryBoxProvider = FutureProvider<Box<bool>>((ref) async => Hive.openBox<bool>('categories'));

class CategoryState {
  final Map<String, bool> selections;

  CategoryState({required this.selections}) {
    for (String cat in categories) {
      if (!selections.containsKey(cat)) selections[cat] = false;
    }
  }

  bool get isAnySelected => selections.values.any((element) => element);
  List<String> get selectedCategories =>
      selections.entries.where((entry) => entry.value).map((entry) => entry.key).toList();
  String get randomSelectedCategory {
    final categories = selectedCategories;
    final randomIndex = Random().nextInt(categories.length);
    return categories[randomIndex];
  }
}

class CategoryNotifier extends Notifier<CategoryState> {
  Future<Box<bool>> get _box async => ref.watch(categoryBoxProvider.future);

  @override
  CategoryState build() {
    state = CategoryState(selections: {});
    _loadFromPersistentStorage();
    return state;
  }

  Future<void> toggle(String category) async {
    final updatedSelections = {...state.selections, category: !state.selections[category]!};
    state = CategoryState(selections: updatedSelections);
    await _saveToPersistentStorage();
  }

  Future<void> setAllTo(bool value) async {
    final updatedSelections = state.selections.map((category, _) => MapEntry(category, value));
    state = CategoryState(selections: updatedSelections);
    await _saveToPersistentStorage();
  }

  Future<void> _saveToPersistentStorage() async {
    final box = await _box;
    await box.putAll(state.selections);
  }

  Future<void> _loadFromPersistentStorage() async {
    final box = await _box;
    final selections =
        Map<String, bool>.fromEntries(box.keys.map((category) => MapEntry(category, box.get(category)!)));
    state = CategoryState(selections: selections);
  }
}

final categoryStateProvider = NotifierProvider<CategoryNotifier, CategoryState>(CategoryNotifier.new);
