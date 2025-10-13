import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cart_service.dart';
import '../services/order_service.dart';
import '../models/order.dart';
import 'delivery_option_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carrinho')),
      body: Consumer<CartService>(
        builder: (context, cartService, child) {
          if (cartService.items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Seu carrinho está vazio',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cartService.items.length,
                  itemBuilder: (context, index) {
                    final item = cartService.items[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey[200],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  item.product.image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.fastfood,
                                      color: Colors.grey,
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'R\$ ${item.product.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Color(0xFF87CEEB),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    cartService.decrementItem(item.product.id);
                                  },
                                  icon: const Icon(Icons.remove_circle_outline),
                                  color: Colors.red,
                                ),
                                Text(
                                  '${item.quantity}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    cartService.addItem(item.product);
                                  },
                                  icon: const Icon(Icons.add_circle_outline),
                                  color: const Color(0xFF87CEEB),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'R\$ ${cartService.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF87CEEB),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _showDeliveryOptions(context, cartService);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF87CEEB),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Finalizar Pedido',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDeliveryOptions(BuildContext context, CartService cartService) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeliveryOptionScreen(
          totalAmount: cartService.totalPrice,
          onPickup: () => _finalizeOrder(context, cartService, 'Retirada', 0.0),
          onDelivery: () => _finalizeOrder(context, cartService, 'Entrega', 6.0),
        ),
      ),
    );
  }

  void _finalizeOrder(BuildContext context, CartService cartService, String deliveryType, double deliveryFee) async {
    final orderService = Provider.of<OrderService>(context, listen: false);
    
    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: cartService.items,
      subtotal: cartService.totalPrice,
      deliveryFee: deliveryFee,
      total: cartService.totalPrice + deliveryFee,
      deliveryType: deliveryType,
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
    );
    
    await orderService.createOrder(order);
    cartService.clear();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pedido realizado com sucesso! Tipo: $deliveryType'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
