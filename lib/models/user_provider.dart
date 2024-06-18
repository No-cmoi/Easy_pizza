// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:easy_pizza/models/user.dart';
import 'package:easy_pizza/services/api_service.dart';

class UserProvider extends ChangeNotifier {
  final ApiService _authService = ApiService();
  User? _currentUser;
  String? _accessToken;
  String? _refreshToken;

  User? get currentUser => _currentUser;

  Future<void> signUp(User user) async {
    try {
      await _authService.signUp(user.email, user.password, user.firstName, user.lastName, user.role);
      await signIn(user.email, user.password);
    } catch (e) {
      print('Sign up failed: $e');
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      _accessToken = await _authService.signIn(email, password);
      _currentUser = User.fromJson(await _authService.me(_accessToken!));
      notifyListeners();
    } catch (e) {
      print('Sign in failed: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      if (_refreshToken != null) {
        await _authService.signOut(_refreshToken!);
      }
      _currentUser = null;
      _accessToken = null;
      _refreshToken = null;
      notifyListeners();
    } catch (e) {
      print('Sign out failed: $e');
      rethrow;
    }
  }

  Future<void> refresh() async {
    try {
      if (_refreshToken != null) {
        await _authService.refresh(_refreshToken!);
        _currentUser = User.fromJson(await _authService.me(_accessToken!));
        notifyListeners();
      }
    } catch (e) {
      print('Token refresh failed: $e');
      rethrow;
    }
  }

  Future<void> fetchUserData() async {
    try {
      if (_accessToken != null) {
        _currentUser = User.fromJson(await _authService.me(_accessToken!));
        notifyListeners();
      }
    } catch (e) {
      print('Failed to get user data: $e');
      rethrow;
    }
  }
}
