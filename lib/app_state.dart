import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class MyAppState extends ChangeNotifier {

  var current = WordPair.random();
  var favourites = <WordPair>[];

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  void toggleFavourite() {
    if (favourites.contains(current)) {
        favourites.remove(current);
    } else {
        favourites.add(current);
    }
    notifyListeners();
    }
}

