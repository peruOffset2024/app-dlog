
import 'package:app_dlog/index/navigator_boton_index.dart';
import 'package:app_dlog/login/Clases_por_consumir/input_decorations.dart';
import 'package:flutter/material.dart';






class IniciarSesion extends StatefulWidget {
  const IniciarSesion({super.key});

  @override
  State<IniciarSesion> createState() => _IniciarSesionState();
}

class _IniciarSesionState extends State<IniciarSesion> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _numeroController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [cajapurpura(size), iconopersona(), loginform(context)],
          ),
        ),
      ),
    );
  }

  SingleChildScrollView loginform(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        children: [
          SizedBox(width: 135,),
          Column(
            
            children: [
              const SizedBox(
                height: 250,
              ),
              Container(
                
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 30),
                width: 500,
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
                    const SizedBox(height: 50),
                    Text('DLOG',
                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                    Container(
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 70,
                            ),
                            TextFormField(
                                controller: _numeroController,
                                autocorrect: false,
                                keyboardType: TextInputType.number,
                                decoration: InputDecorations.inputDecoration(
                                    hintText: 'Ingrese su número',
                                    labelText: 'Número de usuario',
                                    icono: Icon(Icons.person)),
                                /*validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, ingrese su número de usuario';
                                  }
                                  if (value.length < 8) {
                                    return 'El número debe tener al menos 8 dígitos';
                                  }
                                  return null;
                                }*/
                                ),
                            const SizedBox(
                              height: 100,
                            ),
                            TextFormField(
                                controller: _passwordController,
                                autocorrect: false,
                                obscureText: true,
                                decoration: InputDecorations.inputDecoration(
                                    hintText: '*********',
                                    labelText: 'Contraseña',
                                    icono: Icon(Icons.lock_outlined)),
                                /*validator: (value) {
                                  return (value != null && value.length >= 4)
                                      ? null
                                      : 'La contraseña debe ser mayor o igual a los 4 caracteres';
                                }*/
                                ),
                            SizedBox(height: 200),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              disabledColor: Colors.grey,
                              onPressed: () async {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const NavigatorBotonIndex()));
                                
                                
                               /* if (_formKey.currentState!.validate()) {
                                  final token = await iniciarSesion(
                                      _numeroController.text, _passwordController.text);
                                  if (token != null) {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> PantallaInicioAmp()));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text('Error al iniciar sesión')));
                                  }
                                }*/
                              },
                              color: Colors.deepPurple,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                                child: Text(
                                  'Ingresar',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  SafeArea iconopersona() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 30),
        width: double.infinity,
        child: const Icon(
          Icons.person_pin,
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }

  Container cajapurpura(Size size) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
        Color.fromRGBO(24, 128, 197, 1),
        Color.fromRGBO(90, 70, 178, 1)
      ])),
      width: double.infinity,
      height: size.height * 0.4,
      child: Stack(
        children: [
          Positioned(
            child: burbuja(),
            top: 90,
            left: 30,
          ),
          Positioned(child: burbuja(), top: 90, left: 30),
          Positioned(child: burbuja(), top: -40, left: -30),
          Positioned(child: burbuja(), top: -50, right: -20),
          Positioned(child: burbuja(), bottom: -50, left: 10),
          Positioned(child: burbuja(), bottom: 120, right: 20),
        ],
      ),
    );
  }

  Container burbuja() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: const Color.fromRGBO(255, 255, 255, 0.05)),
    );
  }
}


