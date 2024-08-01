import 'package:flutter/material.dart';

class UbicacionModel with ChangeNotifier {
  List<dynamic> _ubicaciones = [];
  List<dynamic> get ubicaciones => _ubicaciones;

  void setUbicaciones(List<dynamic> nuevasUbicaciones) {
    _ubicaciones = nuevasUbicaciones;
    notifyListeners();
  }
}
