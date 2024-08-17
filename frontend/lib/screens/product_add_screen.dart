import 'package:flutter/material.dart';
import 'package:inventory_manager/models/product.dart';
import 'package:inventory_manager/services/api_product.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _stockController = TextEditingController();
  final _priceController = TextEditingController();

  final ApiServiceProduct apiService = ApiServiceProduct();

  void _createProduct() async {
    if (_formKey.currentState!.validate()) {
      Product newProduct = Product(
        id: 0,
        name: _nameController.text,
        description: _descriptionController.text,
        stock: int.parse(_stockController.text),
        price: double.parse(_priceController.text),
      );

      try {
        await apiService.createProduct(newProduct);
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear el producto: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || int.tryParse(value) == null) {
                    return 'Por favor ingrese un valor numérico';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null) {
                    return 'Por favor ingrese un valor numérico';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createProduct,
                child: const Text('Crear Producto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
