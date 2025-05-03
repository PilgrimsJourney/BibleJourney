import 'reading_plan.dart';
import 'package:flutter/foundation.dart';

class User with ChangeNotifier {
  String _language;
  UserReadingPlan? _readingPlan;

  User({
    String language = 'en',
    UserReadingPlan? readingPlan,
  })  : _language = language,
        _readingPlan = readingPlan;

  String get language => _language;
  UserReadingPlan? get readingPlan => _readingPlan;

  set language(String value) {
    _language = value;
    notifyListeners();
  }

  set readingPlan(UserReadingPlan? value) {
    _readingPlan = value;
    notifyListeners();
  }
}

// Global User instance
User? globalUser;
