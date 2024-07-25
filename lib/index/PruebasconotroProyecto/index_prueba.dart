
/*import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


class IndexPag extends StatefulWidget {
  const IndexPag({Key? key}) : super(key: key);

  @override
  State<IndexPag> createState() => _IndexPagState();
}

class _IndexPagState extends State<IndexPag> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _codigoSbaController = TextEditingController();
  List<dynamic> jsonData = [];
  List<dynamic> jsonDataUbi = [];

  double _left = 0;
  double _top = 0;

  double _arriba = 0;
  double _abajo = 0;

  @override
  void initState() {
    super.initState();
    // enfoque del teclado
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _focusNode.unfocus();
      }
    });
    // Initialize _left and _top based on the screen size
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      final screenArriba = MediaQuery.of(context).size.width;
      final screenAbajo = MediaQuery.of(context).size.height;
      setState(() {
        _left =
            screenWidth - 110; // Adjust this value to fine-tune the position
        _top = (screenHeight / 2) - 45; // Center vertically
        _arriba =
            screenArriba - 110; // Adjust this value to fine-tune the position
        _abajo = (screenAbajo / 2) - 348;
      });
    });
  }

  void _navigateToNewScreen() {
    String codigoSba = _codigoSbaController.text;
    if (codigoSba.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VerUbicacion(
                  codigoSba: codigoSba,
                )),
      );
    }
  }

  void _irAlLayout() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LayoutAmp()),
    );
  }

  void _navigateToOtraPagina() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtraPagina(
          jsonData: jsonData,
          jsonDataUbi: jsonDataUbi,
          codigoSba: _codigoSbaController,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      drawer: DrawerIndex(),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 80,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 400,
                      child: TextFormField(
                        autocorrect: false,
                        autofocus: false,
                        controller: _codigoSbaController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              //borderSide: BorderSide(color: Colors.grey),
                              //borderRadius: BorderRadius.circular(10),
                              ),
                          //focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      
                          hintText: 'Ingrese Código SBA',
                          prefixIcon: const Icon(Icons.search),
                        ),
                        style: TextStyle(
                          color: Colors.grey[800], // Color del texto
                          shadows: [
                            Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 2,
                              color: const Color.fromARGB(
                                  255, 156, 148, 148), // Color de la sombra
                            ),
                          ],
                        ),
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          _obtenerDatos();
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    const SizedBox(width: 270),
                    Container(
                      height: 70,
                      width: 70,
                      child: FloatingActionButton(
                          elevation: 20,
                          backgroundColor: Color.fromARGB(255, 59, 252, 232),
                          child: const Icon(
                            Icons.qr_code,
                            size: 50,
                          ),
                          onPressed: () => _scanearCodigo()),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _navigateToOtraPagina,
                child: Text('Ir a Otra Página'),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _obtenerDatos,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TablaAlmacen(
                          jsonData: jsonData,
                          resultados: jsonData,
                          jsonDataUbi: jsonDataUbi,
                        ),
                        TablaUbicacion(
                          jsonData: jsonData,
                          jsonDataUbi: jsonDataUbi,
                          resultados: [],
                          onInsertarUbicacion: _insertarUbicacion,
                          onActualizarUbicacion: _actualizarUbicacion,
                          onEliminarUbicacion: (String id) {},
                          codigoSba: _codigoSbaController,
                        ),
                        
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_left != 0 && _top != 0)
            Positioned(
              left: _left,
              top: _top,
              child: Draggable(
                feedback: _buildChatHead(),
                child: _buildChatHead(),
                childWhenDragging: Container(),
                onDragEnd: (details) {
                  setState(() {
                    double newLeft = details.offset.dx;
                    double newTop = details.offset.dy;
      
                    // Ensure the button stays within the screen bounds
                    if (newLeft < 0) newLeft = 0;
                    if (newTop < 0) newTop = 0;
                    if (newLeft > MediaQuery.of(context).size.width - 56) {
                      newLeft = MediaQuery.of(context).size.width - 56;
                    }
                    if (newTop > MediaQuery.of(context).size.height - 56) {
                      newTop = MediaQuery.of(context).size.height - 56;
                    }
      
                    _left = newLeft;
                    _top = newTop;
                  });
                },
              ),
            ),
          if (_arriba != 0 && _abajo != 0)
            Positioned(
              left: _arriba,
              top: _abajo,
              child: Draggable(
                feedback: _botonLayout(),
                child: _botonLayout(),
                childWhenDragging: Container(),
                onDragEnd: (details) {
                  setState(() {
                    double arriba = details.offset.dx;
                    double abajo = details.offset.dy;
      
                    // Ensure the button stays within the screen bounds
                    if (arriba < 0) arriba = 0;
                    if (abajo < 0) abajo = 0;
                    if (arriba > MediaQuery.of(context).size.width - 56) {
                      arriba = MediaQuery.of(context).size.width - 56;
                    }
                    if (abajo > MediaQuery.of(context).size.height - 56) {
                      abajo = MediaQuery.of(context).size.height - 56;
                    }
      
                    _arriba = arriba;
                    _abajo = abajo;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChatHead() {
    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        onTap: _navigateToNewScreen,
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color.fromARGB(255, 199, 211, 221),
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Icon(size: 50, Icons.edit),
        ),
      ),
    );
  }

  Widget _botonLayout() {
    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        onTap: () {
          _mostrarFirmaDialog(context);
        },
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color.fromARGB(255, 199, 211, 221),
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Icon(Icons.layers_outlined),
        ),
      ),
    );
  }

  void _mostrarFirmaDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final signatureProvider = Provider.of<SignatureProvider>(context);

        return AlertDialog(
          title: Text('Anotaciones'),
          iconColor: Colors.amber,
          content: Container(
            width: 800,
            height: 1200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color.fromARGB(255, 3, 38, 41)),
                  ),
                  child: Signature(
                    controller: signatureProvider.controller,
                    height: 800,
                    width: 700,
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                SizedBox(height: 20),
                MaterialButton(onPressed: () {
                    signatureProvider.clearSignature();
                  }, child: Image.asset('assets/eraser.png',
                  
                  width: 70,
                  height: 70,), ),
                
              ],
            ), 
          ),
          actions: [
            ElevatedButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _obtenerDatos() async {
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
        } else {
          setState(() {
            jsonData = [];
          });
          print('Error al consumir la API');
        }
      } else {
        print('Ingrese un código SBA válido');
      }

      // Realizar petición GET a la ruta del API para obtener los datos de ubicación
      final urlUbi =
          'http://190.107.181.163:81/amq/flutter_ajax_ubi.php?search=$codigoSba';
      final responseUbi = await http.get(Uri.parse(urlUbi));
      if (responseUbi.statusCode == 200) {
        final dataUbi = jsonDecode(responseUbi.body);
        setState(() {
          jsonDataUbi = dataUbi is List<dynamic> ? dataUbi : [];
        });
      } else {
        setState(() {
          jsonDataUbi = [];
        });
        print('Error al obtener datos de ubicación');
      }
    } catch (e) {
      setState(() {
        jsonData = [];
        jsonDataUbi = [];
      });
      print('Error: $e');
    }
  }

  Future<void> _scanearCodigo() async {
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
           // Navigator.push(context, MaterialPageRoute(builder: (context)=> OtraPagina(codigoSba: _codigoSbaController, jsonData: jsonData, jsonDataUbi: jsonDataUbi,)));
          });
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

  Future<void> _insertarUbicacion(String zona, String stand, String col,
      String fila, String cantidad) async {
    try {
      final inputRecibido = _codigoSbaController.text;
      if (inputRecibido.isNotEmpty) {
        final url =
            'http://192.168.1.46:81/amq/flutter_ajax_add.php?=$inputRecibido'; // URL de tu endpoint para insertar datos
        final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'Zona': zona,
            'Stand': stand,
            'col': col,
            'fil': fila,
            'Cantidad': cantidad,
          }),
        );

        // Agregar la respuesta del servidor
        if (response.statusCode == 200) {
          final responseBody = jsonDecode(response.body);
          if (responseBody['success']) {
            setState(() {
              jsonDataUbi.add({
                'Zona': zona,
                'Stand': stand,
                'col': col,
                'fil': fila,
                'Cantidad': cantidad,
              });
            });
            print('Ubicación insertada correctamente');
          } else {
            print('Error al insertar ubicación: ${responseBody['message']}');
          }
        } else {
          print('Error al insertar ubicación: ${response.statusCode}');
        }
      } else {
        print('Ingrese un código SBA válido');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _actualizarUbicacion(String id, String zona, String stand,
      String col, String fila, String cantidad) async {
    try {
      final inputRecibido = _codigoSbaController.text;
      final url =
          'http://192.168.1.46:81/amq/flutter_ajax_add.php?=$inputRecibido'; // URL de tu endpoint para actualizar datos
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'Zona': zona,
          'Stand': stand,
          'col': col,
          'fil': fila,
          'Cantidad': cantidad,
        }),
      );
      if (response.statusCode == 200) {
        // Actualizar la lista localmente después de una actualización exitosa
        setState(() {
          final index = jsonDataUbi
              .indexWhere((ubicacion) => ubicacion['id'].toString() == id);
          if (index != -1) {
            jsonDataUbi[index] = {
              'id': id,
              'Zona': zona,
              'Stand': stand,
              'col': col,
              'fil': fila,
              'Cantidad': cantidad,
            };
          }
        });
      } else {
        print('Error al actualizar ubicación');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Map<String, int> _calcularDiferencias() {
    Map<String, int> diferencias = {};

    for (var almacen in jsonData) {
      if (almacen['Name'] != 'ALMACEN DE FALTANTES') {
        String almacenName = almacen['Name'];
        int almacenStock = int.tryParse(almacen['Stock'].toString()) ?? 0;
        int totalUbicacionStock = jsonDataUbi
            .where((ubicacion) => ubicacion['Zona'] == almacenName)
            .fold(
                0,
                (sum, ubicacion) =>
                    sum + (int.tryParse(ubicacion['Cantidad']) ?? 0));

        int diferencia = almacenStock - totalUbicacionStock;
        diferencias[almacenName] = diferencia;
      }
    }

    return diferencias;
  }
}
*/