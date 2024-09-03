import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_manager/core/constants.dart';
import 'package:inventory_manager/models/product.dart';

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
      // Realizar un GET para verificar el ID del borrador
      final urlGet = Uri.parse('${url_global}drafts/${widget.draft['id']}/');
      final responseGet = await http.get(urlGet);

      if (responseGet.statusCode == 200) {
        final currentDraft = json.decode(responseGet.body);

        // Modificar la información del borrador
        final updatedDraft = {
          'name': _nameController.text,
          'productsDraft':
              _selectedProducts.map((product) => product.toJson()).toList(),
        };

        // Realizar un POST con el borrador modificado
        final urlPost = Uri.parse('${url_global}drafts/');
        final headers = {'Content-Type': 'application/json'};
        final body = json.encode(updatedDraft);

        final responsePost =
            await http.post(urlPost, headers: headers, body: body);

        if (responsePost.statusCode == 200 || responsePost.statusCode == 201) {
          print('Draft actualizado exitosamente');
          Navigator.of(context)
              .pop(); // Regresa a la pantalla anterior después de actualizar el borrador
        } else {
          print('Error al actualizar draft: ${responsePost.body}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Error al actualizar el borrador: ${responsePost.body}'),
            ),
          );
        }
      } else {
        print('Error al verificar draft: ${responseGet.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Error al verificar el borrador: ${responseGet.body}'),
          ),
        );
      }
    }
  }

  // Función para modificar el producto dentro del borrador
  void _modifyProduct(Product product, int index, String action) {
    setState(() {
      int newStock = product.stock;

      if (action == 'increase') {
        newStock++;
      } else if (action == 'decrease' && newStock > 0) {
        newStock--;
      } else if (action == 'remove') {
        _selectedProducts.removeAt(index);
        return;
      }

      // Crear una nueva instancia del producto con el stock modificado
      _selectedProducts[index] = Product(
        id: product.id,
        name: product.name,
        description: product.description, // Agregar el campo description
        stock: newStock,
        price: product.price,
        checked: product.checked, // Agregar el campo checked
        // Añadir otros campos que tenga tu modelo Product
      );
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
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(product.name),
                        subtitle: Text(
                            'Stock: ${product.stock} | Precio: \$${product.price}'),
                        trailing: SizedBox(
                          width: 150,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  _modifyProduct(product, index, 'decrease');
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  _modifyProduct(product, index, 'increase');
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _modifyProduct(product, index, 'remove');
                                },
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          // Permitir la edición directa de la cantidad del producto
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Editar Producto'),
                                content: TextFormField(
                                  initialValue: product.stock.toString(),
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Cantidad',
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      int? newStock = int.tryParse(value);
                                      if (newStock != null) {
                                        _selectedProducts[index] = Product(
                                          id: product.id,
                                          name: product.name,
                                          description: product
                                              .description, // Agregar el campo description
                                          stock: newStock,
                                          price: product.price,
                                          checked: product
                                              .checked, // Agregar el campo checked
                                          // Añadir otros campos que tenga tu modelo Product
                                        );
                                      }
                                    });
                                  },
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Cancelar'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Guardar'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
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
    );
  }
}
