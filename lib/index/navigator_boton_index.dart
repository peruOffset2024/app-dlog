import 'package:app_dlog/index/index.dart';
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
    Text(
      'Pag2',
      style: TextStyle(fontSize: 100, color: Colors.black),
    ),
    Text(
      'Pag3',
      style: TextStyle(fontSize: 100, color: Colors.black),
    ),
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
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(size: 40, color: Colors.black, Icons.home),
                    label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(
                        size: 40, color: Colors.black, Icons.qr_code_rounded),
                    label: 'Qr'),
                BottomNavigationBarItem(
                    icon:
                        Icon(size: 40, color: Colors.black, Icons.exit_to_app),
                    label: 'Salir')
              ],
            ),
          )),
    );
  }
}
