import 'package:flutter/material.dart';

class ResumenDiferencias extends StatelessWidget {
  final double totalCantidadAlmacen;
  final double totalCantidadUbicaciones;
  final double diferencia;

  ResumenDiferencias({
    Key? key,
    required this.totalCantidadAlmacen,
    required this.totalCantidadUbicaciones,
    required this.diferencia,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resumen de Diferencias'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'DIFERENCIAS',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildContainer(
                        color: Colors.grey,
                        text: 'Total stock sistema: \n $totalCantidadAlmacen',
                      ),
                      _buildContainer(
                        color: Colors.yellow,
                        text: 'Total stock físico: \n $totalCantidadUbicaciones',
                      ),
                      _buildContainer(
                        color: Colors.green,
                        text: 'Diferencia: \n $diferencia',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContainer({required Color color, required String text}) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      width: 160,
      height: 60,
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
