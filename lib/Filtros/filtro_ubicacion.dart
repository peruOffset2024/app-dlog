import 'dart:convert';
import 'dart:io';
import 'package:app_dlog/index/vista_detalle.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class VistaFiltro extends StatefulWidget {
  const VistaFiltro({super.key, required this.barcode, required this.codSba, required this.jsonData});
  final String barcode;
  final String codSba;
  final List<dynamic> jsonData;

  @override
  State<VistaFiltro> createState() => _VistaFiltroState();
}

class _VistaFiltroState extends State<VistaFiltro> {
  final List<String> _zona = ['A', 'B', 'C', 'D', 'E', 'F'];
  final List<String> _stand = ['1', '2', '3', '4', '5', '6'];
  final List<String> _fila = ['1', '2', '3', '4', '5', '6'];
  final List<String> _columna = ['1', '2', '3', '4', '5', '6'];

  String? _selectedZona ;
  String? _selectedStand ;
  String? _selectedFila;
  String? _selectedColumna;
  File? _image;
  List<File> _images = [];
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _usuarioController = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickMultipleImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    setState(() {
      _images = pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
    });
  }

  Future<void> _showImageSourceActionSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Tomar Foto'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Seleccionar desde la Galería'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickMultipleImages();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String getSelectedValuesAsJson() {
    Map<String, dynamic> selectedValues = {
      'zona': _selectedZona,
      'stand': _selectedStand,
      'fila': _selectedFila,
      'columna': _selectedColumna,
      'imagen': _image?.path,
      'cantidad': _cantidadController.text,
      'imagenes': _images.map((image) => image.path).toList(),
      'usuario': _usuarioController.text,
    };
    return jsonEncode(selectedValues);
  }

  Future<void> enviarData() async {
    try {
      final url = 'http://190.107.181.163:81/amq/flutter_ajax_add.php';

      final response = await http.post(Uri.parse(url), body: {
        'search': widget.codSba,
        'zona': _selectedZona,
        'stand': _selectedStand,
        'col': _selectedColumna,
        'fil': _selectedFila,
        'cantidad': _cantidadController.text,
        'usuario': _usuarioController.text,
        'img': jsonEncode(_images.map((image) => image.path).toList())
        
      });

      if (response.statusCode == 200) {
        final newData = {
          'zona': _selectedZona,
          'stand': _selectedStand,
          'col': _selectedColumna,
          'fil': _selectedFila,
          'cantidad': _cantidadController.text,
          'usuario': _usuarioController.text,
          'img': _images.map((image) => image.path).toList()
          
        };
        print(newData);
        _clearTextControllers();
      } else {
        print('Error al enviar datos a la API. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _clearTextControllers() {
    _cantidadController.clear();
    _usuarioController.clear();
    setState(() {
      _selectedZona = 'A';
      _selectedStand = '1';
      _selectedFila = null;
      _selectedColumna = null;
      _image = null;
      _images.clear();
    });
  }

  void _removeImage(File image) {
    setState(() {
      _images.remove(image);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const VistaDetalle(
                  barcode: '',
                  codSba: '',
                ),
                transitionDuration: const Duration(milliseconds: 500),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      end: Offset.zero,
                      begin: const Offset(-1.0, 0.0),
                    ).animate(animation),
                    child: child,
                  );
                },
              ),
            ); //.then((_) => Navigator.pop(context));
          },
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: const Color.fromARGB(255, 33, 150, 243),
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
                    Text(
                      'DETALLE ITEM : ${widget.codSba.isNotEmpty ? widget.barcode : widget.barcode}',
                      style: const TextStyle(
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
                    const SizedBox(height: 20),
                    Center(
                      child: GestureDetector(
                        onTap: () => _showImageSourceActionSheet(context),
                        child: Container(
                          width: 300,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(255, 120, 193, 241),
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
                    _images.isNotEmpty
                        ? Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: _images.map((image) {
                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      image,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () => _removeImage(image),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.transparent,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          )
                        : const Text('No hay imágenes seleccionadas.'),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: SizedBox(
                            width: 200,
                            child: TextFormField(
                              controller: _cantidadController,
                              autocorrect: false,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  hintText: 'CANTIDAD'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: MaterialButton(
        onPressed: enviarData,
        color: const Color.fromARGB(255, 50, 54, 44),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 20,
          ),
          child: const Text(
            'Agregar',
            style: TextStyle(color: Colors.white),
          ),
        ),
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
          hint: const Text('Seleccionar una opción'),
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
