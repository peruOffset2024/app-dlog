import 'package:app_dlog/index/navigator_boton_index.dart';
import 'package:app_dlog/index/providers/auth_provider.dart';
import 'package:app_dlog/login/Clases_por_consumir/input_decorations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class IniciarSesion extends StatefulWidget {
  const IniciarSesion({super.key});

  @override
  State<IniciarSesion> createState() => _IniciarSesionState();
}

class _IniciarSesionState extends State<IniciarSesion> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.amber
          ),
          child: Stack(
            children: [
              cajapurpura(size),
              iconopersona(),
              loginform(context, size),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginform(BuildContext context, Size size) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          
          padding: EdgeInsets.all(size.width * 0.05),
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.08),
          width: size.width * 0.9,
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
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        hintText: '*********',
                        labelText: 'Contraseña',
                        icon: const Icon(Icons.lock_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: _toggleVisibility,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          disabledColor: Colors.grey,
                          onPressed: authProvider.isAuthenticated
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const NavigatorBotonIndex(),
                                    ),
                                  );
                                }
                              : () async {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    try {
                                      await authProvider.login(
                                        _numeroController.text,
                                        _passwordController.text,
                                      );
                                      if (authProvider.isAuthenticated) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const NavigatorBotonIndex(),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content:
                                                  Text('Invalid credentials')),
                                        );
                                      }
                                    } catch (error) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text('Authentication failed')),
                                      );
                                    }
                                  }
                                },
                          color: const Color.fromARGB(255, 43, 43, 44),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.2,
                              vertical: size.height * 0.02,
                            ),
                            child: const Text(
                              'Ingresar',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
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
      transform: Matrix4.rotationZ(-0.2),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(224, 116, 53, 1),
            Color.fromRGBO(199, 104, 15, 1),
          ],
        ),
      ),
      width: double.infinity,
      height: size.height * 0.49,
      child: ClipPath(
        child: Stack(
          children: [
            Positioned(
              top: size.height * 0.12,
              left: size.width * 0.08,
              child: burbuja(size),
            ),
            Positioned(
              top: size.height * 0.12,
              left: size.width * 0.08,
              child: burbuja(size),
            ),
            Positioned(
              top: size.height * 0.05,
              left: size.width * -0.08,
              child: burbuja(size),
            ),
            Positioned(
              top: size.height * -0.1,
              right: size.width * -0.05,
              child: burbuja(size),
            ),
            Positioned(
              bottom: size.height * -0.1,
              left: size.width * 0.02,
              child: burbuja(size),
            ),
            Positioned(
              bottom: size.height * 0.24,
              right: size.width * 0.05,
              child: burbuja(size),
            ),
            Positioned(
              top: size.height * 0.12,
              left: size.width * 0.08,
              child: burbuja(size),
            ),
          ],
        ),
      ),
    );
  }

  Container burbuja(Size size) {
    return Container(
      width: size.width * 0.2,
      height: size.width * 0.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size.width * 0.2),
        color: const Color.fromRGBO(255, 255, 255, 0.05),
      ),
    );
  }
}
