import 'dart:convert';
import 'dart:io';
import 'package:app_dlog/index/vista_detalle.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';

class VistaFiltro extends StatefulWidget {
  const VistaFiltro({
    super.key,
    required this.barcode,
    required this.codSba,
    required this.jsonData,
  });
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

  String? _selectedZona;
  String? _selectedStand;
  String? _selectedFila;
  String? _selectedColumna;
  List<File> _images = [];
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _usuarioController = TextEditingController();
  List<dynamic> jsonDataUbi = [];

  @override
  void initState() {
    super.initState();
    obtenerDatosUbicacion(widget.codSba);
  }

  Future<void> obtenerDatosUbicacion(String codSba) async {
    try {
      if (codSba.isNotEmpty) {
        final urlUbi =
            'http://190.107.181.163:81/amq/flutter_ajax_ubi.php?search=$codSba';
        final response = await http.get(Uri.parse(urlUbi));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            jsonDataUbi = data is List<dynamic> ? data : [];
          });
        } else {
          setState(() {
            jsonDataUbi = [];
          });
          // ignore: avoid_print
          print(
              'Error al consumir el API. Código de estado: ${response.statusCode}');
        }
      } else {
        setState(() {
          jsonDataUbi = [];
        });
        // ignore: avoid_print
        print('Código SBA vacío');
      }
    } catch (e) {
      setState(() {
        jsonDataUbi = [];
      });
      // ignore: avoid_print
      print('Error: $e');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
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

  Future<void> enviarData() async {
    if (_selectedZona == null ||
        _selectedStand == null ||
        _selectedFila == null ||
        _selectedColumna == null ||
        _cantidadController.text.isEmpty ||
        _usuarioController.text.isEmpty ||
        _images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    // Mostrar indicador de carga
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Cargando...'),
              ],
            ),
          ),
        );
      },
    );

    try {
      final codigoSba = widget.codSba;
      const uploadUrl = 'http://190.107.181.163:81/amq/flutter_ajax_add.php';

      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl))
        ..fields['search'] = codigoSba
        ..fields['ubicacion'] = codigoSba
        ..fields['zona'] = _selectedZona!
        ..fields['stand'] = _selectedStand!
        ..fields['col'] = _selectedColumna!
        ..fields['fil'] = _selectedFila!
        ..fields['cantidad'] = _cantidadController.text
        ..fields['usuario'] = _usuarioController.text;

      for (var image in _images) {
        var file = await http.MultipartFile.fromPath('img[]', image.path);
        request.files.add(file);
      }

      var response = await request.send();

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop(); // Cerrar el indicador de carga

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var responseData = json.decode(responseBody);
        if (responseData['success'] != null) {
          setState(() {
            _clearTextControllers();
          });
          _showSuccessDialog('Datos insertados correctamente');
        } else if (responseData['error'] != null) {
          _showErrorDialog('Error: ${responseData['error']}');
        }
      } else {
        _showErrorDialog(
            'Error al enviar datos a la API. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      Navigator.of(context)
          .pop(); // Cerrar el indicador de carga en caso de error
      _showErrorDialog('Error: $e');
    }
  }

  void _clearTextControllers() {
    _cantidadController.clear();
    _usuarioController.clear();
    setState(() {
      _selectedZona = null;
      _selectedStand = null;
      _selectedFila = null;
      _selectedColumna = null;
      _images.clear();
    });
  }

  void _removeImage(File image) {
    setState(() {
      _images.remove(image);
    });
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Éxito'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                      end: const Offset(1.0, 0.0),
                      begin: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
              ),
            );
            
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    ' DETALLE ITEM : ${widget.jsonData.first['ItemCode'] ?? 'N/A'}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    widget.jsonData.first['itemdescripcion'] ??
                        'Descripción no disponible',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold),
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
                        child: _buildDropdownField('Fila', _fila, _selectedFila,
                            (String? newValue) {
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
                  TextField(
                    controller: _cantidadController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Cantidad',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.numbers),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _usuarioController,
                    decoration: const InputDecoration(
                      labelText: 'Usuario',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () => _showImageSourceActionSheet(context),
                      child: Container(
                        width: 500, // Cambiar a ancho completo
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 49, 55, 59),
                        ),
                        child: _images.isNotEmpty
                            ? CarouselSlider(
                                options: CarouselOptions(
                                  enableInfiniteScroll: false,
                                  height: 280,
                                  aspectRatio: 16 / 9,
                                  viewportFraction: 0.8,
                                  enlargeCenterPage: true,
                                ),
                                items: _images.map((image) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Image.file(
                                              image,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                            ),
                                          ),
                                          Positioned(
                                            top: 10,
                                            right: 10,
                                            child: GestureDetector(
                                              onTap: () => _removeImage(image),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black54,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
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
                                    },
                                  );
                                }).toList(),
                              )
                            : const Icon(
                                Icons.camera_alt,
                                size: 50,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ),
                  
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        disabledColor: Colors.grey,
        onPressed: () {
          obtenerDatosUbicacion(widget.codSba);
          enviarData();
        },
        color: const Color.fromARGB(255, 49, 55, 59),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 338,
            vertical: 30,
          ),
          child: const Text(
            'Ingresar',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> items, String? value,
      ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
