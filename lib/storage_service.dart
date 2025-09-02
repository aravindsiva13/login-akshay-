import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class StorageService {
  static const String _usersKey = 'users_database';

  // Save user (like SQLite INSERT)
  static Future<void> saveUser(String email, String name, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey) ?? '[]';
    final List<dynamic> usersList = jsonDecode(usersJson);

    // Check if email exists
    if (usersList.any((user) => user['email'] == email)) {
      throw Exception('Email already exists');
    }

    // Add new user
    usersList.add({
      'id': DateTime.now().millisecondsSinceEpoch,
      'email': email,
      'name': name,
      'password': password,
    });

    await prefs.setString(_usersKey, jsonEncode(usersList));
  }

  // Get user (like SQLite SELECT)
  static Future<UserModel?> getUser(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey) ?? '[]';
    final List<dynamic> usersList = jsonDecode(usersJson);

    final userData = usersList.firstWhere(
      (user) => user['email'] == email && user['password'] == password,
      orElse: () => null,
    );

    if (userData != null) {
      return UserModel(
        id: userData['id'].toString(),
        email: userData['email'],
        name: userData['name'],
      );
    }
    return null;
  }

  // Check if email exists (like SQLite WHERE)
  static Future<bool> emailExists(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey) ?? '[]';
    final List<dynamic> usersList = jsonDecode(usersJson);
    return usersList.any((user) => user['email'] == email);
  }

  // Get all users (like SQLite SELECT *)
  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey) ?? '[]';
    final List<dynamic> usersList = jsonDecode(usersJson);
    return usersList.cast<Map<String, dynamic>>();
  }

  // Clear all users (like SQLite DELETE)
  static Future<void> clearAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usersKey);
  }
}