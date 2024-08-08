import 'package:app_dlog/Filtros/filtro_ubicacion.dart';
import 'package:app_dlog/index/Botones/widget_personalizado.dart';
import 'package:app_dlog/index/PruebasconotroProyecto/tabla_stock_sistema.dart';
import 'package:app_dlog/index/PruebasconotroProyecto/tabla_stock_fisico.dart';
import 'package:app_dlog/index/indicador_de_carga.dart';

import 'package:app_dlog/index/providers/appprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NuevaVistaDetalle extends StatefulWidget {
  const NuevaVistaDetalle({
    super.key,
    required this.jsonData,
    required this.jsonDataUbi,
    required this.codigoSba,
    required this.barcode,
  });

  final String codigoSba;
  final String barcode;
  final List<dynamic> jsonData;
  final List<dynamic> jsonDataUbi;

  @override
  State<NuevaVistaDetalle> createState() => _NuevaVistaDetalleState();
}

class _NuevaVistaDetalleState extends State<NuevaVistaDetalle> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late AppProvider _appProvider;
  int indice = 0;
  // ignore: unused_field
  late Future<void> _actPantalla;
  late Future<void> _future = Future.value();
  double _arriba = 0;
  double _izquierdo = 0;
  double totalCantidadUbicaciones = 0.0;
  double totalCantidadAlmacen = 0.0;
  double diferencia = 0.0;

  @override
  void initState() {
    super.initState();
    _actPantalla = _actualizarPantalla();
    _appProvider = Provider.of<AppProvider>(context, listen: false);
    _appProvider.fetchData(widget.codigoSba);
    _appProvider.fetchDataUbi(widget.codigoSba);
    print('aQUI EL JSON _appProvider : $_appProvider');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final anchoPantalla = MediaQuery.of(context).size.width;
      final alturaPantalla = MediaQuery.of(context).size.height;
       _future =  _appProvider.fetchData(widget.codigoSba);
       _appProvider.fetchDataUbi(widget.codigoSba);
    
      setState(() {
        _arriba = anchoPantalla - 80;
        _izquierdo = alturaPantalla - 1100;
      });
    });
  }

  Future<void> _actualizarPantalla() async {
    // Aquí deberías realizar la lógica para actualizar los datos
    await Future.delayed(const Duration(milliseconds: 200));
  }

  void _onItemTapped(int index) {
    setState(() {
      indice = index;
    });
  }

  Future<void> _refrescarPantalla() async {
    setState(() {
      _actPantalla = _actualizarPantalla();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Datos actualizados')),
    );
  }

  void _navegarSiguientePag() {
    final codigoSba3 = widget.codigoSba;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            VistaFiltro(
              barcode: widget.barcode,
              codSba: codigoSba3,
              jsonData: widget.jsonData,
              jsonDataUbi: widget.jsonDataUbi,
            ),
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              end: Offset.zero,
              begin: const Offset(1.0, 0.0),
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalCantidadUbicaciones = 0.0;

    for (var data in _appProvider.jsonDataUbi) {
      if (data['Cantidad'] != null && data['Cantidad'] is num) {
        totalCantidadUbicaciones += data['Cantidad'];
      } else if (data['Cantidad'] != null && data['Cantidad'] is String) {
        totalCantidadUbicaciones += double.tryParse(data['Cantidad']) ?? 0.0;
      }
    }

    double totalCantidadAlmacen = 0.0;
    _appProvider.jsonData
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
    
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refrescarPantalla,
            child: FutureBuilder(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingIndicator();
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text("Error: ${snapshot.error.toString()}"));
                  } else {
                    return Center(
                      child: SizedBox(
                        width: 700,
                        child: ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            TablaAlmacen(
                              jsonData: _appProvider.jsonData,
                              resultados: const [],
                              jsonDataUbi: _appProvider.jsonDataUbi,
                            ),
                            TablaUbicacion(
                              jsonData: _appProvider.jsonData,
                              jsonDataUbi: _appProvider.jsonDataUbi,
                            ),
                           
                          ],
                        ),
                      ),
                    );
                  }
                }),
          ),
          Positioned(
            left: _arriba,
            bottom: _izquierdo,
            child: Draggable(
              feedback: CuerpoBoton(_navegarSiguientePag),
              childWhenDragging: Container(),
              onDragEnd: (details) {
                setState(() {
                  double nuevoArriba = details.offset.dx;
                  double nuevaDerecha = details.offset.dy;

                  if (nuevoArriba < 0) nuevoArriba = 0;
                  if (nuevaDerecha < 0) nuevaDerecha = 0;
                  if (nuevoArriba > MediaQuery.of(context).size.width - 56) {
                    nuevoArriba = MediaQuery.of(context).size.width - 56;
                  }
                  if (nuevaDerecha > MediaQuery.of(context).size.height - 56) {
                    nuevaDerecha = MediaQuery.of(context).size.height - 56;
                  }

                  _arriba = nuevoArriba;
                  _izquierdo = nuevaDerecha;
                });
              },
              child: CuerpoBoton(_navegarSiguientePag),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        height: 110,
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
                padding: const EdgeInsets.all(4),
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
                      'Stock Fisico',
                      style: TextStyle(
                        fontSize: 12,
                        color: indice == 0 ? Colors.blue : Colors.black,
                      ),
                    ),
                    Text(
                      '$diferencia',
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
                padding: const EdgeInsets.all(4),
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
                      'Stock Sistema',
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
                padding: const EdgeInsets.all(4),
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
                      '$totalCantidadUbicaciones',
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
