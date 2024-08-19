import 'product.dart';

class Draft {
  final String date;
  final String name;
  final List<Product> productsDraft;

  Draft({
    required this.date,
    required this.name,
    required this.productsDraft,
  });

  /// Método para convertir una instancia de Draft a JSON.
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'name': name,
      'productsDraft':
          productsDraft.map((product) => product.toJson()).toList(),
    };
  }

  /// Método para crear una instancia de Draft a partir de JSON.
  factory Draft.fromJson(Map<String, dynamic> json) {
    return Draft(
      date: json['date'],
      name: json['name'],
      productsDraft: List<Product>.from(
        json['productsDraft'].map((product) => Product.fromJson(product)),
      ),
    );
  }
}
