import 'dart:convert';
import 'package:app_dlog/index/nueva_vista_detalle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:vibration/vibration.dart';
import 'package:http/http.dart' as http;

class IndexPagQr extends StatefulWidget {
  const IndexPagQr({super.key});

  @override
  State<IndexPagQr> createState() => _IndexPagQrState();
}

class _IndexPagQrState extends State<IndexPagQr> {
  final TextEditingController _codigoSbaController = TextEditingController();

  List<dynamic> jsonData = [];
  List<dynamic> jsonDataUbi = [];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 241, 240, 236),
              Color.fromARGB(255, 212, 186, 160),
            ],
          ),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(screenWidth * 0.05), // Padding adaptable
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'CONSULTAR EN AMP',
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03), // Espaciado adaptable
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        flex: 3,
                        child: SizedBox(
                          width: screenWidth * 0.75, // Ancho adaptable
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 8.0,
                            child: Padding(
                              padding: EdgeInsets.all(screenWidth * 0.04), // Padding adaptable
                              child: Column(
                                children: [
                                  TextFormField(
                                    autocorrect: false,
                                    autofocus: false,
                                    controller: _codigoSbaController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue.shade300,
                                          width: 2.0,
                                        ),
                                      ),
                                      hintText: 'Ingrese Código SBA',
                                      prefixIcon: Icon(Icons.search, color: Colors.blue.shade300),
                                    ),
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                    onFieldSubmitted: (value) {
                                      _obtenerDatosApi();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: SizedBox(
                          height: screenWidth * 0.2, // Tamaño adaptable basado en el ancho de la pantalla
                          width: screenWidth * 0.2, // Tamaño adaptable basado en el ancho de la pantalla
                          child: FloatingActionButton(
                            onPressed: _scanearCodigo1,
                            backgroundColor: const Color.fromARGB(234, 25, 168, 173),
                            child: const Icon(
                              Icons.qr_code,
                              size: 40, // Tamaño adaptable
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03), // Espaciado adaptable
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _obtenerDatosApi() async {
    try {
      final codigoSba = _codigoSbaController.text;
      if (codigoSba.isNotEmpty) {
        final url = 'http://190.107.181.163:81/amq/flutter_ajax.php?search=$codigoSba';
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            jsonData = data is List<dynamic> ? data : [];
          });
        } else {
          setState(() {
            jsonData = [];
          });
          print('Error al consumir el API');
        }
      } else {
        print('Ingrese un codigo SBA valido');
      }

      final UrlUbicaciones = 'http://190.107.181.163:81/amq/flutter_ajax_ubi.php?search=$codigoSba';
      final responseUbicaciones = await http.get(Uri.parse(UrlUbicaciones));
      if (responseUbicaciones.statusCode == 200) {
        final dataUbi = jsonDecode(responseUbicaciones.body);
        setState(() {
          jsonDataUbi = dataUbi is List<dynamic> ? dataUbi : [];
        });
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
              NuevaVistaDetalle(
                jsonData: const [],
                jsonDataUbi: const [],
                codigoSba: codigoSba,
                barcode: '',
              ),
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        );
        print('codigosba que se envia $codigoSba');
        _codigoSbaController.clear();
      } else {
        setState(() {
          jsonDataUbi = [];
        });
        print('Error al obtener datos de la ubicacion');
      }
    } catch (e) {
      setState(() {
        jsonDataUbi = [];
      });
      print('Error: $e');
    }
  }

  Future<void> _scanearCodigo1() async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancelar', true, ScanMode.QR);
      if (barcodeScanRes != '-1') {
        final url = 'http://190.107.181.163:81/amq/flutter_ajax.php?search=$barcodeScanRes';
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            jsonData = data is List<dynamic> ? data : [];
          });
        } else {
          setState(() {
            jsonData = [];
          });
          print('Error al obtener datos desde el escaneo QR');
        }

        final urlUbi = 'http://190.107.181.163:81/amq/flutter_ajax_ubi.php?search=$barcodeScanRes';
        final responseUbi = await http.get(Uri.parse(urlUbi));
        if (responseUbi.statusCode == 200) {
          final dataUbi = jsonDecode(responseUbi.body);
          setState(() {
            jsonDataUbi = dataUbi is List<dynamic> ? dataUbi : [];
          });

          bool? hasVibrator = await Vibration.hasVibrator();
          if (hasVibrator == true) {
            Vibration.vibrate();
          }
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                NuevaVistaDetalle(
                  jsonData: const [],
                  jsonDataUbi: const [],
                  codigoSba: barcodeScanRes,
                  barcode: barcodeScanRes,
                ),
              transitionDuration: const Duration(milliseconds: 500),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            ),
          );
        } else {
          setState(() {
            jsonDataUbi = [];
          });
          print('Error al obtener datos de ubicación desde el escaneo QR');
        }
      } else {
        print('Escaneo QR cancelado');
      }
    } on PlatformException catch (e) {
      print('Error al escanear QR: $e');
    }
  }
}
