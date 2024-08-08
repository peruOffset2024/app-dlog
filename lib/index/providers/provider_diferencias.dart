import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataProvider with ChangeNotifier {
  List<Map<String, dynamic>> _data = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Map<String, dynamic>> get data => _data;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchData() async {
    _isLoading = true;
    notifyListeners();
    try {
      final url = 'http://190.107.181.163:81/amq/flutter_ajax_home.php';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        _data = responseData is List ? List<Map<String, dynamic>>.from(responseData) : [];
        _errorMessage = '';
      } else {
        _data = [];
        _errorMessage = 'Error: ${response.statusCode}';
      }
    } catch (e) {
      _data = [];
      _errorMessage = 'Error: $e';
    }
    _isLoading = false;
    notifyListeners();
  }
}
