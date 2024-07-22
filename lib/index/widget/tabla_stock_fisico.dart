import 'package:app_dlog/index/widget/stock_fisico.dart';
import 'package:flutter/material.dart';

class TablaStockFisico extends StatelessWidget {
  final List<StockFisico> stockFisicoList;
  final Function(int) onDelete;

  const TablaStockFisico({
    required this.stockFisicoList,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

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
            'DELETE',
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
      ],
      rows: List<DataRow>.generate(
        stockFisicoList.length,
        (index) => DataRow(
          cells: [
            DataCell(IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _alertMensaje(context, index);
              },
            )),
            DataCell(Text(stockFisicoList[index].zona)),
            DataCell(Text(stockFisicoList[index].stand)),
            DataCell(Text(stockFisicoList[index].col)),
            DataCell(Text(stockFisicoList[index].fila)),
            DataCell(Text(stockFisicoList[index].cantidad)),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _alertMensaje(BuildContext context, int index) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ALERTA'),
          content: Column(
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
                    onDelete(index);
                    Navigator.pop(context);
                  },
                  child: Text('SI'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('NO'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
