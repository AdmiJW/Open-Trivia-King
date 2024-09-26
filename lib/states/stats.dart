import 'dart:math';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:open_trivia_king/data/categories.dart';
import 'package:open_trivia_king/states/game.dart';

final statsBoxProvider = FutureProvider<Box>((ref) async => Hive.openBox('stats'));

class StatsState {
  final int totalQuestionsAnswered;
  final int totalQuestionsAnsweredCorrectly;
  final int highestStreak;
  Map<String, int> categoriesAnswered;
  Map<String, int> categoriesAnsweredCorrectly;

  static Map<String, int> get initialMap => Map.fromEntries(categories.map((e) => MapEntry(e, 0)));

  String get mostAnsweredCategory {
    final res = categoriesAnswered.entries.reduce((accumulate, element) {
      return accumulate.value > element.value ? accumulate : element;
    }).key;

    if (categoriesAnswered[res] == 0) return '-';
    return res;
  }

  String get mostProficientCategory {
    final res = categoriesAnsweredCorrectly.entries.reduce((accumulate, element) {
      return accumulate.value > element.value ? accumulate : element;
    }).key;

    if (categoriesAnsweredCorrectly[res] == 0) return '-';
    return res;
  }

  StatsState({
    this.totalQuestionsAnswered = 0,
    this.totalQuestionsAnsweredCorrectly = 0,
    this.highestStreak = 0,
    this.categoriesAnswered = const {},
    this.categoriesAnsweredCorrectly = const {},
  }) {
    if (categoriesAnswered.isEmpty) categoriesAnswered = initialMap;
    if (categoriesAnsweredCorrectly.isEmpty) {
      categoriesAnsweredCorrectly = initialMap;
    }
  }

  StatsState copyWith({
    int? totalQuestionsAnswered,
    int? totalQuestionsAnsweredCorrectly,
    int? highestStreak,
    Map<String, int>? categoriesAnswered,
    Map<String, int>? categoriesAnsweredCorrectly,
  }) {
    return StatsState(
      totalQuestionsAnswered: totalQuestionsAnswered ?? this.totalQuestionsAnswered,
      totalQuestionsAnsweredCorrectly: totalQuestionsAnsweredCorrectly ?? this.totalQuestionsAnsweredCorrectly,
      highestStreak: highestStreak ?? this.highestStreak,
      categoriesAnswered: categoriesAnswered ?? this.categoriesAnswered,
      categoriesAnsweredCorrectly: categoriesAnsweredCorrectly ?? this.categoriesAnsweredCorrectly,
    );
  }
}

class StatsNotifier extends Notifier<StatsState> {
  Future<Box> get _box async => ref.watch(statsBoxProvider.future);

  @override
  StatsState build() {
    state = StatsState();
    loadFromPersistentStorage();
    return state;
  }

  Future<void> saveToPersistentStorage() async {
    final box = await _box;
    await box.put('totalQuestionsAnswered', state.totalQuestionsAnswered);
    await box.put('totalQuestionsAnsweredCorrectly', state.totalQuestionsAnsweredCorrectly);
    await box.put('highestStreak', state.highestStreak);
    await box.put('categoriesAnswered', state.categoriesAnswered);
    await box.put('categoriesAnsweredCorrectly', state.categoriesAnsweredCorrectly);
  }

  Future<void> loadFromPersistentStorage() async {
    final box = await _box;
    state = state.copyWith(
      totalQuestionsAnswered: box.get('totalQuestionsAnswered') ?? 0,
      totalQuestionsAnsweredCorrectly: box.get('totalQuestionsAnsweredCorrectly') ?? 0,
      highestStreak: box.get('highestStreak') ?? 0,
      categoriesAnswered: Map<String, int>.from(box.get('categoriesAnswered') ?? {}),
      categoriesAnsweredCorrectly: Map<String, int>.from(box.get('categoriesAnsweredCorrectly') ?? {}),
    );
  }

  Future<void> reset() async {
    state = StatsState();
    await saveToPersistentStorage();
  }

  Future<void> set({
    int? totalQuestionsAnswered,
    int? totalQuestionsAnsweredCorrectly,
    int? highestStreak,
    Map<String, int>? categoriesAnswered,
    Map<String, int>? categoriesAnsweredCorrectly,
  }) async {
    state = state.copyWith(
      totalQuestionsAnswered: totalQuestionsAnswered,
      totalQuestionsAnsweredCorrectly: totalQuestionsAnsweredCorrectly,
      highestStreak: highestStreak,
      categoriesAnswered: categoriesAnswered,
      categoriesAnsweredCorrectly: categoriesAnsweredCorrectly,
    );
    await saveToPersistentStorage();
  }

  Future<void> updateFromGameSession(GameSession gameSession) async {
    final answeredByCategory = Map.fromEntries([
      ...state.categoriesAnswered.entries,
      ...gameSession.answeredByCategory.entries.map((e) => MapEntry(e.key, state.categoriesAnswered[e.key]! + e.value)),
    ]);
    final correctsByCategory = Map.fromEntries([
      ...state.categoriesAnsweredCorrectly.entries,
      ...gameSession.correctsByCategory.entries
          .map((e) => MapEntry(e.key, state.categoriesAnsweredCorrectly[e.key]! + e.value)),
    ]);

    state = state.copyWith(
      totalQuestionsAnswered: state.totalQuestionsAnswered + gameSession.totalAnswered,
      totalQuestionsAnsweredCorrectly: state.totalQuestionsAnsweredCorrectly + gameSession.totalCorrects,
      highestStreak: max(state.highestStreak, gameSession.highestStreak),
      categoriesAnswered: answeredByCategory,
      categoriesAnsweredCorrectly: correctsByCategory,
    );
    await saveToPersistentStorage();
  }
}

final statsStateProvider = NotifierProvider<StatsNotifier, StatsState>(StatsNotifier.new);
