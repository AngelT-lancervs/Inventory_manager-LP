// lib/main.dart

import 'package:flutter/material.dart';
import 'screens/product_list_screen.dart';

void main() {
  runApp(const MyApp());
}

/// Clase principal de la aplicación.
/// Esta clase construye la raíz de la aplicación Flutter.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Inventario', // Título de la aplicación
      theme: ThemeData(
        primarySwatch: Colors.blue, // Color principal de la aplicación
      ),
      home: const ProductListScreen(), // Define la pantalla inicial de la aplicación
    );
  }
}
