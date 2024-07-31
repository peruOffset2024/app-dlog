import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TablaUbicacion extends StatefulWidget {
  final String codigoSba;
  final List<dynamic> jsonData;
  final List<dynamic> jsonDataUbi;

  TablaUbicacion({
    Key? key,
    required this.jsonData,
    required this.jsonDataUbi,
    required this.codigoSba,
    required List resultados,
  }) : super(key: key);

  @override
  State<TablaUbicacion> createState() => _TablaUbicacionState();
}

class _TablaUbicacionState extends State<TablaUbicacion> {
  final TextEditingController _ubicacionController = TextEditingController();
  final TextEditingController _zonaController = TextEditingController();
  final TextEditingController _standController = TextEditingController();
  final TextEditingController _colController = TextEditingController();
  final TextEditingController _filController = TextEditingController();
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _imgController = TextEditingController();

  @override
  void dispose() {
    _ubicacionController.dispose();
    _zonaController.dispose();
    _standController.dispose();
    _colController.dispose();
    _filController.dispose();
    _usuarioController.dispose();
    _cantidadController.dispose();
    _imgController.dispose();
    super.dispose();
  }

  void _clearTextControllers() {
    _ubicacionController.clear();
    _zonaController.clear();
    _standController.clear();
    _colController.clear();
    _filController.clear();
    _cantidadController.clear();
    _usuarioController.clear();
    _imgController.clear();
  }

