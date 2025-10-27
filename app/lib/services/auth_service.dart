import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  final List<Map<String, String>> _registeredUsers = [];

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;

  // Carregar usuários registrados
  Future<void> _loadRegisteredUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList('registered_users') ?? [];
    _registeredUsers.clear();
    for (final userJson in usersJson) {
      try {
        final userData = json.decode(userJson) as Map<String, dynamic>;
        _registeredUsers.add({
          'email': userData['email'],
          'password': userData['password'],
          'name': userData['name'],
          'phone': userData['phone'],
          'address': userData['address'],
        });
      } catch (e) {
        // Ignorar usuários com erro
      }
    }
  }

  // Salvar usuários registrados
  Future<void> _saveRegisteredUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = _registeredUsers
        .map((user) => json.encode(user))
        .toList();
    await prefs.setStringList('registered_users', usersJson);
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await _loadRegisteredUsers();
    await Future.delayed(const Duration(seconds: 1));

    // Verificar usuário admin padrão
    if (email == 'admin@hangar.com' && password == '123456') {
      _currentUser = User(
        id: '1',
        name: 'Admin',
        email: email,
        phone: '(11) 99999-9999',
        address: 'Rua do Hangar, 123',
      );
      await _saveUserToPrefs();
      _isLoading = false;
      notifyListeners();
      return true;
    }

    // Verificar usuários registrados
    for (final user in _registeredUsers) {
      if (user['email'] == email && user['password'] == password) {
        _currentUser = User(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: user['name']!,
          email: user['email']!,
          phone: user['phone']!,
          address: user['address']!,
        );
        await _saveUserToPrefs();
        _isLoading = false;
        notifyListeners();
        return true;
      }
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register(
    String name,
    String email,
    String password,
    String phone,
    String address,
  ) async {
    _isLoading = true;
    notifyListeners();

    await _loadRegisteredUsers();
    await Future.delayed(const Duration(seconds: 1));

    // Verificar se email já existe
    for (final user in _registeredUsers) {
      if (user['email'] == email) {
        _isLoading = false;
        notifyListeners();
        return false; // Email já cadastrado
      }
    }

    // Adicionar novo usuário
    _registeredUsers.add({
      'email': email,
      'password': password,
      'name': name,
      'phone': phone,
      'address': address,
    });

    await _saveRegisteredUsers();

    _currentUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      phone: phone,
      address: address,
    );

    await _saveUserToPrefs();
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    // Limpar dados do usuário (pedidos ficam salvos para quando logar novamente)
    // TODO: No futuro, implementar logout no backend
    notifyListeners();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      _currentUser = User.fromJson(json.decode(userJson));
      notifyListeners();
    }
  }

  Future<bool> updateProfile(
    String name,
    String email,
    String phone,
    String address,
  ) async {
    if (_currentUser == null) return false;

    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _currentUser = User(
      id: _currentUser!.id,
      name: name,
      email: email,
      phone: phone,
      address: address,
    );

    await _saveUserToPrefs();
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> _saveUserToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', json.encode(_currentUser!.toJson()));
  }
}
