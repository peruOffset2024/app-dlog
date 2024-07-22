import 'package:app_dlog/index/vista_detalle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class IndexPagQr extends StatefulWidget {
  const IndexPagQr({super.key});

  @override
  State<IndexPagQr> createState() => _IndexPagQrState();
}

class _IndexPagQrState extends State<IndexPagQr> {
  final TextEditingController _codigoSbaController = TextEditingController();

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
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        VistaDetalle(
                                  barcode: _codigoSbaController.text,
                                  codSba: _codigoSbaController.text,
                                ),
                                transitionDuration:
                                    const Duration(milliseconds: 500),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(1.0, 0.0),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  );
                                },
                              ),
                            ).then((_) => Navigator.pop(context));
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

  Future<void> _scanearCodigo() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // color del scanner
        'Cancelar', // texto del botón cancelar
        true, // mostrar flash
        ScanMode.QR, // modo de escaneo QR
      );
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;
    if (barcodeScanRes != "-1") {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => VistaDetalle(
            barcode: barcodeScanRes,
            codSba: _codigoSbaController.text,
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

    // Navegar a la pantalla donde se mostrará el valor obtenido
  }
}
