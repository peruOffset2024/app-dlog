import 'package:app_dlog/login/iniciar_sesion.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      title: "APP D'LOG",
      home: IniciarSesion()
    );
  }
}