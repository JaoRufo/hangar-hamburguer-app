import 'product.dart';

class CartItem {
  final Product product;
  int quantity;
  final List<String> observations;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.observations = const [],
  });

  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'observations': observations,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
      observations: List<String>.from(json['observations']),
    );
  }
}