import 'package:app_dlog/Filtros/filtro_ubicacion.dart';
import 'package:app_dlog/index/Botones/widget_personalizado.dart';
import 'package:app_dlog/index/PruebasconotroProyecto/tabla_stock_sistema.dart';
import 'package:app_dlog/index/PruebasconotroProyecto/tabla_stock_fisico.dart';
import 'package:app_dlog/index/navigator_boton_index.dart';
import 'package:flutter/material.dart';


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
  late Future<void> _actPantalla;
  double _arriba = 0;
  double _izquierdo = 0;
  //double _totalCantidadAlmacen = 0.0;
  List<dynamic> jsondataActu = [];

  @override
  void initState() {
    super.initState();
    _actPantalla = _actualizarPantalla();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final anchoPantalla = MediaQuery.of(context).size.width;
      final alturaPantalla = MediaQuery.of(context).size.height;

      setState(() {
        _arriba = anchoPantalla - 80;
        _izquierdo = alturaPantalla - 1100;
      });
    });
  }
   
   
  

  Future<void> _actualizarPantalla() async {
    await Future.delayed(const Duration(milliseconds: 200));
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
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            VistaFiltro(barcode: widget.barcode, codSba: codigoSba3, jsonData: widget.jsonData, ),
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

  /*void _handleTotalCantidadCalculated(double totalCantidad) {
    setState(() {
      _totalCantidadAlmacen = totalCantidad;
    });
  }*/

  @override
  Widget build(BuildContext context) {
   /* double totalCantidadUbicaciones = 0.0;
    for (var data in widget.jsonDataUbi) {
      if (data['Cantidad'] != null && data['Cantidad'] is num) {
        totalCantidadUbicaciones += data['Cantidad'];
      } else if (data['Cantidad'] != null && data['Cantidad'] is String) {
        totalCantidadUbicaciones += double.tryParse(data['Cantidad']) ?? 0.0;
      }
    }
    double diferencia = _totalCantidadAlmacen - totalCantidadUbicaciones;*/
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const NavigatorBotonIndex(),
                transitionDuration: const Duration(milliseconds: 500),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      end: Offset.zero,
                      begin: const Offset(-1.0, 0.0),
                    ).animate(animation),
                    child: child,
                  );
                },
              ),
            );
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refrescarPantalla,
            child: FutureBuilder(
                future: _actPantalla,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text("Error: ${snapshot.error.toString()} "));
                  } else {
                    return Center(
                      child: SizedBox(
                        width: 700,
                        child: ListView(
                          padding: EdgeInsets.all(16),
                          children: [
                            TablaAlmacen(
                              jsonData: widget.jsonData,
                              resultados: [],
                              jsonDataUbi: widget.jsonDataUbi,
                              //onTotalCantidadCalculated: _handleTotalCantidadCalculated,
                            ),
                            TablaUbicacion(
                              jsonData: widget.jsonData,
                              jsonDataUbi: widget.jsonDataUbi,
                              codigoSba: widget.codigoSba,
                              resultados: [],
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
          /*Positioned(
            bottom: _izquierdo -120, // Ajusta la distancia del bottom para que no se superponga
            left: _arriba - 710, // Ajusta la distancia del left para centrar el Container alrededor del FloatingActionButton
            child: Container(
              height: 100,
              width: 780,
              color: Colors.white,
              child: Center(
                child: _buildDiferencias(
                  _totalCantidadAlmacen,
                  totalCantidadUbicaciones,
                  diferencia,
                ),
              ),
            ),
          ),*/
        ],
      ),
    );
  }

  /*Widget _buildDiferencias(double totalCantidadAlmacen, double totalCantidadUbicaciones, double diferencia) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
              width: 160,
              height: 80,
              child: Center(
                child: Text(
                  ' Total stock sistema:  \n $totalCantidadAlmacen',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(20),
              ),
              width: 160,
              height: 80,
              child: Center(
                child: Text(
                  ' Total stock fisico: \n $totalCantidadUbicaciones',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20),
              ),
              width: 160,
              height: 80,
              child: Center(
                child: Text(
                  'Diferencia : \n $diferencia',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  */
}
