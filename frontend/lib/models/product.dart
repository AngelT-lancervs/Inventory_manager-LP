class Product {
  final int id;
  final String name;
  final String description;
  final int stock;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.stock,
    required this.price,
  });

  /// Método para crear una instancia de Product a partir de JSON.
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      stock: json['stock'],
      price: json['price'].toDouble(),
    );
  }

  /// Método para convertir una instancia de Product a JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'stock': stock,
      'price': price,
    };
  }
}
