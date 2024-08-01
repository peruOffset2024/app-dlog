import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AppState with ChangeNotifier {
  bool _isLoading = false;
  List<dynamic> _jsonDataUbi = [];

  bool get isLoading => _isLoading;
  List<dynamic> get jsonDataUbi => _jsonDataUbi;

  Future<void> fetchData() async {
    _isLoading = true;
    notifyListeners(); // Notificar a los widgets que dependen de este estado

    // Llamada a la API o base de datos para obtener los datos
    final response = await http.get(Uri.parse('https://api.example.com/data'));

    if (response.statusCode == 200) {
      _jsonDataUbi = jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener los datos');
    }

    _isLoading = false;
    notifyListeners(); // Notificar a los widgets que dependen de este estado
  }
}