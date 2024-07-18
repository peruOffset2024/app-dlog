import 'package:flutter/material.dart';

Widget CuerpoBoton(Function() onTap) {
  return Material(
    type: MaterialType.transparency,
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromARGB(255, 148, 206, 184),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Icon(size: 50, Icons.add),
      ),
    ),
  );
}
