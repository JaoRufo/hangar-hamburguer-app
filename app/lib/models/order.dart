import 'cart_item.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String deliveryType;
  final OrderStatus status;
  final DateTime createdAt;
  final String? estimatedTime;

  Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.deliveryType,
    required this.status,
    required this.createdAt,
    this.estimatedTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'total': total,
      'deliveryType': deliveryType,
      'status': status.toString(),
      'createdAt': createdAt.toIso8601String(),
      'estimatedTime': estimatedTime,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      subtotal: json['subtotal'].toDouble(),
      deliveryFee: json['deliveryFee'].toDouble(),
      total: json['total'].toDouble(),
      deliveryType: json['deliveryType'],
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
      ),
      createdAt: DateTime.parse(json['createdAt']),
      estimatedTime: json['estimatedTime'],
    );
  }
}

enum OrderStatus {
  pending,
  received,
  approved,
  rejected,
  preparing,
  outForDelivery,
  delivered,
  cancelled,
}
