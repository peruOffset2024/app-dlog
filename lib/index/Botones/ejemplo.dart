import 'package:flutter/material.dart';

class VistaFiltro extends StatefulWidget {
  const VistaFiltro({super.key});

  @override
  State<VistaFiltro> createState() => _VistaFiltroState();
}

class _VistaFiltroState extends State<VistaFiltro> {
  String _dropdownValue = '1';

  var _items = [
    '1',
    '2',
    '3',
    '4',
    '5'
  ];

 

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text('PAGINA DE FILTROS', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),),
        Container(
          width: 800,
          height: 800,
          decoration: BoxDecoration(
            color: Colors.amberAccent,
            borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: DropdownButton(
                
                items: _items.map((String item){
                return DropdownMenuItem(value: item,
                child: Text(item));
              }).toList(),
              onChanged: (String? newValue){
                setState(() {
                  _dropdownValue = newValue!;
                });
              },
              value: _dropdownValue,
              borderRadius: BorderRadius.circular(10),
              icon: const Icon(Icons.keyboard_arrow_down),
              iconSize: 50,
              style: TextStyle(color: Colors.black),
              underline: Container(),
              ),
              
            ),
        )
        ],
      ),
    );
  }
}