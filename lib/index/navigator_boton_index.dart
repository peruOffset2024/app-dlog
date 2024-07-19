import 'package:app_dlog/Vista_Qr/nab_vista_qr.dart';
import 'package:app_dlog/index/index.dart';
import 'package:app_dlog/login/iniciar_sesion.dart';
import 'package:flutter/material.dart';

class NavigatorBotonIndex extends StatefulWidget {
  const NavigatorBotonIndex({super.key});

  @override
  State<NavigatorBotonIndex> createState() => _NavigatorBotonIndexState();
}

class _NavigatorBotonIndexState extends State<NavigatorBotonIndex> {
  int indice = 0;

  List<Widget> numRutas = [
    Pag1(),
    IndexPagQr(),
    IniciarSesion()
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Center(child: numRutas[indice]),
        bottomNavigationBar: Container(
          height: 80,
          padding: EdgeInsets.only(bottom: 2),
          child: BottomNavigationBar(
            elevation: 50,
            onTap: (index) {
              setState(() {
                indice = index;
              });
            },
            currentIndex: indice,
            selectedItemColor: Colors.blue, // Color del elemento seleccionado
            unselectedItemColor: Colors.black, // Color de los elementos no seleccionados
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  size: 40,
                  Icons.home,
                  color: indice == 0? Colors.blue : Colors.black, // Cambia el color según el índice actual
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  size: 40,
                  Icons.qr_code_rounded,
                  color: indice == 1? Colors.blue : Colors.black, // Cambia el color según el índice actual
                ),
                label: 'Qr',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  size: 40,
                  Icons.exit_to_app,
                  color: indice == 2? Colors.blue : Colors.black, // Cambia el color según el índice actual
                ),
                label: 'Salir',
              ),
            ],
          ),
        ),
      ),
    );
  }
}