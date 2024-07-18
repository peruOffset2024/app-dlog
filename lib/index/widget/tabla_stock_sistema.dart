import 'package:flutter/material.dart';

class TablaStockSistema extends StatelessWidget {
  const TablaStockSistema({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DataTable(
      headingRowColor: MaterialStateColor.resolveWith(
          (states) => Color.fromARGB(169, 167, 219, 223)),
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
        DataRow(
          cells: [
            DataCell(Container(
              padding: const EdgeInsets.all(8),
              child: const Text(
                'HUACHIPA',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color.fromARGB(255, 12, 52, 85),
                ),
              ),
            )),
            DataCell(Container(
              padding: const EdgeInsets.all(8),
              child: const Text(
                '700',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color.fromARGB(255, 12, 52, 85),
                ),
              ),
            )),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Container(
              padding: const EdgeInsets.all(8),
              child: const Text(
                'RESERVA',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color.fromARGB(255, 12, 52, 85),
                ),
              ),
            )),
            DataCell(Container(
              padding: const EdgeInsets.all(8),
              child: const Text(
                '8',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color.fromARGB(255, 12, 52, 85),
                ),
              ),
            )),
          ],
        ),
      ],
      columnSpacing: 200.0,
      horizontalMargin: 120.0,
      headingTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      dataTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 14,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]!, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
