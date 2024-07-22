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
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 15,
                    offset: Offset(0, 5))
              ]),
          child: Column(
            children: [
              const Text('Identificate',
                  style: TextStyle(
                      fontSize: 40, fontWeight: FontWeight.bold)),
              Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                      controller: _numeroController,
                      autocorrect: false,
                      keyboardType: TextInputType.number,
                      decoration: InputDecorations.inputDecoration(
                          hintText: 'Ingrese su número',
                          labelText: 'Número de usuario',
                          icono: const Icon(Icons.person))),
                  const SizedBox(
                    height: 100,
                  ),
                  TextFormField(
                    controller: _contraseniaController,
                    autocorrect: false,
                    obscureText: true,
                    decoration: InputDecorations.inputDecoration(
                        hintText: '*********',
                        labelText: 'Contraseña',
                        icono: const Icon(Icons.lock_outlined)),
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    disabledColor: Colors.grey,
                    onPressed: () {},
                    color: const Color.fromARGB(255, 10, 99, 94),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 15),
                          child: const Text('Ingresar', style: TextStyle(color: Colors.white),),
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}