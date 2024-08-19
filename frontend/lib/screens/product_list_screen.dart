import 'package:flutter/material.dart';
import 'package:inventory_manager/models/product.dart';
import 'package:inventory_manager/screens/product_add_screen.dart';
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

  @override
  void initState() {
    super.initState();
    futureProducts = apiService.getProducts();
  }

  void _filterProducts(bool checked){
    setState(() {
      futureProducts = apiService.getFilteredProducts(checked);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Productos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddProductScreen(),
                ),
              ).then((_) {
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
                          setState(() {
                            futureProducts = apiService.getProducts();
                          });
                        case 'checkeados':
                          _filterProducts(true);
                        case 'no-checkeados':
                          _filterProducts(false);
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
                  return const Center(child: Text('No se encontraron productos'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Product product = snapshot.data![index];
                      return ListTile(
                        title: Text(product.name),
                        subtitle: Text(
                            'Stock: ${product.stock} | Precio: \$${product.price} | Estado: ${product.state ? "Checkeado" : "No checkeado"}'),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UpdateStockScreen(product: product),
                            ),
                          ).then((_) {
                            setState(() {
                              futureProducts = apiService.getProducts();
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
    );
  }
}
