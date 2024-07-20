import 'package:flutter/material.dart';

class TiposDeBotones extends StatelessWidget {
  const TiposDeBotones({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
  child: Text('Elevated Button'),
  onPressed: () {
    // Acción al presionar el botón
  },
),
TextButton(
  child: Text('Text Button'),
  onPressed: () {
    // Acción al presionar el botón
  },
),
OutlinedButton(
  child: Text('Outlined Button'),
  onPressed: () {
    // Acción al presionar el botón
  },
),IconButton(
  icon: Icon(Icons.add),
  onPressed: () {
    // Acción al presionar el botón
  },
),FloatingActionButton(
  child: Icon(Icons.add),
  onPressed: () {
    // Acción al presionar el botón
  },
),
PopupMenuButton(
  onSelected: (value) {
    // Acción al seleccionar una opción
  },
  itemBuilder: (context) => [
    PopupMenuItem(
      child: Text('Opción 1'),
      value: 'opcion1',
    ),
    PopupMenuItem(
      child: Text('Opción 2'),
      value: 'opcion2',
    ),
    
  ],
  
),
ToggleButtons(
  children: [
    Icon(Icons.add),
    Icon(Icons.remove),
  ],
  onPressed: (index) {
    // Acción al presionar un botón
  },
  isSelected: [false, true],
)
          ],
        ),
      ),
    );
  }
}