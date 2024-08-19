import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/models/draft.dart';
import '/models/product.dart';

class ProductListDraftScreen extends StatefulWidget {
  const ProductListDraftScreen({Key? key}) : super(key: key);

  @override
  _ProductListDraftScreenState createState() => _ProductListDraftScreenState();
}

class _ProductListDraftScreenState extends State<ProductListDraftScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final List<Product> _selectedProducts =
      []; // Esta lista contendrá los productos seleccionados

  Future<void> _saveDraft() async {
    if (_formKey.currentState!.validate()) {
      final draft = Draft(
        date: DateTime.now().toString(),
        name: _nameController.text,
        productsDraft: _selectedProducts,
      );

      final url = Uri.parse(
          'http://127.0.0.1:8000/drafts/'); // Asegúrate de cambiar esto por la URL correcta de tu servidor
      final headers = {'Content-Type': 'application/json'};
      final body = json.encode(draft.toJson());

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        print('Draft creado exitosamente');
        Navigator.of(context)
            .pop(); // Regresa a la pantalla anterior después de guardar el borrador
      } else {
        print('Error al crear draft: ${response.body}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Borrador'),
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
                onPressed: _saveDraft,
                child: const Text('Guardar Borrador'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
