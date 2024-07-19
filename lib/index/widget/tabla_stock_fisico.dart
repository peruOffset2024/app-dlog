
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
  builder: (BuildContext context) {
    return AlertDialog(
      title: Text('ALERTA'),
      content: Column(
        mainAxisSize: MainAxisSize.min, // Evita que el contenido se expanda demasiado
        children: [
          Text(
            '¿ESTAS SEGURO QUE DESEAS BORRAR?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20), // Espacio entre el texto y los botones
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribuye los botones de manera uniforme
          children: [
            ElevatedButton(
              onPressed: () {
                // Acción para el botón "SI"
              },
              child: Text('SI'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el diálogo
              },
              child: Text('NO'),
            ),
          ],
        ),
      ],
    );
  },
);
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