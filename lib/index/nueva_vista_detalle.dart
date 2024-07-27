import 'package:app_dlog/Filtros/filtro_ubicacion.dart';
import 'package:app_dlog/index/Botones/widget_personalizado.dart';
import 'package:app_dlog/index/PruebasconotroProyecto/tabla_stock_sistema.dart';
import 'package:app_dlog/index/PruebasconotroProyecto/tabla_stock_fisico.dart';
import 'package:app_dlog/index/navigator_boton_index.dart';
import 'package:flutter/material.dart';

class NuevaVistaDetalle extends StatefulWidget {
  const NuevaVistaDetalle(
      {super.key,
      required this.jsonData,
      required this.jsonDataUbi,
      required this.codigoSba, required this.barcode});
  
  final String codigoSba;
  final String barcode;

  final List<dynamic> jsonData;
  final List<dynamic> jsonDataUbi;
  @override
  State<NuevaVistaDetalle> createState() => _NuevaVistaDetalleState();
}

class _NuevaVistaDetalleState extends State<NuevaVistaDetalle> {
  late Future<void> _actPantalla;
  double _arriba = 0;
  double _izquierdo = 0;

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

  void _navegarSiguientePag() {
    final codigoSba3 = widget.codigoSba;
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            VistaFiltro(barcode: widget.barcode, codSba: codigoSba3, jsonData: widget.jsonData, ),
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    ); //.then((_) => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 150, 243), //Pag1
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
            ); //.then((_) => Navigator.pop(context));
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
                          //  principal-------
                          padding: EdgeInsets.all(16),
                          children: [
                            TablaAlmacen(
                              jsonData: widget.jsonData,
                              resultados: [],
                              jsonDataUbi: widget.jsonDataUbi,
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
          if (_arriba != 0 && _izquierdo != 0)
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
                    if (nuevaDerecha >
                        MediaQuery.of(context).size.height - 56) {
                      nuevaDerecha = MediaQuery.of(context).size.height - 56;
                    }

                    _arriba = nuevoArriba;
                    _izquierdo = nuevaDerecha;
                  });
                },
                child: CuerpoBoton(_navegarSiguientePag),
              ),
            ),
        ],
      ),
    );
  }
}
