import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class AuthProvider with ChangeNotifier {
  String _userId;
  String _token;
  DateTime _expiryDate;

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
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }
}
