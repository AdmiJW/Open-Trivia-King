import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:open_trivia_king/states/audio.dart';
import 'package:open_trivia_king/states/trivia.dart';

enum GameStatus {
  loading,
  splashScreen,
  answering,
  answerReveal,
  gameOver,
  error,
}

//=======================================
// Game State - Question no, lives left
//=======================================
class GameState {
  final GameStatus status;
  final int questionNo;
  final int? livesLeft;
  final int currentStreak;
  final String? errorMessage;

  GameState(
      {this.status = GameStatus.loading,
      this.questionNo = 0,
      this.livesLeft,
      this.currentStreak = 0,
      this.errorMessage});

  GameState copyWith({
    GameStatus? status,
    int? questionNo,
    int? livesLeft,
    int? currentStreak,
    String? errorMessage,
  }) {
    return GameState(
      status: status ?? this.status,
      questionNo: questionNo ?? this.questionNo,
      livesLeft: livesLeft ?? this.livesLeft,
      currentStreak: currentStreak ?? this.currentStreak,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class GameNotifier extends Notifier<GameState> {
  @override
  GameState build() => GameState();

  void reset(String gameMode) => state = GameState(livesLeft: gameMode == "Unlimited" ? null : 3);

  void progress() {
    if (state.livesLeft != null && state.livesLeft! <= 0 && state.status == GameStatus.answerReveal) {
      state = state.copyWith(status: GameStatus.gameOver);
      return;
    }

    state = state.copyWith(status: GameStatus.values[(state.status.index + 1) % 4]);
  }

  void switchToErrorState(String errorMessage) {
    state = state.copyWith(status: GameStatus.error, errorMessage: errorMessage);
  }

  Future<void> fetchNewQuestion(String category) async {
    final triviaNotifier = ref.read(triviaProvider.notifier);
    state = state.copyWith(questionNo: state.questionNo + 1, status: GameStatus.loading);

    try {
      await triviaNotifier.fetchTrivia(category);
      progress();
    } catch (e) {
      switchToErrorState(e.toString());
    }
  }

  void submitAnswer(String answer) {
    final audio = ref.read(audioServiceProvider);
    final trivia = ref.read(triviaProvider).value!;
    final gameSessionNotifier = ref.read(gameSessionProvider.notifier);

    final isCorrect = answer == trivia.answer;

    // Play correct/incorrect sound effect
    if (isCorrect) {
      audio.playCorrect();
    } else {
      audio.playWrong();
    }

    // Deduct the lives if the player answered incorrectly, and the game mode is not unlimited
    if (state.livesLeft != null && !isCorrect) {
      state = state.copyWith(livesLeft: state.livesLeft! - 1);
    }

    // Update current streak
    state = state.copyWith(currentStreak: isCorrect ? state.currentStreak + 1 : 0);

    gameSessionNotifier.update(trivia.category, isCorrect, state.currentStreak);
  }
}

final gameStateProvider = NotifierProvider<GameNotifier, GameState>(GameNotifier.new);

//================================================
// Game Session - Contains stats of one game
//================================================
class GameSession {
  final int totalAnswered;
  final int totalCorrects;
  final int highestStreak;
  final Map<String, int> answeredByCategory;
  final Map<String, int> correctsByCategory;

  GameSession({
    this.totalAnswered = 0,
    this.totalCorrects = 0,
    this.highestStreak = 0,
    this.answeredByCategory = const {},
    this.correctsByCategory = const {},
  });

  GameSession copyWith({
    int? totalAnswered,
    int? totalCorrects,
    int? highestStreak,
    Map<String, int>? answeredByCategory,
    Map<String, int>? correctsByCategory,
  }) {
    return GameSession(
      totalAnswered: totalAnswered ?? this.totalAnswered,
      totalCorrects: totalCorrects ?? this.totalCorrects,
      highestStreak: highestStreak ?? this.highestStreak,
      answeredByCategory: answeredByCategory ?? this.answeredByCategory,
      correctsByCategory: correctsByCategory ?? this.correctsByCategory,
    );
  }
}

class GameSessionNotifier extends Notifier<GameSession> {
  @override
  GameSession build() => GameSession();

  void reset() => state = GameSession();

  void update(String category, bool isCorrect, int streak) {
    state = state.copyWith(
      totalAnswered: state.totalAnswered + 1,
      totalCorrects: state.totalCorrects + (isCorrect ? 1 : 0),
      highestStreak: max(state.highestStreak, streak),
      answeredByCategory: {
        ...state.answeredByCategory,
        category: (state.answeredByCategory[category] ?? 0) + 1,
      },
      correctsByCategory: {
        ...state.correctsByCategory,
        category: (state.correctsByCategory[category] ?? 0) + (isCorrect ? 1 : 0),
      },
    );
  }
}

final gameSessionProvider = NotifierProvider<GameSessionNotifier, GameSession>(GameSessionNotifier.new);
