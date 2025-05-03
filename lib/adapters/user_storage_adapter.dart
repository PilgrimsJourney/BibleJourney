// lib/adapters/user_storage_adapter.dart
import 'package:hive/hive.dart';
import '../models/user.dart';

class UserStorageAdapter {
  final Box<User> _userBox;
  User? _user;

  UserStorageAdapter(this._userBox);

  void setUser(User user) {
    _user = user;
    _user!.addListener(_saveUser); // Listen for changes
    _saveUser(); // Initial save
  }

  User? loadUser() {
    return _userBox.get('currentUser');
  }

  Future<void> _saveUser() async {
    if (_user != null) {
      await _userBox.put('currentUser', _user!);
    }
  }

  Box<User> get userBox => _userBox; // For ValueListenableBuilder

  void dispose() {
    if (_user != null) {
      _user!.removeListener(_saveUser);
    }
  }
}
