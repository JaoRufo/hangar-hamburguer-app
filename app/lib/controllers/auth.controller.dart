import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService;
  bool _isLoading = false;

  User? get currentUser => _authService.currentUser;
  bool get isAuthenticated => _authService.currentUser != null;
  bool get isLoading => _isLoading;

  AuthController(this._authService);

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    debugPrint('[AuthController] Tentando login...');
    final result = await _authService.login(email, password);
    _isLoading = false;
    notifyListeners();
    return result;
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
    debugPrint('[AuthController] Tentando registro...');
    final result = await _authService.register(
      name,
      email,
      password,
      phone,
      address,
    );
    _isLoading = false;
    notifyListeners();
    return result;
  }

  Future<void> logout() async {
    debugPrint('[AuthController] Logout...');
    await _authService.logout();
    notifyListeners();
  }

  Future<bool> updateProfile(
    String name,
    String email,
    String phone,
    String address,
  ) async {
    debugPrint('[AuthController] Atualizando perfil...');
    final result = await _authService.updateProfile(
      name,
      email,
      phone,
      address,
    );
    notifyListeners();
    return result;
  }
}
