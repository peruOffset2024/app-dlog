import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:vibration/vibration.dart';

class AppProvider extends ChangeNotifier {
  List<dynamic> _jsonData = [];
  List<dynamic> _jsonDataUbi = [];

  List<dynamic> get jsonData => _jsonData;
  List<dynamic> get jsonDataUbi => _jsonDataUbi;

  Future<void> fetchData(String codigoSba) async {
  try {
    final response = await http.get(Uri.parse('http://190.107.181.163:81/amq/flutter_ajax.php?search=$codigoSba'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List;
      _jsonData = jsonData.cast<dynamic>(); // Utiliza cast para convertir la lista de objetos Map<String, dynamic> a una lista de objetos dinámicos
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
        final jsonDataUbi = json.decode(response.body) as List;
        _jsonDataUbi = jsonDataUbi.cast<dynamic>();
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
        
        print('Estado actualizado correctamente + del provider');
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> scanearCodigo1() async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancelar', true, ScanMode.QR);
      if (barcodeScanRes != '-1') {
        final url =
            'http://190.107.181.163:81/amq/flutter_ajax.php?search=$barcodeScanRes';
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
      
            _jsonData = data is List<dynamic> ? data : [];
          notifyListeners();
        } else {
       
          // ignore: avoid_print
          print('Error al obtener datos desde el escaneo QR');
        }

        // Realizar petición GET a la ruta del API para obtener los datos de ubicación
    
        final urlUbi =
            'http://190.107.181.163:81/amq/flutter_ajax_ubi.php?search=$barcodeScanRes';
        final responseUbi = await http.get(Uri.parse(urlUbi));
        if (responseUbi.statusCode == 200) {
          final dataUbi = jsonDecode(responseUbi.body);
            _jsonDataUbi = dataUbi is List<dynamic> ? dataUbi : [];
         ;
          bool? hasVibrator = await Vibration.hasVibrator();
          if (hasVibrator == true) {
            Vibration.vibrate();
          }
         notifyListeners();
          
        } else {
          print('Error al obtener datos de ubicación desde el escaneo QR');
        }
      } else {
        // ignore: avoid_print
        print('Escaneo QR cancelado');
      }
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print('Error al escanear QR: $e');
    }
  }
}
