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

  @override
  void initState() {
    super.initState();
    _actPantalla = _actualizarPantalla();
    _appProvider = Provider.of<AppProvider>(context, listen: false);
    _appProvider.fetchData(widget.codigoSba);
    _appProvider.fetchDataUbi(widget.codigoSba);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _future = _appProvider.fetchData(widget.codigoSba);
      _appProvider.fetchDataUbi(widget.codigoSba);

      final size = MediaQuery.of(context).size;
      setState(() {
        _arriba = size.width - 80;
        _izquierdo = size.height - 1100;
      });
    });
  }

  Future<void> _actualizarPantalla() async {
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
        pageBuilder: (context, animation, secondaryAnimation) => VistaFiltro(
          barcode: widget.barcode,
          codSba: codigoSba3,
          jsonData: widget.jsonData,
          jsonDataUbi: widget.jsonDataUbi,
        ),
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
    final size = MediaQuery.of(context).size;
    //final double fontSizeTitle = size.width > 600 ? 28 : 24; // Título
    final double fontSizeData = size.width > 600 ? 20 : 16; // Datos

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

    double diferencia = totalCantidadAlmacen - totalCantidadUbicaciones;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          ' DETALLE ITEM : ${_appProvider.jsonData.first['ItemCode'] ?? 'N/A'}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
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
                    child: Text(
                      "Error: ${snapshot.error.toString()}",
                      style: TextStyle(fontSize: fontSizeData),
                    ),
                  );
                } else {
                  return Center(
                    child: SizedBox(
                      width: size.width > 800 ? 700 : size.width * 0.9,
                      child: ListView(
                        children: [
                          TablaAlmacen(
                            jsonData: _appProvider.jsonData,
                            resultados: const [],
                            jsonDataUbi: _appProvider.jsonDataUbi,
                            codigoSba: widget.codigoSba,
                            barcode: widget.barcode, onItemPressed: () { 
                              setState(() {
                                indice = 0;
                              });
                             },
                          ),
                          TablaUbicacion(
                            jsonData: _appProvider.jsonData,
                            jsonDataUbi: _appProvider.jsonDataUbi, onItemPressed2: () { 
                              setState(() {
                                indice = 1;
                              });
                             },
                            
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
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
                  if (nuevoArriba > size.width - 56) {
                    nuevoArriba = size.width - 56;
                  }
                  if (nuevaDerecha > size.height - 56) {
                    nuevaDerecha = size.height - 56;
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amberAccent[400],
        onPressed: _navegarSiguientePag,
        child: const Icon(
          color: Colors.white70,
          Icons.playlist_add_outlined),
      ),
      bottomNavigationBar: Container(
        //height: size.height > 600 ? 110 : 80,
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
                width: size.width > 600 ? 150 : 120,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: indice == 0 ? Colors.greenAccent[400] : const Color.fromARGB(255, 241, 237, 237),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.home,
                      size: size.width > 600 ? 30 : 24,
                      color: indice == 0 ? Colors.blue : Colors.black,
                    ),
                    Text(
                      'Stock Sistema',
                      style: TextStyle(
                        fontSize: size.width > 600 ? 14 : 12,
                        color: indice == 0 ? Colors.blue : Colors.black,
                      ),
                    ),
                    Text(
                      '$totalCantidadAlmacen',
                      style: TextStyle(
                        fontSize: size.width > 600 ? 14 : 12,
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
                width: size.width > 600 ? 150 : 120,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: indice == 1 ? Colors.blueAccent[400] : const Color.fromARGB(255, 241, 237, 237),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warehouse,
                      size: size.width > 600 ? 30 : 24,
                      color: indice == 1 ? Color.fromARGB(255, 255, 255, 255) : Colors.black,
                    ),
                    Text(
                      'Stock Fisico',
                      style: TextStyle(
                        fontSize: size.width > 600 ? 14 : 12,
                        color: indice == 1 ?  const Color.fromARGB(255, 255, 255, 255)
                            : Colors.black,
                      ),
                    ),
                    Text(
                      '$totalCantidadUbicaciones',
                      style: TextStyle(
                        fontSize: size.width > 600 ? 14 : 12,
                        color: indice == 1 ? const Color.fromARGB(255, 255, 255, 255)
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                width: size.width > 600 ? 150 : 120,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.redAccent[400],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.remove_rounded,
                      size: size.width > 600 ? 30 : 24,
                      color: indice == 2 ? Color.fromARGB(255, 255, 255, 255) : Colors.black,
                    ),
                    Text(
                      'Diferencia',
                      style: TextStyle(
                        fontSize: size.width > 600 ? 14 : 12,
                        color: indice == 2
                            ? const Color.fromARGB(255, 255, 255, 255)
                            : Colors.black,
                      ),
                    ),
                    Text(
                      '$diferencia',
                      style: TextStyle(
                        fontSize: size.width > 600 ? 14 : 12,
                        color: indice == 2
                            ? const Color.fromARGB(255, 255, 255, 255)
                            : Colors.black,
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
