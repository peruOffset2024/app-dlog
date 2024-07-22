import 'package:flutter/material.dart';


class MyApp1 extends StatelessWidget {
  const MyApp1({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ejemplo de carga',
      home: Scaffold(
        body: Center(
          child: FutureBuilder(
            future: _cargarDatos(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.network('https://lh3.googleusercontent.com/proxy/S-4t8wg1CQLcTgAnsEymbGRs_lxFF3lR6pE6lkN8NCmjlnElkKBX4f96rt9-Jj2hvYxtYRkhaZZA1JOfDkDlVEOmXjPncfF7Jkw5WBJDHrL_SVbySB8',
                    height: 300,
                    width: 300) ,// Agregamos el GIF
                    const CircularProgressIndicator(),
                    const Text('Cargando...', style: TextStyle(fontSize: 12)),
                  ],
                );
              } else if (snapshot.hasData) {
                return Text('Datos cargados: ${snapshot.data}');
              } else {
                return Text('Error: ${snapshot.error}');
              }
            },
          ),
        ),
      ),
    );
  }

  Future<String> _cargarDatos() async {
    // Simulamos un retraso para demostrar el indicador de carga
    await Future.delayed(const Duration(seconds: 2));
    return 'Datos cargados';
  }
}