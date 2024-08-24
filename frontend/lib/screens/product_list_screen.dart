import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_manager/core/constants.dart';
import 'package:inventory_manager/models/product.dart';
import 'package:inventory_manager/screens/product_add_screen.dart';
import 'package:inventory_manager/screens/product_list_draft_screen.dart';
import 'package:inventory_manager/screens/draft_list_screen.dart';
import 'package:inventory_manager/screens/product_update_screen.dart';
import 'package:inventory_manager/services/api_product.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  ProductListScreenState createState() => ProductListScreenState();
}

class ProductListScreenState extends State<ProductListScreen> {
  final ApiServiceProduct apiService = ApiServiceProduct();
  late Future<List<Product>> futureProducts;
  String? _selectedFilter;
  List<Product> displayedProducts = [];

  @override
  void initState() {
    super.initState();
    futureProducts = apiService.getProducts();
  }

  void _filterProducts(bool checked) {
    setState(() {
      futureProducts = apiService.getFilteredProducts(checked);
    });
  }

  Future<void> _saveDraft(String name) async {
    final draft = {
      'name': name,
      'productsDraft':
          displayedProducts.map((product) => product.toJson()).toList(),
    };

    final url = Uri.parse(
        '${url_global}drafts/'); // Reemplaza con la URL de tu servidor
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode(draft);

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      print('Draft creado exitosamente');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ProductListDraftScreen(),
        ),
      );
    } else {
      print('Error al crear draft: ${response.body}');
    }
  }

  Future<void> _showNameDialog() async {
    final TextEditingController _nameController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nombre del Borrador'),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(
                hintText: "Ingrese el nombre del borrador"),
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
                if (_nameController.text.isNotEmpty) {
                  _saveDraft(_nameController.text);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Lista de Productos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) => const AddProductScreen(),
                ),
              )
                  .then((_) {
                setState(() {
                  futureProducts = apiService.getProducts();
                });
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Filtro:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedFilter,
                  hint: const Text('Seleccione un filtro'),
                  items: <String>['Todos', 'checkeados', 'no-checkeados']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedFilter = newValue;
                      switch (_selectedFilter) {
                        case 'Todos':
                          futureProducts = apiService.getProducts();
                          break;
                        case 'checkeados':
                          _filterProducts(true);
                          break;
                        case 'no-checkeados':
                          _filterProducts(false);
                          break;
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No se encontraron productos'));
                } else {
                  // Aquí almacenamos los productos mostrados
                  displayedProducts = snapshot.data!;
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Product product = snapshot.data![index];
                      return ListTile(
                        title: Text(product.name),
                        subtitle: Text(
                          'Stock: ${product.stock} | Precio: \$${product.price} | Estado: ${product.checked ? 'Checkeado' : 'No checkeado'}',
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  UpdateStockScreen(product: product),
                            ),
                          )
                              .then((_) {
                            setState(() {
                              // Recarga los productos después de la actualización
                              if (_selectedFilter == 'Todos') {
                                futureProducts = apiService.getProducts();
                              } else if (_selectedFilter == 'checkeados') {
                                _filterProducts(true);
                              } else if (_selectedFilter == 'no-checkeados') {
                                _filterProducts(false);
                              }
                            });
                          });
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                _showNameDialog(); // Muestra el cuadro de diálogo para ingresar el nombre
              },
              child: const Text('Guardar borrador'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DraftListScreen(),
                  ),
                );
              },
              child: const Text('Ver Borradores Guardados'),
            ),
          ],
        ),
      ),
    );
  }
}
