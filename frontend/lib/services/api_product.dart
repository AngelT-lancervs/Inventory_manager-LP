// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiServiceProduct {
  final String baseUrl = "http://192.168.1.4:8000/api/"; 
  /// Método para obtener la lista de productos.
  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('${baseUrl}products/'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<Product> products = body.map((dynamic item) => Product.fromJson(item)).toList();
      return products;
    } else {
      throw Exception("Error al cargar los productos");
    }
  }

  /// Método para crear un nuevo producto.
  Future<Product> createProduct(Product product) async {
    final response = await http.post(
      Uri.parse('${baseUrl}products/create/'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(product.toJson()),
    );

    if (response.statusCode == 201) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception("Error al crear el producto");
    }
  }

  /// Método para actualizar el stock de un producto.
  Future<void> updateStock(int productId, int newStock) async {
    final response = await http.put(
      Uri.parse('${baseUrl}products/$productId/update-stock/'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"stock": newStock}),
    );

    if (response.statusCode != 200) {
      throw Exception("Error al actualizar el stock");
    }
  }
}
