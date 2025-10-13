import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/order_service.dart';
import '../models/order.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderService>(context, listen: false).loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: const Color(0xFF87CEEB),
        foregroundColor: Colors.white,
      ),
      body: Consumer<AuthService>(
        builder: (context, authService, child) {
          if (authService.currentUser == null) {
            return const Center(child: Text('Usuário não logado'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildUserInfo(context, authService),
                const SizedBox(height: 24),
                _buildMenuOptions(context, authService),
                const SizedBox(height: 24),
                _buildCurrentOrder(context),
                const SizedBox(height: 24),
                _buildOrderHistory(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, AuthService authService) {
    final user = authService.currentUser!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: const Color(0xFF87CEEB),
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                style: const TextStyle(fontSize: 32, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              user.email,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOptions(BuildContext context, AuthService authService) {
    return Column(
      children: [
        _buildMenuTile(
          icon: Icons.edit,
          title: 'Editar Perfil',
          onTap: () => _showEditProfileDialog(context, authService),
        ),
        _buildMenuTile(
          icon: Icons.location_on,
          title: 'Endereços',
          onTap: () => _showAddressDialog(context, authService),
        ),
        _buildMenuTile(
          icon: Icons.help,
          title: 'Ajuda',
          onTap: () => _showHelpDialog(context),
        ),
        _buildMenuTile(
          icon: Icons.logout,
          title: 'Sair',
          onTap: () => _showLogoutDialog(context, authService),
        ),
      ],
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF87CEEB)),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildCurrentOrder(BuildContext context) {
    return Consumer<OrderService>(
      builder: (context, orderService, child) {
        if (orderService.currentOrder == null) {
          return const SizedBox.shrink();
        }

        final order = orderService.currentOrder!;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pedido Atual',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '#${order.id}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildOrderStatus(order.status, order),
                if (order.estimatedTime != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Tempo estimado: ${order.estimatedTime}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
                const SizedBox(height: 16),
                Text(
                  'Total: R\$ ${order.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderStatus(OrderStatus status, [Order? order]) {
    String statusText;
    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case OrderStatus.pending:
        statusText = 'Aguardando confirmação';
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
      case OrderStatus.received:
        statusText = 'Pedido recebido';
        statusColor = Colors.blue;
        statusIcon = Icons.receipt;
        break;
      case OrderStatus.approved:
        statusText = 'Pedido aprovado';
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case OrderStatus.preparing:
        statusText = 'Em preparação';
        statusColor = Colors.amber;
        statusIcon = Icons.restaurant;
        break;
      case OrderStatus.outForDelivery:
        // Verificar se é retirada ou entrega
        if (order?.deliveryType == 'Retirada') {
          statusText = 'Pedido pronto para retirada';
          statusColor = Colors.green;
          statusIcon = Icons.store;
        } else {
          statusText = 'Saiu para entrega';
          statusColor = Colors.purple;
          statusIcon = Icons.delivery_dining;
        }
        break;
      case OrderStatus.delivered:
        statusText = 'Entregue';
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case OrderStatus.cancelled:
        statusText = 'Cancelado';
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusText = 'Rejeitado';
        statusColor = Colors.red;
        statusIcon = Icons.error;
    }

    return Row(
      children: [
        Icon(statusIcon, color: statusColor, size: 20),
        const SizedBox(width: 8),
        Text(
          statusText,
          style: TextStyle(color: statusColor, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildOrderHistory(BuildContext context) {
    return Consumer<OrderService>(
      builder: (context, orderService, child) {
        if (orderService.orderHistory.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.history, size: 48, color: Colors.grey),
                  const SizedBox(height: 8),
                  const Text(
                    'Nenhum pedido realizado',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Histórico de Pedidos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...orderService.orderHistory
                .map(
                  (order) => Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFF87CEEB),
                        child: Text(
                          '#${order.id.substring(0, 2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      title: Text('Pedido #${order.id}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('R\$ ${order.total.toStringAsFixed(2)}'),
                          _buildOrderStatus(order.status, order),
                        ],
                      ),
                      trailing: Text(
                        '${order.createdAt.day}/${order.createdAt.month}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      onTap: () => _showOrderDetails(context, order),
                    ),
                  ),
                )
                .toList(),
          ],
        );
      },
    );
  }

  void _showEditProfileDialog(BuildContext context, AuthService authService) {
    final user = authService.currentUser!;
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    final phoneController = TextEditingController(text: user.phone);
    final addressController = TextEditingController(text: user.address);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Perfil'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Telefone'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Endereço'),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await authService.updateProfile(
                nameController.text,
                emailController.text,
                phoneController.text,
                addressController.text,
              );

              if (success && context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Perfil atualizado com sucesso!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _showAddressDialog(BuildContext context, AuthService authService) {
    final user = authService.currentUser!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Endereço'),
        content: Text(user.address),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showEditProfileDialog(context, authService);
            },
            child: const Text('Editar'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajuda'),
        content: const Text(
          'Para dúvidas ou suporte, entre em contato:\n\n'
          'WhatsApp: (11) 99999-9999\n'
          'Email: suporte@hangar.com\n\n'
          'Horário de funcionamento:\n'
          'Segunda a Domingo: 18h às 23h',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthService authService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Deseja realmente sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              authService.logout();
              Navigator.pop(context);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }

  void _showOrderDetails(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pedido #${order.id}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Data: ${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}',
              ),
              const SizedBox(height: 8),
              _buildOrderStatus(order.status, order),
              const SizedBox(height: 16),
              const Text(
                'Itens:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...order.items
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${item.quantity}x ${item.product.name}',
                            ),
                          ),
                          Text('R\$ ${item.totalPrice.toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'R\$ ${order.total.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}
