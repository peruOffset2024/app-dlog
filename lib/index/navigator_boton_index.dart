import 'package:app_dlog/index/providers/auth_provider.dart';
import 'package:flutter/material.dart';

import 'package:app_dlog/Vista_Qr/nab_vista_qr.dart';
import 'package:app_dlog/index/diferencias.dart';
import 'package:app_dlog/login/iniciar_sesion.dart';
import 'package:provider/provider.dart'; // Asegúrate de importar tu pantalla de inicio de sesión

class NavigatorBotonIndex extends StatefulWidget {
  const NavigatorBotonIndex({super.key});

  @override
  State<NavigatorBotonIndex> createState() => _NavigatorBotonIndexState();
}

class _NavigatorBotonIndexState extends State<NavigatorBotonIndex> {
  int indice = 0;

  List<Widget> numRutas = [

    const Pag1(),
    const IndexPagQr(),
    
  ];

  Future<void> _mostrarAlertaSalir() async {
  bool? salir = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmación'),
        content: const Text('¿Desea salir de sesión?'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: const Text('Salir'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );

  if (salir == true) {
    Provider.of<AuthProvider>(context, listen: false).logout();
    Navigator.pushAndRemoveUntil(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (context) => const IniciarSesion()),
      (Route<dynamic> route) => false,
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
        padding: const EdgeInsets.only(bottom: 2),
        child: BottomNavigationBar(
          elevation: 50,
          onTap: _onItemTapped,
          currentIndex: indice,
          selectedItemColor: const Color.fromARGB(255, 33, 150, 243),
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
 