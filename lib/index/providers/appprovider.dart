import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AppProvider extends ChangeNotifier {
  List<dynamic> _jsonData = [];
  List<dynamic> _jsonDataUbi = [];

  List<dynamic> get jsonData => _jsonData;
  List<dynamic> get jsonDataUbi => _jsonDataUbi;

  Future<void> fetchData(String codigoSba) async {
    try {
      final response = await http.get(Uri.parse('http://190.107.181.163:81/amq/flutter_ajax.php?search=$codigoSba'));
      if (response.statusCode == 200) {
        _jsonData = json.decode(response.body);
        notifyListeners();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchDataUbi(String codigoSba) async {
    try {
      final response = await http.get(Uri.parse('http://190.107.181.163:81/amq/flutter_ajax_ubi.php?search=$codigoSba'));
      if (response.statusCode == 200) {
        _jsonDataUbi = json.decode(response.body);
        notifyListeners();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e);
    }
  }

  void updateJsonData(List<dynamic> newJsonData) {
    _jsonData = newJsonData;
    notifyListeners();
  }

  void updateJsonDataUbi(List<dynamic> newJsonDataUbi) {
    _jsonDataUbi = newJsonDataUbi;
    notifyListeners();
  }

  void removeDataById(int id) {
    _jsonDataUbi.removeWhere((data) => data['id'] == id.toString());
    notifyListeners();
  }


  Future<void> eliminarDataPorId(int ids, String nombre) async {
    try {
      final url = 'http://190.107.181.163:81/amq/flutter_ajax_ubi_delete.php?id_ubi=$ids&usuario=$nombre';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        removeDataById(ids);
        print('Estado actualizado correctamente');
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
