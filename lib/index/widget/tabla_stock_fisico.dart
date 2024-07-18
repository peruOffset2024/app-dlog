
import 'package:flutter/material.dart';

class TablaStockFisico extends StatelessWidget {
  const TablaStockFisico({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columnSpacing: 10.0,
      horizontalMargin: 20.0,
      headingRowColor: MaterialStateColor.resolveWith(
        (states) => const Color.fromARGB(169, 167, 219, 223),
      ),
      columns: const [
        DataColumn(
          label: Text(
            'UPDATE',
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
            'IMAG',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
      rows: [
        DataRow(
          cells: [
            DataCell(IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext content) {
                      return AlertDialog(
                        actions: [
                          Column(
                            children: [
                              const Center(
                                  child: Text('ALERTA',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold))),
                              const SizedBox(
                                height: 10,
                              ),
                              const Center(
                                  child: Text(
                                      '¿ESTAS SEGURO QUE DESEAS BORRAR?',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold))),
                              const SizedBox(
                                height: 100,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {},
                                      child: const Text('SI')),
                                  ElevatedButton(
                                      onPressed: () {},
                                      child: const Text('NO')),
                                ],
                              )
                            ],
                          ),
                        ],
                        content: const SizedBox(
                          height: 50,
                          width: 100,
                        ),
                      );
                    });
              },
            )),
            DataCell(Container(
              padding: const EdgeInsets.all(8),
              child: const Text(
                ' ZONA A',
                style: TextStyle(fontSize: 14),
              ),
            )),
            DataCell(Container(
              padding: const EdgeInsets.all(8),
              child: const Text(
                '7',
                style: TextStyle(fontSize: 14),
              ),
            )),
            DataCell(Container(
              padding: const EdgeInsets.all(8),
              child: const Text(
                '2',
                style: TextStyle(fontSize: 14),
              ),
            )),
            DataCell(Container(
              padding: const EdgeInsets.all(8),
              child: const Text(
                '1',
                style: TextStyle(fontSize: 14),
              ),
            )),
            DataCell(Container(
              padding: const EdgeInsets.all(8),
              child: const Text(
                '700',
                style: TextStyle(fontSize: 14),
              ),
            )),
            const DataCell(Text(' ')),
          ],
        ),
        DataRow(
          cells: [
            DataCell(IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {},
            )),
            DataCell(Container(
              padding: const EdgeInsets.all(8),
              child: const Text(
                'ZONA A',
                style: TextStyle(fontSize: 14),
              ),
            )),
            DataCell(Container(
              padding: const EdgeInsets.all(8),
              child: const Text(
                '8',
                style: TextStyle(fontSize: 14),
              ),
            )),
            DataCell(Container(
              padding: const EdgeInsets.all(8),
              child: const Text(
                '2',
                style: TextStyle(fontSize: 14),
              ),
            )),
            DataCell(Container(
              padding: const EdgeInsets.all(8),
              child: const Text(
                '1',
                style: TextStyle(fontSize: 14),
              ),
            )),
            DataCell(Container(
              padding: const EdgeInsets.all(8),
              child: const Text(
                '8',
                style: TextStyle(fontSize: 14),
              ),
            )),
            const DataCell(Text(' ')),
          ],
        ),
      ],
    );
  }
}