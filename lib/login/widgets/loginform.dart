import 'package:app_dlog/login/Clases_por_consumir/input_decorations.dart';
import 'package:flutter/material.dart';

class ContainerInsertarDatos extends StatelessWidget {
  const ContainerInsertarDatos({
    super.key,
    required TextEditingController numeroController,
    required TextEditingController contraseniaController,
  }) : _numeroController = numeroController, _contraseniaController = contraseniaController;

  final TextEditingController _numeroController;
  final TextEditingController _contraseniaController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 500,
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 15,
                    offset: Offset(0, 5))
              ]),
          child: Column(
            children: [
              Text('Identificate',
                  style: TextStyle(
                      fontSize: 40, fontWeight: FontWeight.bold)),
              Container(
            
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                        controller: _numeroController,
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        decoration: InputDecorations.inputDecoration(
                            hintText: 'Ingrese su número',
                            labelText: 'Número de usuario',
                            icono: Icon(Icons.person))),
                    SizedBox(
                      height: 100,
                    ),
                    TextFormField(
                      controller: _contraseniaController,
                      autocorrect: false,
                      obscureText: true,
                      decoration: InputDecorations.inputDecoration(
                          hintText: '*********',
                          labelText: 'Contraseña',
                          icono: Icon(Icons.lock_outlined)),
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      disabledColor: Colors.grey,
                      onPressed: () {},
                      color: Color.fromARGB(255, 10, 99, 94),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 80, vertical: 15),
                            child: Text('Ingresar', style: TextStyle(color: Colors.white),),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}