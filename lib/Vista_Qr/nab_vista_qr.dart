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
    return Scaffold(
      
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: const BoxDecoration(),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('CONSULTAR EN AMP',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 194, 2, 2),
                            ),),
                            const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                  
                  SizedBox(
                    width: 500,
                    child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          
                          TextFormField(
                            autocorrect: false,
                            autofocus: false,
                            controller: _codigoSbaController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 6, 37, 63),
                                ),
                              ),
                              hintText: 'Ingrese Código SBA',
                              prefixIcon: Icon(Icons.search),
                            ),
                            style: TextStyle(
                              color: Colors.grey[800],
                              shadows: const [
                                Shadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                  color: Color.fromARGB(255, 156, 148, 148),
                                ),
                              ],
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
                  SizedBox(
                    height: 90,
                    width: 90,
                    child: FloatingActionButton(
                      onPressed: _scanearCodigo1,
                      backgroundColor: const Color.fromARGB(234, 25, 168, 173),
                      child: const Icon(
                        size: 70,
                        Icons.qr_code),
                    ),
                  ),
                ],),
                
                const SizedBox(height: 20.0),
                
              ],
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
        final url =
            'http://190.107.181.163:81/amq/flutter_ajax.php?search=$codigoSba';
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          print('el error ------- : ${response.statusCode}');
          setState(() {
            jsonData = data is List<dynamic> ? data : [];
          });
        } else {
          setState(() {
            jsonData = [];
          });
          // ignore: avoid_print
          print('Error al consumir el API');
        }
      } else {
        // ignore: avoid_print
        print('Ingrese un codigo SBA valido');
      }

      // codigo para consumir el api de la url de Ubicaciones

      // ignore: non_constant_identifier_names
      final UrlUbicaciones =
          'http://190.107.181.163:81/amq/flutter_ajax_ubi.php?search=$codigoSba';
      final responseUbicaciones = await http.get(Uri.parse(UrlUbicaciones));
      if (responseUbicaciones.statusCode == 200) {
        final dataUbi = jsonDecode(responseUbicaciones.body);
        setState(() {
          jsonDataUbi = dataUbi is List<dynamic> ? dataUbi : [];
        });
        print('el error ------- : ${responseUbicaciones.statusCode}');
        Navigator.push(
            // ignore: use_build_context_synchronously
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
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            ));
        _codigoSbaController.clear();
      } else {
        setState(() {
          jsonDataUbi = [];
        });
        // ignore: avoid_print
        print('Error al obtener datos de la ubicacion');
      }
    } catch (e) {
      setState(() {
        jsonDataUbi = [];
        jsonDataUbi = [];
      });
      // ignore: avoid_print
      print('Error: $e');
    }
  }

  Future<void> _scanearCodigo1() async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancelar', true, ScanMode.QR);
      if (barcodeScanRes != '-1') {
        final url =
            'http://190.107.181.163:81/amq/flutter_ajax.php?search=$barcodeScanRes';
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            jsonData = data is List<dynamic> ? data : [];
          });
          print('Aqui los datos del Api jsonData: $jsonData');
        } else {
          setState(() {
            jsonData = [];
          });
          // ignore: avoid_print
          print('Error al obtener datos desde el escaneo QR');
        }

        // Realizar petición GET a la ruta del API para obtener los datos de ubicación

        final urlUbi =
            'http://190.107.181.163:81/amq/flutter_ajax_ubi.php?search=$barcodeScanRes';
            
        final responseUbi = await http.get(Uri.parse(urlUbi));
        if (responseUbi.statusCode == 200) {
          final dataUbi = jsonDecode(responseUbi.body);
          setState(() {
            jsonDataUbi = dataUbi is List<dynamic> ? dataUbi : [];
          });
          print('Aqui los datos del Api jsonDataUBI: $jsonDataUbi');
          print('Aqui los datos barcodeScanRes: $barcodeScanRes');

          bool? hasVibrator = await Vibration.hasVibrator();
          if (hasVibrator == true) {
            Vibration.vibrate();
          }
          Navigator.push(
            // ignore: use_build_context_synchronously
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
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
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
          print('Aqui los datos barcodeScanRes: $barcodeScanRes');
        } else {
          setState(() {
            jsonDataUbi = [];
          });
          // ignore: avoid_print
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
