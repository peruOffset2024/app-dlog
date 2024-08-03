import 'dart:convert';

import 'package:app_dlog/Filtros/filtro_ubicacion.dart';
import 'package:app_dlog/index/Botones/widget_personalizado.dart';
import 'package:app_dlog/index/PruebasconotroProyecto/tabla_stock_sistema.dart';
import 'package:app_dlog/index/PruebasconotroProyecto/tabla_stock_fisico.dart';
import 'package:app_dlog/index/navigator_boton_index.dart';
import 'package:app_dlog/index/providers/appprovider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  late Future<void> _actPantalla;
  double _arriba = 0;
  double _izquierdo = 0;
  List<dynamic> jsonData2 = [];
  List<dynamic> jsonDataUbic2 = [];

  @override
  void initState() {
    super.initState();
    _actPantalla = _actualizarPantalla();
    Provider.of<AppProvider>(context, listen: false).fetchData(widget.codigoSba);
    Provider.of<AppProvider>(context, listen: false).fetchDataUbi(widget.codigoSba);
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
    // Aquí deberías realizar la lógica para actualizar los datos
    
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
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            VistaFiltro(barcode: widget.barcode, codSba: codigoSba3, jsonData: widget.jsonData, jsonDataUbi: widget.jsonDataUbi, ),
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
    final appProvider = Provider.of<AppProvider>(context);
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
                future:  _actPantalla,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text("Error: ${snapshot.error.toString()} "));
                  } else {
                    return Center(
                      child: SizedBox(
                        width: 700,
                        child: ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            TablaAlmacen(
                              jsonData: widget.jsonData,
                              resultados: [],
                              jsonDataUbi: widget.jsonDataUbi,
                            ),
                            TablaUbicacion(
                              jsonData: appProvider.jsonData,
                              jsonDataUbi: appProvider.jsonDataUbi,
                             
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
    );
  }

  Future<void> _dataRefrescar() async {
    
    try {
      final codigosba2 = widget.codigoSba;
      final UrlUbicaciones =
          'http://190.107.181.163:81/amq/flutter_ajax_ubi.php?search=$codigosba2';
      final responseUbicaciones = await http.get(Uri.parse(UrlUbicaciones));
      if (responseUbicaciones.statusCode == 200) {
        final dataUbi = jsonDecode(responseUbicaciones.body);
        setState(() {
          jsonDataUbic2  = dataUbi is List<dynamic> ? dataUbi : [];
        });
      } else {
        setState(() {
          jsonDataUbic2  = [];
        });
        print('Error al obtener datos de la ubicacion');
      }
    } catch (e) {
      setState(() {
        jsonDataUbic2  = [];
    
      });
      print('Error: $e');
    }
  }
}
