import 'package:flutter/material.dart';
import 'package:app_dlog/index/nueva_vista_detalle.dart';

class NavNuevaVistaDetalle extends StatefulWidget {
  const NavNuevaVistaDetalle({
    super.key,
    required this.jsonData,
    required this.jsonDataUbi,
    required this.codigoSba,
    required this.barcode,
  });
  final List<dynamic> jsonData;
  final List<dynamic> jsonDataUbi;
  final String codigoSba;
  final String barcode;

  @override
  State<NavNuevaVistaDetalle> createState() => _NavNuevaVistaDetalleState();
}

class _NavNuevaVistaDetalleState extends State<NavNuevaVistaDetalle> {
  int indice = 0;

  double totalCantidadUbicaciones = 0.0;
  double totalCantidadAlmacen = 0.0;
  double diferencia = 0.0;

  @override
  void initState() {
    super.initState();
    _calcularTotales();
  }

  @override
  void didUpdateWidget(covariant NavNuevaVistaDetalle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.jsonData != widget.jsonData || oldWidget.jsonDataUbi != widget.jsonDataUbi) {
      _calcularTotales();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      indice = index;
    });
  }

  void _calcularTotales() {
    setState(() {
      totalCantidadUbicaciones = widget.jsonDataUbi.fold(0.0, (sum, data) {
        if (data['Cantidad'] != null) {
          if (data['Cantidad'] is num) {
            return sum + data['Cantidad'];
          } else if (data['Cantidad'] is String) {
            return sum + (double.tryParse(data['Cantidad']) ?? 0.0);
          }
        }
        return sum;
      });

      totalCantidadAlmacen = widget.jsonData.fold(0.0, (sum, data) {
        if (![
          'ALMACEN DE FALTANTES',
          'ALMACEN DE PRODUCTOS TERMINADO',
          'ALMACEN PROVEEDOR',
        ].contains(data['Name'])) {
          if (data['Stock'] != null) {
            if (data['Stock'] is num) {
              return sum + (data['Stock'] as num).toDouble();
            } else if (data['Stock'] is String) {
              return sum + (double.tryParse(data['Stock']) ?? 0.0);
            }
          }
        }
        return sum;
      });

      diferencia = totalCantidadAlmacen - totalCantidadUbicaciones;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NuevaVistaDetalle(
        jsonData: widget.jsonData,
        jsonDataUbi: widget.jsonDataUbi,
        codigoSba: widget.codigoSba,
        barcode: widget.barcode,
      ),
      bottomNavigationBar: Container(
        height: 105,
        padding: const EdgeInsets.only(bottom: 2),
        child: BottomNavigationBar(
          elevation: 10,
          onTap: _onItemTapped,
          currentIndex: indice,
          selectedItemColor: const Color.fromARGB(255, 33, 150, 243),
          unselectedItemColor: Colors.black,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                width: 150,
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.home,
                      size: 24,
                      color: indice == 0 ? Colors.blue : Colors.black,
                    ),
                    Text(
                      'Ubicaciones',
                      style: TextStyle(
                        fontSize: 12,
                        color: indice == 0 ? Colors.blue : Colors.black,
                      ),
                    ),
                    Text(
                      '$totalCantidadUbicaciones',
                      style: TextStyle(
                        fontSize: 12,
                        color: indice == 0 ? Colors.blue : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                width: 150,
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warehouse,
                      size: 24,
                      color: indice == 1 ? const Color.fromARGB(255, 16, 187, 21) : Colors.black,
                    ),
                    Text(
                      'Almacén',
                      style: TextStyle(
                        fontSize: 12,
                        color: indice == 1 ? const Color.fromARGB(255, 16, 187, 21) : Colors.black,
                      ),
                    ),
                    Text(
                      '$totalCantidadAlmacen',
                      style: TextStyle(
                        fontSize: 12,
                        color: indice == 1 ? const Color.fromARGB(255, 16, 187, 21) : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                width: 150,
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calculate,
                      size: 24,
                      color: indice == 2 ? Colors.red : Colors.black,
                    ),
                    Text(
                      'Diferencia',
                      style: TextStyle(
                        fontSize: 12,
                        color: indice == 2 ? Colors.red : Colors.black,
                      ),
                    ),
                    Text(
                      '$diferencia',
                      style: TextStyle(
                        fontSize: 12,
                        color: indice == 2 ? Colors.red : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
