import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  Future<bool> _onWillPop() async {
    // Aquí puedes agregar la lógica para controlar el tiempo del botón de atrás
    // Por ejemplo, puedes mostrar un diálogo de confirmación antes de salir
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('¿Seguro que deseas salir?'),
        actions: <Widget>[
          ElevatedButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          ElevatedButton(
            child: Text('Salir'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    return false; // Devuelve false para que el botón de atrás no se active inmediatamente
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Mi App'),
        ),
        body: Center(
          child: Text('Presiona el botón de atrás'),
        ),
      ),
    );
  }
}