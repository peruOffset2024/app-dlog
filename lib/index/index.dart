import 'package:app_dlog/index/widget/tabla_item_diferencia.dart';
import 'package:flutter/material.dart';

class Pag1 extends StatefulWidget {
  const Pag1({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Pag1State createState() => _Pag1State();
}

class _Pag1State extends State<Pag1> {
  late Future<void> _dataFuture;

  Future<void> _fetchData() async {
    // Simula una actualización de datos con una demora de 2 segundos.
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  void initState() {
    super.initState();
    _dataFuture = _fetchData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _dataFuture = _fetchData();
    });
    // Mostrar un mensaje de confirmación al usuario.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Datos actualizados')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
        body: Container(
           decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
               Color.fromARGB(255, 157, 172, 179),// Color inicial
              Color.fromARGB(255, 255, 255, 255), // Color final
            ],
          ),
        ),
          child: RefreshIndicator(
            onRefresh: _refreshData,
            child: FutureBuilder<void>(
              future: _dataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error al cargar los datos'));
                } else {
                  return Center(
                    child: SizedBox(
                      width: 700,
                      child: ListView(
                        padding: const EdgeInsets.all(16.0),
                        children: [
                          const SizedBox(height: 50),
                          const Center(
                            child: Text(
                              "ITEM'S CON DIFERENCIAS",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 80),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: const TablaItemsDiferencia(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
      ],
    );
  }
}
