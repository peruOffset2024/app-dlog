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
            children: [
              cajapurpura(size),
              iconopersona(),
              loginform(context),
            ],
          ),
        ),
      ),
    );
  }

 

  Widget loginform(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 30),
        width: 350,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 30),
            const Text(
              'DLOG',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _numeroController,
                    autocorrect: false,
                    keyboardType: TextInputType.number,
                    decoration: InputDecorations.inputDecoration(
                      hintText: 'Ingrese su número',
                      labelText: 'Número de usuario',
                      icono: const Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _passwordController,
                    autocorrect: false,
                    obscureText: true,
                    decoration: InputDecorations.inputDecoration(
                      hintText: '*********',
                      labelText: 'Contraseña',
                      icono: const Icon(Icons.lock_outlined),
                    ),
                  ),
                  const SizedBox(height: 30),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    disabledColor: Colors.grey,
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NavigatorBotonIndex(),
                        ),
                      );
                    },
                    color: Colors.deepPurple,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 80,
                        vertical: 15,
                      ),
                      child: const Text(
                        'Ingresar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
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
      transform: Matrix4.rotationZ(-0.2), // adjust the rotation angle here
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(24, 128, 197, 1),
            Color.fromRGBO(90, 70, 178, 1),
          ],
        ),
      ),
      width: double.infinity,
      height: size.height * 0.49,
      child: ClipPath(
        clipper: CurvedClipper(), // custom clipper class
        child: Stack(
          children: [
            Positioned(
              top: 90,
              left: 30,
              child: burbuja(),
            ),
            Positioned(top: 90, left: 30, child: burbuja()),
            Positioned(top: 40, left: -30, child: burbuja()),
            Positioned(top: -50, right: -20, child: burbuja()),
            Positioned(bottom: -50, left: 10, child: burbuja()),
            Positioned(bottom: 120, right: 20, child: burbuja()),
            Positioned(top: 90, left: 30, child: burbuja()),
            
          ],
        ),
      ),
    );
  }

  Container burbuja() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: const Color.fromRGBO(255, 255, 255, 0.05),
      ),
    );
  }
}

class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.2); // start at the top left
    path.quadraticBezierTo(
      5,
      size.height * 0.5,
      100, // adjust this value to change the curve
      size.height * 0.5,
    ); // curve to the left
    path.lineTo(size.width, size.height * 0.2); // bottom right
    path.lineTo(size.width, 0); // top right
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
