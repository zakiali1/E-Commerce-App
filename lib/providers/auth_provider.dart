import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  bool _isAuthenticated = false;

  UserModel? get user => _user;
  bool get isAuthenticated => _isAuthenticated;

  AuthProvider() {
    _loadUserFromStorage();
  }

  Future<bool> login(String usernameOrEmail, String password) async {
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate API delay
    _user = UserModel(
      id: 'usr_9981',
      name: usernameOrEmail.split('@')[0].toUpperCase(),
      email: usernameOrEmail.contains('@') ? usernameOrEmail : '$usernameOrEmail@email.com',
      phone: '+234 802 345 6789',
      address: '742 Evergreen Terrace, Victoria Island, Lagos',
    );
    _isAuthenticated = true;
    await _saveUserToStorage();
    notifyListeners();
    return true;
  }

  Future<bool> signup(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _user = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      phone: '+234 800 000 0000',
      address: '123 Innovation Way, Lagos',
    );
    _isAuthenticated = true;
    await _saveUserToStorage();
    notifyListeners();
    return true;
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? avatarUrl,
  }) async {
    if (_user != null) {
      _user = _user!.copyWith(
        name: name,
        email: email,
        phone: phone,
        address: address,
        avatarUrl: avatarUrl,
      );
      await _saveUserToStorage();
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _user = null;
    _isAuthenticated = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_profile_data');
    notifyListeners();
  }

  Future<void> _saveUserToStorage() async {
    if (_user == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_profile_data', json.encode(_user!.toJson()));
    } catch (e) {
      debugPrint('Error saving user: $e');
    }
  }

  Future<void> _loadUserFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userStr = prefs.getString('user_profile_data');
      if (userStr != null && userStr.isNotEmpty) {
        _user = UserModel.fromJson(json.decode(userStr));
        _isAuthenticated = true;
      } else {
        // Default demo user so app is instantly interactive
        _user = UserModel(
          id: 'usr_demo',
          name: 'John Doe',
          email: 'john.doe@email.com',
          phone: '+234 800 123 4567',
          address: '123 Commercial Avenue, Yaba, Lagos',
        );
        _isAuthenticated = true;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading user: $e');
    }
  }
}
