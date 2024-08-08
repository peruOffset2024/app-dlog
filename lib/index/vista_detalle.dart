import 'package:app_dlog/Filtros/filtro_ubicacion.dart';
import 'package:app_dlog/index/Botones/widget_personalizado.dart';
import 'package:app_dlog/index/navigator_boton_index.dart';
import 'package:app_dlog/index/widget/stock_fisico.dart';
import 'package:app_dlog/index/widget/tabla_stock_fisico.dart';
import 'package:app_dlog/index/widget/tabla_stock_sistema.dart';
import 'package:flutter/material.dart';

class VistaDetalle extends StatefulWidget {
  final String barcode;
  final String codSba;

  const VistaDetalle({super.key, required this.barcode, required this.codSba});

  @override
  State<VistaDetalle> createState() => _VistaDetalleState();
}

class _VistaDetalleState extends State<VistaDetalle> {
  late Future<void> _actPantalla;
  double _arriba = 0;
  double _izquierdo = 0;

  List<StockFisico> stockFisicoList = [
    StockFisico(
        zona: 'ZONA A', stand: '7', col: '2', fila: '1', cantidad: '700'),
    StockFisico(zona: 'ZONA A', stand: '8', col: '2', fila: '1', cantidad: '8'),
  ];

  Future<void> _actualizarPantalla() async {
    await Future.delayed(const Duration(milliseconds: 200));
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

  Future<void> _refrescarPantalla() async {
    setState(() {
      _actPantalla = _actualizarPantalla();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Datos actualizados')),
    );
  }

  void _navegarSiguientePag() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => VistaFiltro(
          barcode: widget.barcode,
          codSba: widget.codSba, jsonData: const [], jsonDataUbi: const [], 
        ),
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
    );
  }

  void _eliminarStockFisico(int index) {
    setState(() {
      stockFisicoList.removeAt(index);
    });
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
            );//.then((_) => Navigator.pop(context));
          },
          child: const Icon(Icons.arrow_back),
        ),
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
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error al cargar los datos'));
                } else {
                  return Center(
                    child: SizedBox(
                      width: 700,
                      child: ListView(
                        padding: const EdgeInsets.all(16.0),
                        children: [
                          _buildDetalleItem(),
                          const SizedBox(height: 30),
                          _buildStockSistema(),
                          _buildStockFisico(),
                          const SizedBox(height: 100),
                          _buildDiferencias(),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
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
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    );
  }

  Widget _buildDetalleItem() {
    return Container(
      width: 700,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Text(
            'DETALLE ITEM: ${widget.codSba.isNotEmpty ? widget.barcode : widget.barcode}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'COUCHE BRILLO ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStockSistema() {
    return Column(
      children: [
        const Row(
          children: [
            SizedBox(width: 45),
            Text(
              'STOCK SISTEMA',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(
          width: 700,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: const TablaStockSistema(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStockFisico() {
    return Column(
      children: [
        const SizedBox(height: 70),
        const Row(
          children: [
            SizedBox(width: 45),
            Text(
              'STOCK FISICO',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(
          width: 700,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: TablaStockFisico(
                stockFisicoList: stockFisicoList,
                onDelete: _eliminarStockFisico,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDiferencias() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Diferencias',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 700,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDiferenciaContainer(Colors.grey, '708.0'),
                  const SizedBox(width: 50),
                  _buildDiferenciaContainer(Colors.yellow, '708.0'),
                  const SizedBox(width: 50),
                  _buildDiferenciaContainer(Colors.green, '0.00'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDiferenciaContainer(Color color, String text) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      width: 150,
      height: 50,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
