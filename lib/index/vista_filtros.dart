import 'package:app_dlog/components/img_picker.dart'; // Asegúrate de que este import es correcto
import 'package:flutter/material.dart';

class VistaFiltro extends StatefulWidget {
  const VistaFiltro({super.key});

  @override
  State<VistaFiltro> createState() => _VistaFiltroState();
}

class _VistaFiltroState extends State<VistaFiltro> {
  String _dropdownValueinicial = 'ZONA';
  String _dropdownValue2inicial = 'STAND';
  String _dropdownValue3inicial = 'FILA';
  String _dropdownValue4inicial = 'COLUMNA';

  final List<String> _columna = [
    'COLUMNA',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
  ];

  final List<String> _fila = [
    "FILA",
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
  ];

  final List<String> _stand = [
    'STAND',
    'RACK-1',
    'RACK-2',
    'RACK-3',
    'RACK-4',
    'RACK-5',
    'RACK-6',
    'RACK-7',
  ];

  final List<String> _zona = [
    'ZONA',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DETALLE ITEM : 757',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'COUCHE BRILLO',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  //color: Colors.amber,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButton<String>(
                      items: _zona.map((String item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _dropdownValueinicial = newValue!;
                        });
                      },
                      value: _dropdownValueinicial,
                      borderRadius: BorderRadius.circular(10),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      iconSize: 30,
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                      underline: Container(),
                    ),
                    const SizedBox(height: 30),
                    DropdownButton<String>(
                      items: _stand.map((String stand) {
                        return DropdownMenuItem(
                          value: stand,
                          child: Text(
                            stand,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? valuenew) {
                        setState(() {
                          _dropdownValue2inicial = valuenew!;
                        });
                      },
                      value: _dropdownValue2inicial,
                      borderRadius: BorderRadius.circular(10),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      iconSize: 30,
                      underline: Container(),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButton<String>(
                            items: _fila.map((String fil) {
                              return DropdownMenuItem(
                                value: fil,
                                child: Text(
                                  fil,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? filvalue) {
                              setState(() {
                                _dropdownValue3inicial = filvalue!;
                              });
                            },
                            value: _dropdownValue3inicial,
                            borderRadius: BorderRadius.circular(10),
                            icon: const Icon(Icons.keyboard_arrow_down),
                            iconSize: 30,
                            underline: Container(),
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: DropdownButton<String>(
                            items: _columna.map((String fila) {
                              return DropdownMenuItem(
                                value: fila,
                                child: Text(
                                  fila,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? valorcolumna) {
                              setState(() {
                                _dropdownValue4inicial = valorcolumna!;
                              });
                            },
                            value: _dropdownValue4inicial,
                            borderRadius: BorderRadius.circular(10),
                            icon: const Icon(Icons.keyboard_arrow_down),
                            iconSize: 30,
                            underline: Container(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 100),
                    Center(child: SubirImagenes()),
                    SizedBox(
                      height: 200,
                    ),
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: SizedBox(
                        height: 50,
                        width: 150,
                        child: Text(
                          'Cantidad : 2600',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
