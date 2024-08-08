import 'package:app_dlog/index/nueva_vista_detalle.dart';
import 'package:app_dlog/index/providers/provider_diferencias.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Pag1 extends StatelessWidget {
  const Pag1({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DataProvider()..fetchData(),
      child: Consumer<DataProvider>(
        builder: (context, dataProvider, child) {
          return Scaffold(
            
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Diferencias de Items', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  SizedBox(height: 50,),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromARGB(255, 200, 220, 230), // Color inicial más suave
                          Color.fromARGB(255, 255, 255, 255), // Color final blanco
                        ],
                      ),
                    ),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await dataProvider.fetchData();
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
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      columnSpacing: 20,
                                      columns: const [
                                        DataColumn(
                                          label: Text(
                                            'SBA',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Descripción',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Diferencia',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            '     -',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: dataProvider.data.map((item) {
                                        return DataRow(
                                          cells: [
                                            DataCell(
                                              Text(
                                                item['ItemCode'] ?? '',
                                                style: const TextStyle(fontSize: 14),
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                item['Descripcion'] ?? '',
                                                style: const TextStyle(fontSize: 14),
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                item['diferencia'] ?? '',
                                                style: const TextStyle(fontSize: 14),
                                              ),
                                            ),
                                            DataCell(
                                              IconButton(
                                                focusColor: Colors.black,
                                                onPressed: () {  }, icon: const Icon(Icons.remove_red_eye_sharp),)
                                            )
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  void _navigateToDetailPage(BuildContext context, Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NuevaVistaDetalle(jsonData: [], jsonDataUbi: [], codigoSba: item['ItemCode'], barcode: '',
          
        ),
      ),
    );
  }

  

}
 

