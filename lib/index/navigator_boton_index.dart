import 'package:flutter/material.dart';

import 'package:app_dlog/Vista_Qr/nab_vista_qr.dart';
import 'package:app_dlog/index/index.dart';
import 'package:app_dlog/login/iniciar_sesion.dart'; // Asegúrate de importar tu pantalla de inicio de sesión

class NavigatorBotonIndex extends StatefulWidget {
  const NavigatorBotonIndex({super.key});

  @override
  State<NavigatorBotonIndex> createState() => _NavigatorBotonIndexState();
}

class _NavigatorBotonIndexState extends State<NavigatorBotonIndex> {
  int indice = 1;

  List<Widget> numRutas = [
    Pag1(),
    IndexPagQr(),
    
  ];

  Future<void> _mostrarAlertaSalir() async {
    bool salir = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmación'),
          content: Text('¿Desea salir de sesión?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Salir'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (salir) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => IniciarSesion()), // Reemplaza 'IniciarSesion' con tu pantalla de inicio de sesión
      );
    }
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      _mostrarAlertaSalir();
    } else {
      setState(() {
        indice = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: numRutas[indice]),
      bottomNavigationBar: Container(
        height: 80,
        padding: EdgeInsets.only(bottom: 2),
        child: BottomNavigationBar(
          elevation: 50,
          onTap: _onItemTapped,
          currentIndex: indice,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                size: 40,
                Icons.home,
                color: indice == 0 ? Colors.blue : Colors.black,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                size: 40,
                Icons.qr_code_rounded,
                color: indice == 1 ? Colors.blue : Colors.black,
              ),
              label: 'Qr',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                size: 40,
                Icons.exit_to_app,
                color: indice == 2 ? Colors.blue : Colors.black,
              ),
              label: 'Salir',
            ),
          ],
        ),
      ),
    );
  }
}
