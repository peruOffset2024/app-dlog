import 'package:app_dlog/app/app.dart';
import 'package:app_dlog/index/providers/appprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AppState(),),
    ],
    
    child: const MyApp()));
}




