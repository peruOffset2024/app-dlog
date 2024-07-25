import 'package:flutter/material.dart';

class MostrarData extends StatelessWidget {
  const MostrarData({super.key, required this.datosGet, required this.datosUbiGet});
  final List<dynamic> datosGet;
  final List<dynamic> datosUbiGet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: datosGet.length & datosGet.length,
        itemBuilder: (context, index){
          return ListTile(
            tileColor: Colors.pink[900],
            title: Text(datosGet[index]['itemdescripcion']),
            subtitle: Text(datosUbiGet[index]['Stand'] ),
          );
        }
      ),
    );
  }
}