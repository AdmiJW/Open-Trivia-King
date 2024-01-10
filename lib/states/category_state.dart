import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:math';

import 'package:open_trivia_king/configurations.dart';

class CategoryState extends ChangeNotifier {
  Box<bool>? box;
  Map<String, bool> categorySelection = {};

  CategoryState() {
    for (String category in categories) {
      categorySelection[category] = true;
    }
    _loadCategorySelectionFromPersistentStorage();
  }

  void _saveCategorySelectionIntoPersistentStorage() async {
    Box<bool> box = this.box ?? await Hive.openBox<bool>('categories');
    this.box = box;
    box.putAll(categorySelection);
  }

  void _loadCategorySelectionFromPersistentStorage() async {
    Box<bool> box = this.box ?? await Hive.openBox<bool>('categories');
    this.box = box;

    for (String category in box.keys) {
      categorySelection[category] = box.get(category)!;
    }
    notifyListeners();
  }

  //*-------------------
  //* Actions
  //*-------------------
  void toggleCategorySelection(String categoryName) {
    if (!categorySelection.containsKey(categoryName)) return;

    categorySelection[categoryName] = !(categorySelection[categoryName]!);
    _saveCategorySelectionIntoPersistentStorage();
    notifyListeners();
  }

  void setAllCategoryTo(bool value) {
    for (var c in categorySelection.keys) {
      categorySelection[c] = value;
    }
    _saveCategorySelectionIntoPersistentStorage();
    notifyListeners();
  }

  bool isAnyCategorySelected() {
    return categorySelection.values.any((element) => element);
  }

  String getRandomSelectedCategory() {
    List<String> selectedCategories = [];
    for (String category in categorySelection.keys) {
      if (categorySelection[category]!) {
        selectedCategories.add(category);
      }
    }

    return selectedCategories[Random().nextInt(selectedCategories.length)];
  }
}
