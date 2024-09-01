import 'package:flutter/material.dart';
import 'package:inventory_manager/models/product.dart';
import 'package:inventory_manager/screens/tab_screen.dart';
import 'package:inventory_manager/services/api_product.dart';

class UpdateStockScreen extends StatefulWidget {
  final Product product;

  const UpdateStockScreen({super.key, required this.product});

  @override
  UpdateStockScreenState createState() => UpdateStockScreenState();
}

class UpdateStockScreenState extends State<UpdateStockScreen> {
  // Controlador para el campo de entrada de stock
  final _stockController = TextEditingController();

  // Servicio para realizar la actualización del stock
  final ApiServiceProduct apiService = ApiServiceProduct();

  // Función que maneja la actualización del stock
  void _updateStock() async {
    try {
      // Convierte el valor ingresado a un entero
      int newStock = int.parse(_stockController.text);
      // Llama al servicio para actualizar el stock
      await apiService.updateStock(widget.product.id, newStock);

      // Muestra un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stock actualizado exitosamente')),
      );

      // Navega de regreso a la pantalla de inventario
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const InventoryScreen(),
        ),
      );
    } catch (e) {
      // Muestra un mensaje de error si algo falla
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar el stock: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Inicializa el controlador con el stock actual del producto
    _stockController.text = widget.product.stock.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white), // Color del icono del AppBar
        // Título del AppBar
        title: const Text('Actualizar Stock', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurple, // Color personalizado del AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Muestra el nombre del producto
            Text(
              'Producto: ${widget.product.name}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Muestra el stock actual del producto
            Text(
              'Stock actual: ${widget.product.stock}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            // Campo de entrada para el nuevo stock
            TextField(
              controller: _stockController,
              decoration: InputDecoration(
                labelText: 'Nuevo Stock',
                labelStyle: const TextStyle(color: Colors.deepPurple), // Color de la etiqueta
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8), // Borde redondeado
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.deepPurple), // Borde al enfocarse
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.number, // Tipo de teclado para números
            ),
            const SizedBox(height: 20),
            // Botón para actualizar el stock
            Center(
              child: ElevatedButton.icon(
                onPressed: _updateStock,
                icon: const Icon(Icons.update), // Icono de actualización
                label: const Text('Actualizar Stock'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.deepPurple, // Color del texto
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0), // Espaciado interno
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Borde redondeado del botón
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
