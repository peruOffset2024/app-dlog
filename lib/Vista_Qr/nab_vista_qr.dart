import 'dart:convert';
import 'package:app_dlog/index/nueva_vista_detalle.dart';
import 'package:app_dlog/index/vista_detalle.dart';
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
      body: ListView(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 350,
                ),
                const Text('CONSULTAR EN AMP',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 400,
                        child: TextFormField(
                          autocorrect: false,
                          autofocus: false,
                          controller: _codigoSbaController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(),
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
                      ),
                      const SizedBox(width: 2),
                      SizedBox(
                        height: 70,
                        width: 70,
                        child: FloatingActionButton(
                          elevation: 20,
                          backgroundColor:
                              const Color.fromARGB(255, 59, 252, 232),
                          onPressed: _scanearCodigo,
                          child: const Icon(
                            Icons.qr_code,
                            size: 50,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
          setState(() {
            jsonData = data is List<dynamic> ? data : [];
          });
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  NuevaVistaDetalle(jsonData: jsonData, jsonDataUbi: jsonDataUbi, codigoSba: _codigoSbaController, barcode: '',),
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
        } else{
          setState(() {
            jsonData = [];
          });
          print('Error al consumir el API');
        }
      }else{
        print('Ingrese un codigo SBA valido');
      }

      // codigo para consumir el api de la url de Ubicaciones

      final UrlUbicaciones = 'http://190.107.181.163:81/amq/flutter_ajax_ubi.php?search=$codigoSba';
      final responseUbicaciones = await http.get(Uri.parse(UrlUbicaciones));
      if(responseUbicaciones.statusCode == 200){
        final dataUbi = jsonDecode(responseUbicaciones.body);
        setState(() {
          jsonDataUbi = dataUbi is List<dynamic> ? dataUbi : [];
        });
      } else {
        setState(() {
          jsonDataUbi = [];
        });
        print('Error al obtener datos de la ubicacion');
      }
    } catch (e) {
      setState(() {
        jsonDataUbi = [];
        jsonDataUbi = [];
      });
      print('Error: $e');
    }
  }



  Future<void> _scanearCodigo() async {
    String barcodeScanRes;
    try {
      // ignore: avoid_print
      print('Iniciando escaneo...'); // Depuración
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // color del scanner
        'Cancelar', // texto del botón cancelar
        true, // mostrar flash
        ScanMode.QR, // modo de escaneo QR
      );
      // ignore: avoid_print
      print('Resultado del escaneo: $barcodeScanRes'); // Depuración
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    if (barcodeScanRes != "-1") {
      // ignore: avoid_print
      print('Código escaneado: $barcodeScanRes'); // Depuración
      bool? hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        Vibration.vibrate();
      }

      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => VistaDetalle(
            barcode: barcodeScanRes,
            codSba: barcodeScanRes, // Usar el resultado del escaneo como codSba
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
      // si se cancela, no hacer nada o mostrar un mensaje
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Escaneo Cancelado")));
    }
  }
}
