import 'package:app_dlog/index/Botones/widget_personalizado.dart';
import 'package:app_dlog/index/vista_filtros.dart';
import 'package:app_dlog/index/widget/tabla_stock_fisico.dart';
import 'package:app_dlog/index/widget/tabla_stock_sistema.dart';
import 'package:flutter/material.dart';

class VistaDetalle extends StatefulWidget {
  const VistaDetalle({Key? key}) : super(key: key);

  @override
  State<VistaDetalle> createState() => _VistaDetalleState();
}

class _VistaDetalleState extends State<VistaDetalle> {
  late Future<void> _actPantalla;
  double _arriba = 0;
  double _izquierdo = 0;

  Future<void> _actualizarPantalla() async {
    await Future.delayed(Duration(milliseconds: 200));
  }

  @override
  void initState() {
    super.initState();
    // cargar pantalla
    _actPantalla = _actualizarPantalla();

    // Posición del boton
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final anchoPantalla = MediaQuery.of(context).size.width;
      final alturaPantalla = MediaQuery.of(context).size.height;

      setState(() {
        _arriba = anchoPantalla - 80;
        _izquierdo = (alturaPantalla) - 1100;
      });
    });
  }

  Future<void> _refrescarPantalla() async {
    setState(() {
      _actPantalla = _actualizarPantalla();
    });
  }

  void _navegarSiguientePag() {
    Navigator.push(
        context,
        PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                VistaFiltro(),
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(1.0, 0.0), // Invertimos el begin
                  end: Offset.zero, // Invertimos el end
                ).animate(animation),
                child: child,
              );
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DETALLE ITEM : 757',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refrescarPantalla,
            child: FutureBuilder<void>(
              future: _actPantalla,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Center(
                    child: SizedBox(
                      width: 700,
                      child: ListView(
                        children: [
                          Container(
                            width: 790,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: const Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'COUCHE BRILLO ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Row(
                            children: [
                              SizedBox(
                                width: 45,
                              ),
                              Text(
                                'STOCK SISTEMA',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Container(
                            width: 700,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: TablaStockSistema(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 70),
                          const Row(
                            children: [
                              SizedBox(
                                width: 45,
                              ),
                              Text(
                                'STOCK FISICO',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Container(
                            width: 700,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: TablaStockFisico(),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 100,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Diferencias',
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: 680,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          width: 150,
                                          height: 50,
                                          child: const Center(
                                              child: Text('708.0')),
                                        ),
                                        const SizedBox(
                                          width: 50,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.yellow,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          width: 150,
                                          height: 50,
                                          child: const Center(
                                              child: Text('708.0')),
                                        ),
                                        const SizedBox(
                                          width: 50,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          width: 150,
                                          height: 50,
                                          child:
                                              const Center(child: Text('0.00')),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),

          /// aqui van los Draggable o boton nube
          if (_arriba != 0 && _izquierdo != 0)
            Positioned(
              left: _arriba,
              bottom: _izquierdo,
              child: Draggable(
                feedback: CuerpoBoton(_navegarSiguientePag),
                child: CuerpoBoton(_navegarSiguientePag),
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
              ),
            )
        ],
      ),
    );
  }
}
