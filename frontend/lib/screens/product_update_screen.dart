import 'package:flutter/material.dart';
import 'package:inventory_manager/models/product.dart';
import 'package:inventory_manager/screens/product_list_screen.dart';
import 'package:inventory_manager/services/api_product.dart';

class UpdateStockScreen extends StatefulWidget {
  final Product product;

  const UpdateStockScreen({super.key, required this.product});

  @override
  UpdateStockScreenState createState() => UpdateStockScreenState();
}

class UpdateStockScreenState extends State<UpdateStockScreen> {
  final _stockController = TextEditingController();

  final ApiServiceProduct apiService = ApiServiceProduct();

  void _updateStock() async {
    try {
      int newStock = int.parse(_stockController.text);
      await apiService.updateStock(widget.product.id, newStock);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ProductListScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar el stock: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _stockController.text = widget.product.stock.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actualizar Stock de ${widget.product.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _stockController,
              decoration: const InputDecoration(labelText: 'Nuevo Stock'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateStock,
              child: const Text('Actualizar Stock'),
            ),
          ],
        ),
      ),
    );
  }
}
