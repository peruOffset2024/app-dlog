import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_dlog/index/providers/appprovider.dart';

class TablaAlmacen extends StatefulWidget {
  final List<dynamic> jsonData;
  final String codigoSba;
  final String barcode;
  final VoidCallback onItemPressed;

  const TablaAlmacen({
    super.key,
    required this.jsonData,
    required List resultados,
    required List jsonDataUbi, required this.codigoSba, required this.barcode, required this.onItemPressed,
  });

  @override
  State<TablaAlmacen> createState() => _TablaAlmacenState();
}

class _TablaAlmacenState extends State<TablaAlmacen> {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double containerWidth = size.width * 0.9; // Ancho de los contenedores ajustado al 90% del ancho de la pantalla
    final double fontSizeTitle = size.width > 600 ? 20 : 18; // Tamaño de fuente para el título
    final double fontSizeContent = size.width > 600 ? 16 : 14; // Tamaño de fuente para el contenido
    final double columnSpacing = size.width > 600 ? 150.0 : 100.0; // Espaciado entre columnas

    // Lista de almacenes que deben considerarse para la suma
    const almacenesConsiderados = [
      'ALMACEN DE RESERVA',
      'ALMACEN HUACHIPA',
      'ALMACEN CUARENTENA',
      'ALMACEN DE REPUESTOS (2018)'
    ];

    // Calcula el total de cantidades de los almacenes específicos
    double totalCantidad = 0.0;

    widget.jsonData
        .where((data) => !['ALMACEN DE FALTANTES', 'ALMACEN PROVEEDOR'].contains(data['Name']))
        .forEach((data) {
      double stockValue = 0.0;
      if (data['Stock'] != null) {
        if (data['Stock'] is num) {
          stockValue = (data['Stock'] as num).toDouble();
        } else if (data['Stock'] is String) {
          stockValue = double.tryParse(data['Stock']) ?? 0.0;
        }
      }
      totalCantidad += stockValue;
    });
    final appProvider = Provider.of<AppProvider>(context);

    return GestureDetector(
      onTap: widget.onItemPressed,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: EdgeInsets.all(size.width > 600 ? 20.0 : 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (appProvider.jsonData.isNotEmpty) ...[
                Container(
                  width: containerWidth,
                  padding: EdgeInsets.all(size.width > 600 ? 20.0 : 10.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          appProvider.jsonData.first['itemdescripcion'] ??
                              'Descripción no disponible',
                          style: TextStyle(
                            fontSize: fontSizeTitle,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
              if (appProvider.jsonData.isNotEmpty) ...[
                Container(
                  width: containerWidth,
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'STOCK SISTEMA ',
                        style: TextStyle(fontSize: fontSizeTitle, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: size.width > 600 ? 150 : 100),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
              appProvider.jsonData.isNotEmpty
                  ? Container(
                      width: containerWidth,
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: DataTable(
                            headingRowColor: MaterialStateColor.resolveWith(
                              (states) => Colors.grey[300]!,
                            ),
                            columns: [
                              DataColumn(
                                label: Text(
                                  'ALMACÉN',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontSizeContent,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'STOCK',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontSizeContent,
                                  ),
                                ),
                              ),
                            ],
                            rows: [
                              ...appProvider.jsonData
                                  .where((data) =>
                                      !['ALMACEN DE FALTANTES', 'ALMACEN PROVEEDOR'].contains(data['Name']))
                                  .map<DataRow>((data) {
                                return DataRow(
                                  cells: [
                                    DataCell(Container(
                                      padding: EdgeInsets.all(size.width > 600 ? 16.0 : 8.0),
                                      child: Text(
                                        data['Name'] ?? 'Sin almacén',
                                        style: TextStyle(fontSize: fontSizeContent),
                                      ),
                                    )),
                                    DataCell(Container(
                                      padding: EdgeInsets.all(size.width > 600 ? 16.0 : 8.0),
                                      child: Text(
                                        data['Stock']?.toString() ?? 'Sin stock',
                                        style: TextStyle(fontSize: fontSizeContent),
                                      ),
                                    )),
                                  ],
                                );
                              }).toList(),
                              if (appProvider.jsonData.any((data) =>
                                  almacenesConsiderados.contains(data['Name'])))
                                DataRow(
                                  cells: [
                                    DataCell(Container(
                                      padding: EdgeInsets.all(size.width > 600 ? 16.0 : 8.0),
                                      child:  Text(
                                        'TOTAL',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: fontSizeContent,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    )),
                                    DataCell(Container(
                                      padding: EdgeInsets.all(size.width > 600 ? 16.0 : 8.0),
                                      child: Text(
                                        totalCantidad.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: fontSizeContent,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    )),
                                  ],
                                ),
                            ],
                            columnSpacing: columnSpacing,
                            horizontalMargin: size.width > 600 ? 20.0 : 10.0,
                            headingTextStyle: TextStyle(
                              color: Colors.black,
                              fontSize: fontSizeContent,
                            ),
                            dataTextStyle: TextStyle(
                              color: Colors.black,
                              fontSize: fontSizeContent,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[400]!, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const Center(child: Text('')),
            ],
          ),
        ),
      ),
    );
  }
}
