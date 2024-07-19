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
    return ListView(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 400,
            ),

            Text('CONSULTAR EN AMP', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
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
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  VistaDetalle(barcode: value)),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 2),
                  Container(
                    height: 70,
                    width: 70,
                    child: FloatingActionButton(
                      elevation: 20,
                      backgroundColor:
                          const Color.fromARGB(255, 59, 252, 232),
                      child: const Icon(
                        Icons.qr_code,
                        size: 50,
                      ),
                      onPressed: _scanearCodigo,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
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

    // Navegar a la pantalla donde se mostrará el valor obtenido
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => VistaDetalle(barcode: barcodeScanRes),
      ),
    );
  }

}
