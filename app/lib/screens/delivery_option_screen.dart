import 'package:flutter/material.dart';

class DeliveryOptionScreen extends StatelessWidget {
  final double totalAmount;
  final VoidCallback onPickup;
  final VoidCallback onDelivery;

  const DeliveryOptionScreen({
    Key? key,
    required this.totalAmount,
    required this.onPickup,
    required this.onDelivery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const deliveryFee = 6.00;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forma de Entrega'),
        backgroundColor: const Color(0xFF87CEEB),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.delivery_dining,
              size: 80,
              color: Color(0xFF87CEEB),
            ),
            const SizedBox(height: 24),
            const Text(
              'Como você deseja receber seu pedido?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            
            // Opção Retirada
            Card(
              child: ListTile(
                leading: const Icon(Icons.store, color: Color(0xFF87CEEB)),
                title: const Text('Retirada no Local'),
                subtitle: Text('Total: R\$ ${totalAmount.toStringAsFixed(2)}'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pop(context);
                  onPickup();
                },
              ),
            ),
            const SizedBox(height: 16),
            
            // Opção Entrega
            Card(
              child: ListTile(
                leading: const Icon(Icons.motorcycle, color: Color(0xFF87CEEB)),
                title: const Text('Entrega'),
                subtitle: Text('Total: R\$ ${(totalAmount + deliveryFee).toStringAsFixed(2)} (+ R\$ ${deliveryFee.toStringAsFixed(2)} taxa)'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pop(context);
                  onDelivery();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}