import 'package:flutter/material.dart';


class TablaAlmacen extends StatelessWidget {
  final List<dynamic> jsonData;
  //final void Function(double) onTotalCantidadCalculated; // Callback

  // ignore: use_key_in_widget_constructors
  const TablaAlmacen({
    Key? key,
    required this.jsonData,
    required List resultados,
    required List jsonDataUbi,
    //required this.onTotalCantidadCalculated, // Callback
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lista de almacenes que deben considerarse para la suma
    const almacenesConsiderados = [
      'ALMACEN DE RESERVA',
      'ALMACEN HUACHIPA',
      'ALMACEN CUARENTENA',
      'ALMACEN DE REPUESTOS (2018)'
    ];

    // Calcula el total de cantidades de los almacenes específicos
    double totalCantidad = 0.0;

    jsonData
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

    // Invoke the callback with the calculated totalQuantity
   /* WidgetsBinding.instance.addPostFrameCallback((_) {
      onTotalCantidadCalculated(totalCantidad);
    });*/

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (jsonData.isNotEmpty) ...[
            Container(
              width: 700,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    ' DETALLE ITEM : ${jsonData.first['ItemCode'] ?? 'N/A'}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    jsonData.first['itemdescripcion'] ??
                        'Descripción no disponible',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
          if (jsonData.isNotEmpty) ...[
              // ignore: sized_box_for_whitespace
              Container(
                width: 600,
                height: 60,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'STOCK SISTEMA ',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 100,),
          
                  ],
                ),
              ),
              const SizedBox(height: 10,)
            ],
          jsonData.isNotEmpty
              // ignore: sized_box_for_whitespace
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
                        headingRowColor: MaterialStateColor.resolveWith(
                          (states) => Colors.grey[300]!,
                        ),
                        columns: const [
                          DataColumn(
                            label: Text(
                              'ALMACÉN',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'STOCK',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                        rows: [
                          //////
                          ...jsonData
                              .where((data) =>
                                  !['ALMACEN DE FALTANTES', 'ALMACEN PROVEEDOR'].contains(data['Name']))
                              .map<DataRow>((data) {
                            return DataRow(
                              cells: [
                                DataCell(Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    data['Name'] ?? 'Sin almacén',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                )),
                                DataCell(Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    data['Stock']?.toString() ?? 'Sin stock',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                )),
                              ],
                            );
                          }).toList(),
                          if (jsonData.any((data) =>
                              almacenesConsiderados.contains(data['Name'])))
                            DataRow(
                              cells: [
                                DataCell(Container(
                                  padding: const EdgeInsets.all(8),
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
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    totalCantidad.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.blue,
                                    ),
                                  ),
                                )),
                              ],
                            ),
                        ],
                        columnSpacing: 190.0,
                        horizontalMargin: 20.0,
                        headingTextStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        dataTextStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey[400]!, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                )
              : const Center(child: Text('')), //texto Codigo SBA no existe
        ],
      ),
    );
  }
}
