import 'package:flutter/material.dart';

class DeliveryOptionScreen extends StatelessWidget {
  final double totalAmount;
  final VoidCallback onPickup;
  final VoidCallback onDelivery;

  const DeliveryOptionScreen({
    super.key,
    required this.totalAmount,
    required this.onPickup,
    required this.onDelivery,
  });

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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Opção Retirada
            Card(
              child: ListTile(
                leading: const Icon(Icons.store, color: Color(0xFF87CEEB)),
                title: const Text('Retirada no Local'),
                subtitle: Text(
                  'Total: R\$ ${totalAmount.toStringAsFixed(2)} (Travessa N, nº 11222 Jd Boa Vista)',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _showConfirmationDialog(context, 'Retirada', onPickup);
                },
              ),
            ),
            const SizedBox(height: 16),

            // Opção Entrega
            Card(
              child: ListTile(
                leading: const Icon(Icons.motorcycle, color: Color(0xFF87CEEB)),
                title: const Text('Entrega'),
                subtitle: Text(
                  'Total: R\$ ${(totalAmount + deliveryFee).toStringAsFixed(2)} (+ R\$ ${deliveryFee.toStringAsFixed(2)} taxa)',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _showConfirmationDialog(context, 'Entrega', onDelivery);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(
    BuildContext context,
    String deliveryType,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Pedido Confirmado!'),
          content: Text(
            'Seu pedido foi confirmado com sucesso!\nTipo: $deliveryType',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Fecha o diálogo
                Navigator.of(context).pop(); // Fecha a tela atual
                onConfirm();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
