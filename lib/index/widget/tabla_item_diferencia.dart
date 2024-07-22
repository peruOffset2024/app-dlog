import 'package:app_dlog/index/vista_detalle.dart';
import 'package:flutter/material.dart';

class TablaItemsDiferencia extends StatelessWidget {
  const TablaItemsDiferencia({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columnSpacing: 110.0,
      horizontalMargin: 20.0,
      headingRowColor: WidgetStateColor.resolveWith(
        (states) => const Color.fromARGB(169, 167, 219, 223),
      ),
      columns: const [
        DataColumn(
          label: Text(
            'COD SBA',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'FISICO',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'SISTEMA',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            '-----',
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
                '757',
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
            DataCell(Container(
              padding: const EdgeInsets.all(8),
              child: const Text(
                '650',
                style: TextStyle(fontSize: 14),
              ),
            )),
            DataCell(Container(
                padding: const EdgeInsets.all(8),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const VistaDetalle(barcode: '', codSba: '',),
                        transitionDuration: const Duration(milliseconds: 500),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        },
                      ),
                    ).then((_) => Navigator.pop(context));
                  },
                  child: const IconButton(
                    icon: Icon(size: 30, Icons.remove_red_eye_sharp),
                    onPressed:
                        null, // No se llama a onPressed cuando se utiliza GestureDetector
                  ),
                )
              )
            ),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Container(
              padding: const EdgeInsets.all(8),
              child: const Text(
                '758',
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
                '9',
                style: TextStyle(fontSize: 14),
              ),
            )),
            DataCell(Container(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const VistaDetalle(barcode: '', codSba: '',),
                        transitionDuration: const Duration(milliseconds: 500),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        },
                      ),
                    ).then((_) => Navigator.pop(context));
                  },
                  child: const IconButton(
                    icon: Icon(size: 30, Icons.remove_red_eye_sharp),
                    onPressed:
                        null, // No se llama a onPressed cuando se utiliza GestureDetector
                  ),
                )
            )),
          ],
        ),
      ],
    );
  }
}
