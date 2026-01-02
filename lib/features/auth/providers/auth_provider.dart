import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// User Model
class MyAppUser {
  final String id;
  final String email;
  final String name;

  MyAppUser({required this.id, required this.email, required this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'email': email, 'name': name};
  }

  factory MyAppUser.fromMap(Map<String, dynamic> map) {
    return MyAppUser(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MyAppUser.fromJson(String source) =>
      MyAppUser.fromMap(json.decode(source));
}

// Auth State
class AuthState {
  final MyAppUser? user;
  final bool isLoading;
  final String? error;

  AuthState({this.user, this.isLoading = false, this.error});

  AuthState copyWith({MyAppUser? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error, // Error is nullable, allows clearing it
    );
  }
}

// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(isLoading: true)) {
    checkAuth();
  }

  static const String _userKey = 'curr_user';
  static const String _usersDbKey =
      'all_users_db'; // Simulating a DB in SharedPreferences

  Future<void> checkAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userStr = prefs.getString(_userKey);
      if (userStr != null) {
        state = AuthState(user: MyAppUser.fromJson(userStr));
      } else {
        state = AuthState(); // Not logged in
      }
    } catch (e) {
      state = AuthState(error: e.toString());
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await Future.delayed(const Duration(seconds: 1)); // Simulate net delay
      final prefs = await SharedPreferences.getInstance();

      // Check if user already exists
      final usersDbStr = prefs.getString(_usersDbKey);
      Map<String, dynamic> usersDb =
          usersDbStr != null ? json.decode(usersDbStr) : {};

      if (usersDb.containsKey(email)) {
        throw Exception("User with this email already exists");
      }

      // Create new user (Storing password plain text for local demo ONLY - NOT SECURE for real apps)
      final newUser = MyAppUser(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: name,
      );
      usersDb[email] = {'user': newUser.toMap(), 'password': password};

      await prefs.setString(_usersDbKey, json.encode(usersDb));

      // Auto login
      await prefs.setString(_userKey, newUser.toJson());
      state = AuthState(user: newUser);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await Future.delayed(const Duration(seconds: 1));
      final prefs = await SharedPreferences.getInstance();

      final usersDbStr = prefs.getString(_usersDbKey);
      if (usersDbStr == null) {
        throw Exception("User not found");
      }

      Map<String, dynamic> usersDb = json.decode(usersDbStr);

      if (!usersDb.containsKey(email)) {
        throw Exception("User not found");
      }

      final storedData = usersDb[email];
      if (storedData['password'] != password) {
        throw Exception("Invalid password");
      }

      final user = MyAppUser.fromMap(storedData['user']);
      await prefs.setString(_userKey, user.toJson());
      state = AuthState(user: user);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    state = AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
