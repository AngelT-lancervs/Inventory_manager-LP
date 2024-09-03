import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_manager/core/constants.dart';
import 'package:inventory_manager/models/product.dart';
import 'package:inventory_manager/services/api_product.dart';
import 'package:inventory_manager/screens/product_add_screen.dart';
import 'package:inventory_manager/screens/product_update_screen.dart';

class DraftProductEditScreen extends StatefulWidget {
  final Map<String, dynamic> draft;

  const DraftProductEditScreen({super.key, required this.draft});

  @override
  _DraftProductEditScreenState createState() => _DraftProductEditScreenState();
}

class _DraftProductEditScreenState extends State<DraftProductEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late List<Product> _selectedProducts;
  final ApiServiceProduct apiService = ApiServiceProduct();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.draft['name']);
    _selectedProducts = (widget.draft['productsDraft'] as List<dynamic>)
        .map((product) => Product.fromJson(product))
        .toList();
  }

  // Función para actualizar el borrador
  Future<void> _updateDraft() async {
    if (_formKey.currentState!.validate()) {
      final updatedDraft = {
        'name': _nameController.text,
        'productsDraft':
            _selectedProducts.map((product) => product.toJson()).toList(),
      };

      final url = Uri.parse(
          '${url_global}drafts/${widget.draft['id']}/'); // URL para actualizar el borrador
      final headers = {'Content-Type': 'application/json'};
      final body = json.encode(updatedDraft);

      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Draft actualizado exitosamente');
        Navigator.of(context)
            .pop(); // Regresa a la pantalla anterior después de actualizar el borrador
      } else {
        print('Error al actualizar draft: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Error al actualizar el borrador: ${response.body}')),
        );
      }
    }
  }

  // Función para agregar un nuevo producto a la lista de seleccionados
  void _addProduct(Product product) {
    setState(() {
      _selectedProducts.add(product);
    });
  }

  // Función para eliminar un producto de la lista de seleccionados
  void _removeProduct(Product product) {
    setState(() {
      _selectedProducts.remove(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Borrador'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del Borrador',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: ListView.builder(
                  itemCount: _selectedProducts.length,
                  itemBuilder: (context, index) {
                    final product = _selectedProducts[index];
                    return Dismissible(
                      key: Key(product.id.toString()),
                      onDismissed: (direction) {
                        _removeProduct(product);
                      },
                      background: Container(color: Colors.red),
                      child: ListTile(
                        title: Text(product.name),
                        subtitle: Text(
                            'Stock: ${product.stock} | Precio: \$${product.price}'),
                        onTap: () {
                          // Navegar a la pantalla de actualización de stock
                          Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  UpdateStockScreen(product: product),
                            ),
                          )
                              .then((_) {
                            // Recargar productos después de la actualización
                            setState(() {
                              // Aquí puedes actualizar el producto en la lista de borradores
                              _selectedProducts[index] = product;
                            });
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _updateDraft,
                child: const Text('Actualizar Borrador'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navegar a la pantalla de agregar producto
          await Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => const AddProductScreen(),
            ),
          )
              .then((newProduct) {
            // Verificar si se ha creado un nuevo producto y agregarlo al borrador
            if (newProduct != null && newProduct is Product) {
              _addProduct(newProduct);
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
