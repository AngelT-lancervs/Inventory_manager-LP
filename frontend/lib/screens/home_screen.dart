import 'package:flutter/material.dart';
import 'package:inventory_manager/screens/tab_screen.dart';
import 'draft_list_screen.dart'; // Importa la pantalla de borradores

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inventory Manager',
          style: TextStyle(
            color: Colors.black87, // Color oscuro para el texto del AppBar
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent, // Fondo transparente
        elevation: 0, // Sin sombra para el AppBar
        centerTitle: true, // Centrar el título
        iconTheme: const IconThemeData(color: Colors.black87), // Íconos oscuros
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                  backgroundColor: Colors.black87, // Fondo negro
                  foregroundColor: Colors.white, // Texto blanco
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50), // Bordes completamente redondeados
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const InventoryScreen()),
                  );
                },
                child: const Text(
                  'Crear Inventario',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                  foregroundColor: Colors.black87, // Texto negro
                  side: const BorderSide(color: Colors.black87, width: 2), // Borde negro
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50), // Bordes completamente redondeados
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DraftListScreen()),
                  );
                },
                child: const Text(
                  'Ver Borradores',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
