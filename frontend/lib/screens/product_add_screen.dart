import 'package:flutter/material.dart';
import 'package:inventory_manager/models/product.dart';
import 'package:inventory_manager/services/api_product.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  AddProductScreenState createState() => AddProductScreenState();
}

class AddProductScreenState extends State<AddProductScreen> {
  // Clave global para el formulario
  final _formKey = GlobalKey<FormState>();
  
  // Controladores de texto para los campos del formulario
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _stockController = TextEditingController();
  final _priceController = TextEditingController();
  
  // Estado del producto (Checkeado/No Checkeado)
  bool _stateChecked = false; 

  // Servicio API para manejar productos
  final ApiServiceProduct apiService = ApiServiceProduct();

  // Función para crear un nuevo producto
  void _createProduct() async {
    // Valida el formulario antes de proceder
    if (_formKey.currentState!.validate()) {
      Product newProduct = Product(
        id: 0,
        name: _nameController.text,
        description: _descriptionController.text,
        stock: int.parse(_stockController.text),
        price: double.parse(_priceController.text),
        checked: _stateChecked, // Incluye el estado del producto
      );

      try {
        await apiService.createProduct(newProduct);
        Navigator.of(context).pop(); // Regresa a la pantalla anterior al finalizar
      } catch (e) {
        // Muestra un mensaje de error si la creación falla
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
        iconTheme: const IconThemeData(color: Colors.white), // Color del icono del AppBar
        title: const Text('Agregar Producto', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurple, // Color personalizado del AppBar
      ),
      body: SingleChildScrollView( // Permite desplazarse si el teclado cubre los campos
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Asocia la clave global al formulario
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre', 
                  border: OutlineInputBorder(), // Añade borde al campo de texto
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción', 
                  border: OutlineInputBorder(), // Añade borde al campo de texto
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(
                  labelText: 'Stock',
                  border: OutlineInputBorder(), // Añade borde al campo de texto
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || int.tryParse(value) == null) {
                    return 'Por favor ingrese un valor numérico';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Precio',
                  border: OutlineInputBorder(), // Añade borde al campo de texto
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null) {
                    return 'Por favor ingrese un valor numérico';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Checkeado'),
                value: _stateChecked,
                onChanged: (bool? value) {
                  setState(() {
                    _stateChecked = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading, // Posiciona la caja de verificación a la izquierda
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _createProduct,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.deepPurple, // Color del texto del botón
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Borde redondeado del botón
                    ),
                  ),
                  child: const Text('Crear Producto', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