  Future<void> _actualizarData(Map<String, dynamic> ubicacion) async {
    try {
      final url = 'http://190.107.181.163:81/amq/flutter_ajax_edit.php';

      final response = await http.put(Uri.parse(url), body: {
        'id': ubicacion['id'] ?? '',
        'usuario': ubicacion['usuario'] ?? '',
        'Ubicacion': ubicacion['Ubicacion'] ?? '',
        'Zona': ubicacion['Zona'] ?? '',
        'Stand': ubicacion['Stand'] ?? '',
        'col': ubicacion['col'] ?? '',
        'fil': ubicacion['fil'] ?? '',
        'Cantidad': ubicacion['Cantidad'] ?? '',
        'Img': ubicacion['Img'] ?? '',
      });

      if (response.statusCode == 200) {
        setState(() {
          final index = widget.jsonDataUbi
              .indexWhere((element) => element['id'] == ubicacion['id']);
          if (index != -1) {
            widget.jsonDataUbi[index] = ubicacion;
            _clearTextControllers();
          }
        });
      } else {
        print(
            'Error al actualizar la ubicación. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> enviarData() async {
    try {
      final sbaCodigoUbi = widget.codigoSba;
      final url = 'http://190.107.181.163:81/amq/flutter_ajax_add.php';

      final response = await http.post(Uri.parse(url), body: {
        'search': sbaCodigoUbi,
        'ubicacion': _ubicacionController.text,
        'zona': _zonaController.text,
        'stand': _standController.text,
        'col': _colController.text,
        'fil': _filController.text,
        'cantidad': _cantidadController.text,
        'usuario': _usuarioController.text,
        'img': _imgController.text,
      });

      if (response.statusCode == 200) {
        final newData = {
          'Ubicacion': _ubicacionController.text,
          'Zona': _zonaController.text,
          'Stand': _standController.text,
          'col': _colController.text,
          'fil': _filController.text,
          'Cantidad': _cantidadController.text,
          'usuario': _usuarioController.text,
          'Img': _imgController.text,
        };
        setState(() {
          widget.jsonDataUbi.add(newData);
          _clearTextControllers();
        });
      } else {
        print(
            'Error al enviar datos a la API. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _eliminarData(int index) {
    setState(() {
      widget.jsonDataUbi.removeAt(index);
    });
  }

  Future<dynamic> _alertMensaje(BuildContext context, int index) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ALERTA'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '¿ESTAS SEGURO QUE DESEAS BORRAR?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _eliminarData(index);
                    Navigator.pop(context);
                  },
                  child: const Text('SI'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('NO'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalCantidadUbicaciones = 0.0;

    for (var data in widget.jsonDataUbi) {
      if (data['Cantidad'] != null && data['Cantidad'] is num) {
        totalCantidadUbicaciones += data['Cantidad'];
      } else if (data['Cantidad'] != null && data['Cantidad'] is String) {
        totalCantidadUbicaciones += double.tryParse(data['Cantidad']) ?? 0.0;
      }
    }

    double totalCantidadAlmacen = 0.0;
    widget.jsonData
        .where((data) => ![
              'ALMACEN DE FALTANTES',
              'ALMACEN DE PRODUCTOS TERMINADO'
            ].contains(data['Name']))
        .forEach((data) {
      double stockValue = 0.0;
      if (data['Stock'] != null) {
        if (data['Stock'] is num) {
          stockValue = (data['Stock'] as num).toDouble();
        } else if (data['Stock'] is String) {
          stockValue = double.tryParse(data['Stock']) ?? 0.0;
        }
      }
      totalCantidadAlmacen += stockValue;
    });

    double diferencia = totalCantidadAlmacen - totalCantidadUbicaciones;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.jsonData.isNotEmpty) ...[
              Container(
                width: 600,
                height: 60,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'STOCK FISICO',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 100),
                  ],
                ),
              ),
              SizedBox(height: 10)
            ],
            widget.jsonDataUbi.isNotEmpty
                ? Container(
                    width: 700,
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: DataTable(
                          columnSpacing: 10.0,
                          horizontalMargin: 20.0,
                          headingRowColor: MaterialStateColor.resolveWith(
                            (states) => Colors.grey[300]!,
                          ),
                          columns: const [
                            DataColumn(
                              label: Text(
                                '      -',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'ZONA',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'STAND',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'COL',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'FILA',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'CANTIDAD',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'IMG',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                          rows: [
                            ...widget.jsonDataUbi.map<DataRow>((data) {
                              final index = widget.jsonDataUbi.indexOf(data);
                              return DataRow(
                                cells: [
                                  DataCell(IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      _alertMensaje(context, index);
                                    },
                                  )),
                                  DataCell(Container(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      data['Zona'] ?? 'Sin zona',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  )),
                                  DataCell(Container(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      data['Stand'] ?? 'Sin stand',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  )),
                                  DataCell(Container(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      data['col']?.toString() ?? 'Sin col',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  )),
                                  DataCell(Container(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      data['fil']?.toString() ?? 'Sin fila',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  )),
                                  DataCell(Container(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      data['Cantidad']?.toString() ??
                                          'Sin cantidad',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  )),
                                  DataCell(IconButton(
                                    icon: Icon(Icons.image),
                                    onPressed: () {
                                      // Obtener la URL de las imágenes desde jsonDataUbi
                                      final imageUrls = data['Img'] as String?;
                                        print(imageUrls);
                                      // Separar las URLs por comas (o el delimitador que estés usando)
                                      final imageUrlList =
                                          imageUrls?.split(',') ?? [];

                                      // Mostrar las imágenes en un dialog
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Imágenes'),
                                            content: Container(
                                              width: double.maxFinite,
                                              child: ListView.builder(
                                                itemCount: imageUrlList.length,
                                                itemBuilder: (context, index) {
                                                  final url =
                                                      imageUrlList[index]
                                                          .trim();
                                                  // Verificar que la URL no esté vacía y sea válida
                                                  if (url.isNotEmpty &&
                                                      (url.startsWith(
                                                              'http://') ||
                                                          url.startsWith(
                                                              'https://'))) {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 4.0),
                                                      child: Card(
                                                        child: Image.network(
                                                            url,
                                                            fit: BoxFit.cover),
                                                      ),
                                                    );
                                                  } else {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 4.0),
                                                      child: Card(
                                                        child: Center(
                                                            child: Text(
                                                                '$imageUrls')),
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                child: Text('Cerrar'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  )),
                                ],
                              );
                            }).toList(),
                            DataRow(
                              cells: [
                                DataCell(Container(
                                  padding: const EdgeInsets.all(8),
                                  child: const Text(
                                    '',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                )),
                                DataCell(Container(
                                  padding: EdgeInsets.all(8),
                                  child: const Text(
                                    'TOTAL',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.blue,
                                    ),
                                  ),
                                )),
                                DataCell(Container(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    '',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                )),
                                DataCell(Container(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    '',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                )),
                                DataCell(Container(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    '',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                )),
                                DataCell(Container(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    totalCantidadUbicaciones.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.blue,
                                    ),
                                  ),
                                )),
                                DataCell(Container(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    '',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : const Center(child: Text('')),
            SizedBox(height: 20),
            if (widget.jsonData.isNotEmpty) ...[
              _buildDiferencias(
                  totalCantidadAlmacen, totalCantidadUbicaciones, diferencia),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDiferencias(double totalCantidadAlmacen,
      double totalCantidadUbicaciones, double diferencia) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'DIFERENCIAS',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 700,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: 160,
                    height: 60,
                    child: Center(
                      child: Text(
                        ' Total stock sistema:  \n $totalCantidadAlmacen', // text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: 160,
                    height: 60,
                    child: Center(
                      child: Text(
                        ' Total stock fisico: \n $totalCantidadUbicaciones', // text,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: 160,
                    height: 60,
                    child: Center(
                      child: Text(
                        'Diferencia : \n $diferencia', // text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> obtenerImagenes() async {
    final url = 'http://190.107.181.163:81/amq/uploads/';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Procesar la respuesta
      final jsonData = jsonDecode(response.body);
      // jsonData es un objeto que contiene la lista de imágenes
      print(jsonData);
    } else {
      print('Error al obtener las imágenes: ${response.statusCode}');
    }
  }
}
