class Product {
  final int id;
  final String name;
  final String description;
  final int stock;
  final double price;
  final bool checked;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.stock,
    required this.price,
    required this.checked,
  });

  /// Método para crear una instancia de Product a partir de JSON.
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      stock: json['stock'],
      price: json['price'].toDouble(),
      checked: json['checked'] ?? false,  // Asigna false si checked es null
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
      'checked': checked,
    };
  }
}
