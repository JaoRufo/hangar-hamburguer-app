import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/order.dart';

class OrderService extends ChangeNotifier {
  Order? _currentOrder;
  final List<Order> _orderHistory = [];
  bool _isLoaded = false;

  Order? get currentOrder => _currentOrder;
  List<Order> get orderHistory => _orderHistory;

  // Carregar pedidos salvos localmente
  Future<void> loadOrders() async {
    if (_isLoaded) return;

    final prefs = await SharedPreferences.getInstance();
    final ordersJson = prefs.getStringList('orders') ?? [];

    _orderHistory.clear();
    for (final orderJson in ordersJson) {
      try {
        final order = Order.fromJson(json.decode(orderJson));
        _orderHistory.add(order);
      } catch (e) {
        // Ignorar pedidos com erro de parsing
      }
    }

    // Carregar pedido atual se existir
    final currentOrderJson = prefs.getString('current_order');
    if (currentOrderJson != null) {
      try {
        _currentOrder = Order.fromJson(json.decode(currentOrderJson));
      } catch (e) {
        // Ignorar se houver erro
      }
    }

    _isLoaded = true;
    notifyListeners();
  }

  // Salvar pedidos localmente
  Future<void> _saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final ordersJson = _orderHistory
        .map((order) => json.encode(order.toJson()))
        .toList();
    await prefs.setStringList('orders', ordersJson);

    // Salvar pedido atual
    if (_currentOrder != null) {
      await prefs.setString(
        'current_order',
        json.encode(_currentOrder!.toJson()),
      );
    } else {
      await prefs.remove('current_order');
    }
  }

  Future<bool> createOrder(Order order) async {
    // TODO: Integrar com backend no futuro
    // final response = await api.createOrder(order);

    await Future.delayed(const Duration(seconds: 1));

    _currentOrder = order;
    _orderHistory.add(order);
    await _saveOrders();
    notifyListeners();

    // Simular progresso do pedido
    _simulateOrderProgress();

    return true;
  }

  void _simulateOrderProgress() async {
    if (_currentOrder == null) return;

    // Pedido recebido
    await Future.delayed(const Duration(seconds: 2));
    _updateOrderStatus(OrderStatus.received);

    // Pedido aprovado
    await Future.delayed(const Duration(seconds: 3));
    _updateOrderStatus(OrderStatus.approved);

    // Pedido em preparação
    await Future.delayed(const Duration(seconds: 2));
    _updateOrderStatus(OrderStatus.preparing, estimatedTime: '30-40 min');

    // Aguarda 50 minutos para finalizar preparo
    await Future.delayed(const Duration(minutes: 1));

    // Se for entrega, muda para "Saiu para entrega"
    // Se for retirada, muda para "Pronto para retirada" (usando o mesmo enum)
    _updateOrderStatus(OrderStatus.outForDelivery);
  }

  void _updateOrderStatus(OrderStatus status, {String? estimatedTime}) async {
    if (_currentOrder == null) return;

    _currentOrder = Order(
      id: _currentOrder!.id,
      items: _currentOrder!.items,
      subtotal: _currentOrder!.subtotal,
      deliveryFee: _currentOrder!.deliveryFee,
      total: _currentOrder!.total,
      deliveryType: _currentOrder!.deliveryType,
      status: status,
      createdAt: _currentOrder!.createdAt,
      estimatedTime: estimatedTime ?? _currentOrder!.estimatedTime,
    );

    // Atualizar no histórico
    final index = _orderHistory.indexWhere(
      (order) => order.id == _currentOrder!.id,
    );
    if (index != -1) {
      _orderHistory[index] = _currentOrder!;
    }

    await _saveOrders();
    notifyListeners();
  }

  void cancelOrder(String orderId) {
    if (_currentOrder?.id == orderId) {
      _updateOrderStatus(OrderStatus.cancelled);
    }
  }

  void clearCurrentOrder() async {
    _currentOrder = null;
    await _saveOrders();
    notifyListeners();
  }
}
