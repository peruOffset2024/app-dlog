import 'dart:convert';
import 'package:app_dlog/index/providers/appprovider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class TablaUbicacion extends StatefulWidget {
  final List<dynamic> jsonData;
  final List<dynamic> jsonDataUbi;
  final VoidCallback onItemPressed2;


  const TablaUbicacion({
    super.key,
    required this.jsonData,
    required this.jsonDataUbi, required this.onItemPressed2,
  });

  @override
  State<TablaUbicacion> createState() => _TablaUbicacionState();
}

class _TablaUbicacionState extends State<TablaUbicacion> {
  late AppProvider _appProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appProvider = Provider.of<AppProvider>(context, listen: false);
  }

  Future<void> _eliminarDataPorId(BuildContext context, int ids, String nombre) async {
    try {
      final url = 'http://190.107.181.163:81/amq/flutter_ajax_ubi_delete.php?id_ubi=$ids&usuario=$nombre';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        _appProvider.removeDataById(ids);
        print('Estado actualizado correctamente de la clase');
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _alertMensaje(BuildContext context, int ids, String nombre) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ALERTA'),
          content: const Text(
            '¿ESTÁS SEGURO QUE DESEAS BORRAR?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _eliminarDataPorId(context, ids, nombre);
                Navigator.of(context).pop();
              },
              child: const Text('SI'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('NO'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double tableWidth = size.width * 0.9; // Ancho de la tabla ajustado al 90% del ancho de la pantalla
    final double fontSize = size.width > 600 ? 14 : 12; // Tamaño de fuente según el ancho de pantalla

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
              'ALMACEN DE PRODUCTOS TERMINADO',
              'ALMACEN PROVEEDOR',
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

    // ignore: unused_local_variable
    double diferencia = totalCantidadAlmacen - totalCantidadUbicaciones;
    final appProvider = Provider.of<AppProvider>(context);

    return GestureDetector(
      onTap: widget.onItemPressed2,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: EdgeInsets.all(size.width > 600 ? 20.0 : 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (appProvider.jsonData.isNotEmpty) ...[
                SizedBox(
                  width: tableWidth,
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'STOCK FISICO',
                        style: TextStyle(
                          fontSize: size.width > 600 ? 25 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 100),
                    ],
                  ),
                ),
                const SizedBox(height: 10)
              ],
              appProvider.jsonDataUbi.isNotEmpty
                  ? SizedBox(
                      width: tableWidth,
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: DataTable(
                            columnSpacing: 1.0,
                            horizontalMargin: 0.0,
                            headingRowColor: WidgetStateColor.resolveWith(
                              (states) => Colors.grey[300]!,
                            ),
                            columns: [
                              DataColumn(
                                label: Text(
                                  '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontSize,
                                  ),
                                ),
                              ),
                              
                              DataColumn(
                                label: Text(
                                  'ZONA',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontSize,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'STAND',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontSize,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'COL',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontSize,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'FIL',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontSize,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'CANT',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontSize,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'IMG',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontSize,
                                  ),
                                ),
                              ),
                            ],
                            rows: [
                              ...appProvider.jsonDataUbi.map<DataRow>((data) {
                                final ids = int.tryParse(data['id'] ?? '') ?? 0;
                                const String nombre = 'Ricardo';
      
                                final imageUrls = data['Img'] != null
                                    ? List<String>.from(
                                        jsonDecode(data['Img'] as String))
                                    : [];
      
                                return DataRow(
                                  cells: [
                                    DataCell(IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        _alertMensaje(context, ids, nombre);
                                      },
                                    )),
                                    DataCell(Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        data['Zona'] ?? 'Sin zona',
                                        style: TextStyle(fontSize: fontSize),
                                      ),
                                    )),
                                    DataCell(Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        data['Stand'] ?? 'Sin stand',
                                        style: TextStyle(fontSize: fontSize),
                                      ),
                                    )),
                                    DataCell(Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        data['col']?.toString() ?? 'Sin col',
                                        style: TextStyle(fontSize: fontSize),
                                      ),
                                    )),
                                    DataCell(Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        data['fil']?.toString() ?? 'Sin fila',
                                        style: TextStyle(fontSize: fontSize),
                                      ),
                                    )),
                                    DataCell(Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        data['Cantidad']?.toString() ?? 'Sin cantidad',
                                        style: TextStyle(fontSize: fontSize),
                                      ),
                                    )),
                                    DataCell(
                                      imageUrls.isNotEmpty
                                          ? IconButton(
                                              icon: const Icon(Icons.image),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text('Imágenes'),
                                                      content: SizedBox(
                                                        width: 400,
                                                        height: 500,
                                                        child: ListView.builder(
                                                          itemCount:
                                                              imageUrls.length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            final imageUrl =
                                                                imageUrls[index];
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Image.network(
                                                                imageUrl,
                                                                loadingBuilder:
                                                                    (context,
                                                                        child,
                                                                        loadingProgress) {
                                                                  if (loadingProgress ==
                                                                      null) {
                                                                    return child;
                                                                  } else {
                                                                    return Center(
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                        value:
                                                                            loadingProgress
                                                                                .expectedTotalBytes !=
                                                                                    null
                                                                            ? loadingProgress.cumulativeBytesLoaded /
                                                                                (loadingProgress.expectedTotalBytes ?? 1)
                                                                            : null,
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                                errorBuilder: (context,
                                                                    error, stackTrace) {
                                                                  return const Icon(
                                                                    Icons.error,
                                                                    size: 100,
                                                                  );
                                                                },
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            )
                                          : const Text(''),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const Center(child: Text('No hay datos disponibles.')),
              const SizedBox(height: 20),
              
            ],
          ),
        ),
      ),
    );
  }
}
