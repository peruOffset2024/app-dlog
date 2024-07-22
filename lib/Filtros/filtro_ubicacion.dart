import 'dart:convert';
import 'dart:io';
import 'package:app_dlog/index/vista_detalle.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VistaFiltro extends StatefulWidget {
  const VistaFiltro({super.key});

  @override
  State<VistaFiltro> createState() => _VistaFiltroState();
}

class _VistaFiltroState extends State<VistaFiltro> {
  final List<String> _zona = ['A', 'B', 'C', 'D', 'E', 'F'];
  final List<String> _stand = ['1', '2', '3', '4', '5', '6'];
  final List<String> _fila = ['1', '2', '3', '4', '5', '6'];
  final List<String> _columna = ['1', '2', '3', '4', '5', '6'];

  String? _selectedZona = 'A';
  String? _selectedStand = '1';
  String? _selectedFila;
  String? _selectedColumna;
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  String getSelectedValuesAsJson() {
    Map<String, dynamic> selectedValues = {
      'zona': _selectedZona,
      'stand': _selectedStand,
      'fila': _selectedFila,
      'columna': _selectedColumna,
      'imagen': _image?.path,
    };
    return jsonEncode(selectedValues);
  }

  void _handleSubmit() {
    String jsonData = getSelectedValuesAsJson();
    print(
        jsonData); // Aquí puedes enviar los datos a tu backend o guardarlos donde necesites
    // Por ejemplo, puedes llamar a un método que inserte los datos en la base de datos
  }

  final TextEditingController _cantidadController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    VistaDetalle(
                  barcode: '', codSba: '',
                ),
                transitionDuration: const Duration(milliseconds: 500),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
              ),
            ).then((_) => Navigator.pop(context));
          },
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: Color.fromRGBO(47, 58, 155, 1),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'DETALLE ITEM : 757',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Text(
                      'COUCHE BRILLO',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    _buildDropdownField('ZONA', _zona, _selectedZona,
                        (String? newValue) {
                      setState(() {
                        _selectedZona = newValue;
                      });
                    }),
                    const SizedBox(height: 20),
                    _buildDropdownField('Stand', _stand, _selectedStand,
                        (String? newValue) {
                      setState(() {
                        _selectedStand = newValue;
                      });
                    }),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _buildDropdownField(
                              'Fila', _fila, _selectedFila, (String? newValue) {
                            setState(() {
                              _selectedFila = newValue;
                            });
                          }),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDropdownField(
                              'Columna', _columna, _selectedColumna,
                              (String? newValue) {
                            setState(() {
                              _selectedColumna = newValue;
                            });
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 100),
                    Center(
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 300,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color.fromARGB(255, 120, 193, 241),
                          ),
                          child: _image != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.file(
                                    _image!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(
                                  Icons.upload_file_rounded,
                                  size: 100,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Mostrar los valores seleccionados y la imagen debajo de la tarjeta
                    /*if (_selectedZona != null ||
                        _selectedStand != null ||
                        _selectedFila != null ||
                        _selectedColumna != null ||
                        _image != null)
                      SizedBox(
                        width: 500,
                        height: 300,
                        child: Card(
                          margin: const EdgeInsets.all(16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'CANTIDAD: 8500', //Valores Seleccionados:
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                if (_selectedZona != null)
                                  Text('Zona: $_selectedZona'),
                                if (_selectedStand != null)
                                  Text('Stand: $_selectedStand'),
                                if (_selectedFila != null)
                                  Text('Fila: $_selectedFila'),
                                if (_selectedColumna != null)
                                  Text('Columna: $_selectedColumna'),
                                if (_image != null) ...[
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Imagen Seleccionada:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Image.file(
                                    _image!,
                                    height: 150,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),*/
                      SizedBox(height: 100,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: SizedBox(
                            width: 200,
                            child: TextFormField(
                              controller: _cantidadController,
                              autocorrect: false,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  hintText: 'CANTIDAD'),
                            ),
                          ),
                        ),
                        //SizedBox(width: 250,),
                        FloatingActionButton.extended(
                          onPressed: _handleSubmit,
                          label: Text('Agregar'),
                          icon: Icon(Icons.add),
                        ),          
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ],
          ),
          
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    );
  }

  Widget _buildDropdownField(
    String label,
    List<String> items,
    String? selectedItem,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        DropdownButton<String>(
          value: selectedItem,
          hint: Text('Seleccionar una opción'),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          isExpanded: true,
        ),
      ],
    );
  }
}
