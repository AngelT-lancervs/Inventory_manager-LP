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
    // Cargar productos desde la API al iniciar la pantalla
    futureProducts = apiService.getProducts();
  }

  // Función para filtrar productos según su estado (checkeado o no)
  void _filterProducts(bool checked) {
    setState(() {
      futureProducts = apiService.getFilteredProducts(checked);
    });
  }

  // Función para guardar un borrador de productos
  Future<void> _saveDraft(String name) async {
    final draft = {
      'name': name,
      'productsDraft':
          displayedProducts.map((product) => product.toJson()).toList(),
    };

    final url = Uri.parse('${url_global}drafts/'); // URL de la API para guardar borradores
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

  // Función para mostrar un diálogo donde se ingresa el nombre del borrador
  Future<void> _showNameDialog() async {
    final TextEditingController nameController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nombre del Borrador'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: "Ingrese el nombre del borrador",
              border: OutlineInputBorder(),
            ),
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
                if (nameController.text.isNotEmpty) {
                  _saveDraft(nameController.text);
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
        automaticallyImplyLeading: false, // Oculta el botón de regresar
        title: const Text('Lista de Productos'),
        actions: [
          // Botón para agregar un nuevo producto
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
                // Recargar los productos después de agregar uno nuevo
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
                // Dropdown para seleccionar el filtro de productos
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
            // Construir la lista de productos basados en el futuro cargado
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
                  // Almacena los productos mostrados actualmente
                  displayedProducts = snapshot.data!;
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Product product = snapshot.data![index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text(
                            product.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Stock: ${product.stock} | Precio: \$${product.price} | Estado: ${product.checked ? 'Checkeado' : 'No checkeado'}',
                          ),
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
                        ),
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
            // Botón para guardar un borrador de la lista de productos
            ElevatedButton(
              onPressed: () async {
                _showNameDialog(); // Muestra el cuadro de diálogo para ingresar el nombre del borrador
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Guardar borrador'),
            ),
            const SizedBox(height: 10),
            // Botón para ver los borradores guardados
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DraftListScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Ver Borradores Guardados'),
            ),
          ],
        ),
      ),
    );
  }
}
