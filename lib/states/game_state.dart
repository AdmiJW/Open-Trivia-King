import 'dart:math';
import 'package:flutter/material.dart';
import 'package:open_trivia_king/services/fetch_trivia.dart';
import 'package:open_trivia_king/states/audio_controller.dart';

// All the possible states for the game screen.
enum GameStates {
  // ignore: constant_identifier_names
  loading,
  splashScreen,
  answering,
  answerReveal,
  gameOver,
  error,
}

// Contains the game session data
class GameSessionData {
  int totalAnswered = 0;
  int totalCorrects = 0;
  int highestStreak = 0;
  Map<String, int> answeredByCategory = {};
  Map<String, int> correctsByCategory = {};
}

class GameState extends ChangeNotifier {
  GameStates state = GameStates.loading;

  int questionNo = 0;
  int? livesLeft; // If the game mode is unlimited, then the lives will be null

  Trivia? currTrivia;

  GameSessionData sessionData = GameSessionData();
  int currentStreak = 0;

  GameState(int? initialLife) : livesLeft = initialLife;

  String? errorMessage;

  //*-------------------
  //* Actions
  //*-------------------
  void progressState() {
    if (livesLeft != null &&
        livesLeft! <= 0 &&
        state == GameStates.answerReveal) {
      state = GameStates.gameOver;
    } else {
      state = GameStates.values[(state.index + 1) % 4];
    }
    notifyListeners();
  }

  void switchToErrorState(String errorMessage) {
    this.errorMessage = errorMessage;
    state = GameStates.error;

    notifyListeners();
  }

  Future<void> fetchQuestionIntoState(String category) async {
    ++questionNo;

    // If error is thrown, it is thrown from fetchNewQuestion in services.dart, and should be handled
    // by using switchToErrorState() in the same state
    currTrivia = await fetchNewQuestion(category);
  }

  void checkAnswerAndUpdateSessionData(
      AudioController audioController, String playerChoice) {
    // 1 if correct, 0 if incorrect
    int isCorrect = (playerChoice == currTrivia?.answer) ? 1 : 0;
    String category = currTrivia!.category;

    // Play correct/incorrect sound effect
    if (isCorrect == 1) {
      audioController.correctSfx.play();
    } else {
      audioController.wrongSfx.play();
    }

    // Deduct the lives if the player answered incorrectly
    if (livesLeft != null) {
      livesLeft = livesLeft! - (isCorrect ^ 1);
    }

    // Update game session data
    currentStreak += isCorrect;
    sessionData.highestStreak = max(sessionData.highestStreak, currentStreak);
    ++sessionData.totalAnswered;
    sessionData.totalCorrects += isCorrect;

    sessionData.answeredByCategory[category] =
        sessionData.answeredByCategory.putIfAbsent(category, () => 0) + 1;
    sessionData.correctsByCategory[category] =
        sessionData.correctsByCategory.putIfAbsent(category, () => 0) +
            isCorrect;
  }
}
