import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:hangar_do_hamburguer/controllers/auth.controller.dart';
import 'package:provider/provider.dart';

import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

import 'services/auth_service.dart';
import 'services/cart_service.dart';
import 'services/order_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Configurar cores da barra de status e navegação apenas no mobile
    if (!kIsWeb) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Color(0xFF87CEEB),
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Color(0xFF87CEEB),
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );
    }

    return MultiProvider(
      providers: [
        // ✅ AuthService agora carrega usuário salvo no SharedPreferences
        ChangeNotifierProvider(
          create: (_) {
            final authService = AuthService();
            // Carregar dados salvos após a inicialização
            WidgetsBinding.instance.addPostFrameCallback((_) {
              authService.loadUserFromStorage();
            });
            return authService;
          },
        ),

        // ✅ AuthController depende do AuthService
        ChangeNotifierProxyProvider<AuthService, AuthController>(
          create: (_) => AuthController(AuthService()),
          update: (context, authService, _) => AuthController(authService),
        ),

        ChangeNotifierProvider(create: (_) => CartService()),
        ChangeNotifierProvider(create: (_) => OrderService()),
      ],
      child: MaterialApp(
        title: 'Hangar do Hamburguer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          primaryColor: const Color(0xFF87CEEB),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF87CEEB),
            foregroundColor: Colors.white,
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Color(0xFF87CEEB),
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarColor: Color(0xFF87CEEB),
              systemNavigationBarIconBrightness: Brightness.light,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF87CEEB),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color(0xFF87CEEB),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
          ),
          inputDecorationTheme: InputDecorationTheme(
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF87CEEB)),
              borderRadius: BorderRadius.circular(12),
            ),
            labelStyle: const TextStyle(color: Color(0xFF87CEEB)),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF87CEEB),
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}
