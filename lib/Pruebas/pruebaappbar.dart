import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  Future<bool> _onWillPop() async {
    // Aquí puedes agregar la lógica para controlar el tiempo del botón de atrás
    // Por ejemplo, puedes mostrar un diálogo de confirmación antes de salir
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Seguro que deseas salir?'),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          ElevatedButton(
            child: const Text('Salir'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    return false; // Devuelve false para que el botón de atrás no se active inmediatamente
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mi App'),
        ),
        body: const Center(
          child: Text('Presiona el botón de atrás'),
        ),
      ),
    );
  }
}