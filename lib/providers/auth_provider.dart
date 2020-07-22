import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class AuthProvider with ChangeNotifier {
  String _userId;
  String _token;
  DateTime _expiryDate;
  Timer _authTimer;

  String get getToken {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  bool get isLoggedIn {
    return getToken != null;
  }

  String get getUserId {
    return _userId;
  }

  Future<void> signup(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyA9pMtUc32NqoBTv34Tynz6k2LzrRV5ttE';

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      final body = jsonDecode(response.body);

      if (body['error'] != null) {
        throw HttpException(body['error']['message']);
      }
    } catch (err) {
      throw err;
    }
  }

  Future<void> login(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyA9pMtUc32NqoBTv34Tynz6k2LzrRV5ttE';

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      final body = jsonDecode(response.body);

      if (body['error'] != null) {
        throw HttpException(body['error']['message']);
      }

      _token = body['idToken'];
      _userId = body['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(body['expiresIn']),
        ),
      );
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final authData = jsonEncode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('authData', authData);
    } catch (err) {
      throw err;
    }
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('authData')) {
      return false;
    }

    final authData =
        jsonDecode(prefs.getString('authData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(authData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = authData['token'];
    _userId = authData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToSessionExpiry =
        _expiryDate.difference(DateTime.now()).inSeconds;
    Timer(Duration(seconds: timeToSessionExpiry), () => logout);
  }
}
