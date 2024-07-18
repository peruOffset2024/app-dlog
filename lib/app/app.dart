import 'package:app_dlog/login/iniciar_sesion.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "APP D'LOG",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 47, 133, 214)),
        useMaterial3: true,
      ),
      home: IniciarSesion()
    );
  }
}