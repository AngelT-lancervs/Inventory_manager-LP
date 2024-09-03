import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_manager/core/constants.dart';
import '/models/product.dart';

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
      }
    }
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
                    return CheckboxListTile(
                      title: Text(product.name),
                      value: _selectedProducts.contains(product),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedProducts.add(product);
                          } else {
                            _selectedProducts.remove(product);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _updateDraft,
                child: const Text('Actualizar Borrador'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
