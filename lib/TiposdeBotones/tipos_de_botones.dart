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
  child: const Text('Elevated Button'),
  onPressed: () {
    // Acción al presionar el botón
  },
),
TextButton(
  child: const Text('Text Button'),
  onPressed: () {
    // Acción al presionar el botón
  },
),
OutlinedButton(
  child: const Text('Outlined Button'),
  onPressed: () {
    // Acción al presionar el botón
  },
),IconButton(
  icon: const Icon(Icons.add),
  onPressed: () {
    // Acción al presionar el botón
  },
),FloatingActionButton(
  child: const Icon(Icons.add),
  onPressed: () {
    // Acción al presionar el botón
  },
),
PopupMenuButton(
  onSelected: (value) {
    // Acción al seleccionar una opción
  },
  itemBuilder: (context) => [
    const PopupMenuItem(
      value: 'opcion1',
      child: Text('Opción 1'),
    ),
    const PopupMenuItem(
      value: 'opcion2',
      child: Text('Opción 2'),
    ),
    
  ],
  
),
ToggleButtons(
  onPressed: (index) {
    // Acción al presionar un botón
  },
  isSelected: const [false, true],
  children: const [
    Icon(Icons.add),
    Icon(Icons.remove),
  ],
)
          ],
        ),
      ),
    );
  }
}