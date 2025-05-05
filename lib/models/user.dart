import 'reading_plan.dart';
import 'package:flutter/foundation.dart';

class User extends ValueNotifier<User?> {
  String _language;
  UserReadingPlan? _readingPlan;

  User({
    String language = 'en',
    UserReadingPlan? readingPlan,
  })  : _language = language,
        _readingPlan = readingPlan,
        super(null) {
    value = this;  // Set itself as the value
  }

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
