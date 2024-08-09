import 'package:app_dlog/index/nueva_vista_detalle.dart';
import 'package:app_dlog/index/providers/provider_diferencias.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Pag1 extends StatelessWidget {
  const Pag1({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double fontSizeTitle = size.width > 600 ? 25 : 20; // Tamaño de fuente del título
    final double fontSizeData = size.width > 600 ? 18 : 16; // Tamaño de fuente de los datos
    final double fontSizeSubTitle = size.width > 600 ? 16 : 14; // Tamaño de fuente para subtítulos

    return ChangeNotifierProvider(
      create: (_) => DataProvider()..fetchData(),
      child: Consumer<DataProvider>(
        builder: (context, dataProvider, child) {
          return Scaffold(
            appBar: AppBar(
              leading: const Text(''),
              title: Text(
                'Diferencias de Items',
                style: TextStyle(fontSize: fontSizeTitle),
              ),
              centerTitle: true,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: RefreshIndicator(
                  onRefresh: () async {
                    await dataProvider.fetchData();
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Datos actualizados')),
                    );
                  },
                  child: dataProvider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : dataProvider.errorMessage.isNotEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  dataProvider.errorMessage,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: fontSizeData,
                                  ),
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: dataProvider.data.length,
                              itemBuilder: (context, index) {
                                final item = dataProvider.data[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(16.0),
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text( 
                                          'SBA: ${item['ItemCode'] ?? ''}',
                                          style: TextStyle(
                                            fontSize: fontSizeData,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text(
                                          item['Descripcion'] ?? '',
                                          style: TextStyle(
                                            fontSize: fontSizeSubTitle,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Text(
                                      'Diferencia: ${item['diferencia'] ?? ''}',
                                      style: TextStyle(
                                        fontSize: fontSizeData,
                                        color: Colors.redAccent[400]
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.remove_red_eye_sharp),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => NuevaVistaDetalle(
                                              jsonData: const [],
                                              jsonDataUbi: const [],
                                              codigoSba: item['ItemCode'],
                                              barcode: '',
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
