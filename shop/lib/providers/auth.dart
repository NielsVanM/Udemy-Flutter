import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shop/constants.dart';

class Auth extends ChangeNotifier {
  String _token;
  DateTime _expiry;
  String _id;

  Timer _authTimer;

  String get token {
    return _token;
  }

  String get userID {
    return _id;
  }

  bool get isAuthenticated {
    return _token != null && _expiry != null && _expiry.isAfter(DateTime.now());
  }

  Future<void> _sendAuthRequest(Uri uri, String email, String password) async {
    // try {
    var res = await http.post(uri,
        body: json.encode({
          "email": email,
          "password": password,
          "returnSecureToken": true,
        }));

    var data = json.decode(res.body) as Map<String, dynamic>;

    if (data.containsKey("error")) {
      throw Exception(data['error']['message']);
    }

    _id = data['localId'];
    _token = data['idToken'];
    _expiry =
        DateTime.now().add(Duration(seconds: int.parse(data['expiresIn'])));

    String authData = json.encode({
      "id": _id,
      "token": _token,
      "expiry": _expiry.toIso8601String(),
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("userData", authData);

    // autoLogout();
    notifyListeners();
  }

  Future<void> signup(String email, String password) async {
    Uri url = Uri.parse(GOOGLE_AUTHENTICATION_URL +
        "signUp?key=$GOOGLE_AUTHENTICATION_API_KEY");

    return _sendAuthRequest(url, email, password);
  }

  Future<void> signin(String email, String password) async {
    Uri url = Uri.parse(GOOGLE_AUTHENTICATION_URL +
        "signInWithPassword?key=$GOOGLE_AUTHENTICATION_API_KEY");

    return _sendAuthRequest(url, email, password);
  }

  Future<bool> tryAutoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey("userData")) {
      return false;
    }

    Map<String, dynamic> userData = json.decode(prefs.getString("userData"));
    DateTime expiryDate = DateTime.parse(userData['expiry']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _id = userData["id"];
    _token = userData["token"];
    _expiry = DateTime.parse(userData["expiry"]);

    notifyListeners();
    return true;
  }

  void logout() async {
    _token = null;
    _id = null;
    _expiry = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }

  void autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    _authTimer = Timer(
      Duration(seconds: _expiry.difference(DateTime.now()).inSeconds),
      () => logout,
    );
  }
}
