import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPreferences {
  static const _keyUsers = 'users';
  static const _keyUsername = 'username';

  static Future<Map<String, String>> getAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyUsers);
    if (raw == null) return {};
    final map = json.decode(raw) as Map<String, dynamic>;
    return map.map((k, v) => MapEntry(k, v.toString()));
  }

  static Future<void> saveUser(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await getAllUsers();
    users[username] = password;
    await prefs.setString(_keyUsers, json.encode(users));
  }

  static Future<bool> checkLogin(String username, String password) async {
    final users = await getAllUsers();
    return users[username] == password;
  }

  static Future<bool> isUserExist(String username) async {
    final users = await getAllUsers();
    return users.containsKey(username);
  }

  static Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, username);
  }

  static Future<String?> getLoggedInUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUsername);
  }
}
