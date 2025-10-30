import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService extends ChangeNotifier {
  static const String baseUrl =
      "https://hangar-do-hamburguer-backend.onrender.com/auth";

  User? currentUser;
  String? _token;

  bool get isLoggedIn => currentUser != null;

  Future<bool> login(String email, String password) async {
    debugPrint('[AuthService] POST /auth/login');

    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      _token = data["token"];
      currentUser = User.fromJson(data["user"]);

      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("auth_user", jsonEncode(data["user"]));
        await prefs.setString("auth_token", _token!);
        debugPrint('[AuthService] ✅ Dados salvos no storage');
      } catch (e) {
        debugPrint('[AuthService] ❌ Erro ao salvar dados: $e');
      }

      notifyListeners();
      debugPrint('[AuthService] ✅ Login ok');
      return true;
    }

    debugPrint('[AuthService] ❌ Erro no login: ${response.body}');
    return false;
  }

  Future<bool> register(
    String name,
    String email,
    String password,
    String phone,
    String address,
  ) async {
    debugPrint('[AuthService] POST /auth/register');

    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
        "address": address,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);

      _token = data["token"];
      currentUser = User.fromJson(data["user"]);

      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("auth_user", jsonEncode(data["user"]));
        await prefs.setString("auth_token", _token!);
        debugPrint('[AuthService] ✅ Dados do registro salvos no storage');
      } catch (e) {
        debugPrint('[AuthService] ❌ Erro ao salvar dados do registro: $e');
      }

      notifyListeners();
      debugPrint('[AuthService] ✅ Registrado com sucesso');
      return true;
    }

    debugPrint('[AuthService] ❌ Erro no registro: ${response.body}');
    return false;
  }

  Future<bool> updateProfile(
    String name,
    String email,
    String phone,
    String address,
  ) async {
    debugPrint('[AuthService] PUT /auth/update');

    if (_token == null) return false;

    currentUser = User(
      id: currentUser!.id,
      name: name,
      email: email,
      phone: phone,
      address: address,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("auth_user", jsonEncode(currentUser!.toJson()));

    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("auth_user");
    await prefs.remove("auth_token");
    _token = null;
    currentUser = null;
    notifyListeners();
  }

  Future<void> loadUserFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString("auth_user");
      final token = prefs.getString("auth_token");

      debugPrint('[AuthService] Carregando dados salvos...');
      debugPrint('[AuthService] User data: $userData');
      debugPrint('[AuthService] Token: ${token != null ? 'existe' : 'null'}');

      if (userData != null && token != null) {
        currentUser = User.fromJson(jsonDecode(userData));
        _token = token;
        debugPrint('[AuthService] ✅ Usuário carregado: ${currentUser?.name}');
        notifyListeners();
      } else {
        debugPrint('[AuthService] ❌ Nenhum dado salvo encontrado');
      }
    } catch (e) {
      debugPrint('[AuthService] ❌ Erro ao carregar dados: $e');
    }
  }

  Future<void> loadUser() async {
    await loadUserFromStorage();
  }
}
