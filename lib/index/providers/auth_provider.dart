import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String _usuario = '';

  bool get isAuthenticated => _isAuthenticated;
  String get usuario => _usuario;

  Future<void> login(String username, String password) async {
    final url = Uri.parse('http://190.107.181.163:81/amq/flutter_ajax_token.php?uss=$username&pass=$password');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData['valid']) {
        _isAuthenticated = true;
        _usuario = responseData['usuario'];
        notifyListeners();
      } else {
        _isAuthenticated = false;
        _usuario = '';
        notifyListeners();
        throw Exception(responseData['message'] ?? 'Authentication failed');
      }
    } else {
      _isAuthenticated = false;
      _usuario = '';
      notifyListeners();
      throw Exception('Failed to authenticate');
    }
  }

  void logout() {
    _isAuthenticated = false;
    _usuario = '';
    notifyListeners();
  }
}
