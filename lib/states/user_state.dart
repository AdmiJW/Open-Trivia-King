import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import 'dart:math';

import 'package:open_trivia_king/configurations.dart';
import 'package:open_trivia_king/states/game_state.dart';

class UserState extends ChangeNotifier {
  Box? userBox;

  String username;
  File? profilePic;
  int totalQuestionsAnswered = 0;
  int totalQuestionsAnsweredCorrectly = 0;
  int highestStreak = 0;

  Map<String, int> categoriesAnswered = {};
  Map<String, int> categoriesAnsweredCorrectly = {};

  UserState() : username = "Anonymous" {
    // Initialize the map to fill with categories defined in configurations.dart
    for (String category in categories) {
      categoriesAnswered[category] = 0;
      categoriesAnsweredCorrectly[category] = 0;
    }
    // Try to load saved user data from Hive's persistent storage
    _loadUserStateFromPersistentStorage();
  }

  Future<void> _saveUserStateIntoPersistentStorage({
    bool saveUsername = true,
    bool saveProfilePic = true,
    bool saveGameData = true,
  }) async {
    Box userBox = this.userBox ?? await Hive.openBox('user');
    this.userBox = userBox;

    if (saveUsername) {
      userBox.put('username', username);
    }
    if (saveProfilePic) {
      userBox.put('profilePicPath', profilePic?.path);
    }
    if (saveGameData) {
      userBox.put('totalQuestionsAnswered', totalQuestionsAnswered);
      userBox.put(
          'totalQuestionsAnsweredCorrectly', totalQuestionsAnsweredCorrectly);
      userBox.put('highestStreak', highestStreak);
      userBox.put('categoriesAnswered', categoriesAnswered);
      userBox.put('categoriesAnsweredCorrectly', categoriesAnsweredCorrectly);
    }
  }

  Future<void> _loadUserStateFromPersistentStorage() async {
    Box userBox = this.userBox ?? await Hive.openBox('user');
    this.userBox = userBox;

    username = userBox.get('username') ?? username;
    profilePic = userBox.get('profilePicPath') != null
        ? File(userBox.get('profilePicPath'))
        : profilePic;

    totalQuestionsAnswered =
        userBox.get('totalQuestionsAnswered') ?? totalQuestionsAnswered;
    totalQuestionsAnsweredCorrectly =
        userBox.get('totalQuestionsAnsweredCorrectly') ??
            totalQuestionsAnsweredCorrectly;
    highestStreak = userBox.get('highestStreak') ?? highestStreak;

    for (MapEntry<dynamic, dynamic> entry
        in userBox.get('categoriesAnswered')?.entries ?? {}) {
      categoriesAnswered[entry.key] = entry.value;
    }
    for (MapEntry<dynamic, dynamic> entry
        in userBox.get('categoriesAnsweredCorrectly')?.entries ?? {}) {
      categoriesAnsweredCorrectly[entry.key] = entry.value;
    }
    notifyListeners();
  }

  // Reset everything of the user state from persistent storage.
  Future<void> resetUserState() async {
    username = "Anonymous";
    // To reset profile picture, we also need to delete the saved photo from storage
    if (profilePic != null && profilePic!.existsSync()) {
      await profilePic!.delete();
    }
    profilePic = null;
    totalQuestionsAnswered = 0;
    totalQuestionsAnsweredCorrectly = 0;
    highestStreak = 0;

    categoriesAnswered.clear();
    categoriesAnsweredCorrectly.clear();
    for (String category in categories) {
      categoriesAnswered[category] = 0;
      categoriesAnsweredCorrectly[category] = 0;
    }

    // Persistent storage is done by overwriting every value with reset value
    await _saveUserStateIntoPersistentStorage();
    notifyListeners();
  }

  // Getters method
  String getMostAnsweredCategory() {
    return categoriesAnswered.entries.reduce((accumulate, element) {
      return accumulate.value > element.value ? accumulate : element;
    }).key;
  }

  String getMostProficientCategory() {
    return categoriesAnsweredCorrectly.entries.reduce((accumulate, element) {
      return accumulate.value > element.value ? accumulate : element;
    }).key;
  }

  // Actions
  void setUsername(String username) async {
    this.username = username;
    await _saveUserStateIntoPersistentStorage(
        saveProfilePic: false, saveGameData: false);
    notifyListeners();
  }

  void setUserState({
    String? username,
    File? profilePic,
    int? totalQuestionsAnswered,
    int? totalQuestionsAnsweredCorrectly,
    int? highestStreak,
    Map<String, int>? categoriesAnswered,
    Map<String, int>? categoriesAnsweredCorrectly,
  }) async {
    this.username = username ?? this.username;
    this.totalQuestionsAnswered =
        totalQuestionsAnswered ?? this.totalQuestionsAnswered;
    this.totalQuestionsAnsweredCorrectly =
        totalQuestionsAnsweredCorrectly ?? this.totalQuestionsAnsweredCorrectly;
    this.highestStreak = highestStreak ?? this.highestStreak;
    this.categoriesAnswered = categoriesAnswered ?? this.categoriesAnswered;
    this.categoriesAnsweredCorrectly =
        categoriesAnsweredCorrectly ?? this.categoriesAnsweredCorrectly;

    if (profilePic != null) {
      setProfilePic(profilePic);
    }

    await _saveUserStateIntoPersistentStorage();
    notifyListeners();
  }

  void setProfilePic(File image) async {
    if (!image.existsSync()) {
      throw ArgumentError(
          "Invalid non-existent profile picture provided at ${image.path}");
    }

    // Delete the old profile pic before setting to a new profile picture
    if (profilePic != null &&
        profilePic!.existsSync() &&
        profilePic!.path != image.path) {
      profilePic!.deleteSync();
    }

    profilePic = image;

    //! These is required to ensure any caches of previous images are cleared.
    imageCache.clear();
    imageCache.clearLiveImages();

    await _saveUserStateIntoPersistentStorage(
        saveUsername: false, saveGameData: false);
    notifyListeners();
  }

  void updateUserStateFromGameSessionData(GameSessionData sessionData) async {
    totalQuestionsAnswered += sessionData.totalAnswered;
    totalQuestionsAnsweredCorrectly += sessionData.totalCorrects;
    highestStreak = max(highestStreak, sessionData.highestStreak);

    for (var entry in sessionData.answeredByCategory.entries) {
      categoriesAnswered[entry.key] =
          categoriesAnswered.putIfAbsent(entry.key, () => 0) + entry.value;
    }

    for (var entry in sessionData.correctsByCategory.entries) {
      categoriesAnsweredCorrectly[entry.key] =
          categoriesAnsweredCorrectly.putIfAbsent(entry.key, () => 0) +
              entry.value;
    }

    await _saveUserStateIntoPersistentStorage(
        saveUsername: false, saveProfilePic: false);
    notifyListeners();
  }
}
