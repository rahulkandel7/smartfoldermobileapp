import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:justsanppit/constants/app_routes.dart';
import 'package:justsanppit/features/auth/presentation/screens/login_screen.dart';
import 'package:justsanppit/features/auth/presentation/screens/register_screen.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.grey,
          errorColor: Colors.red,
        ),
        scaffoldBackgroundColor: Colors.grey.shade900,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              width: 0.5,
              color: Colors.grey.shade500,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              width: 0.5,
              color: Colors.grey.shade500,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              width: 1,
              color: Colors.red.shade400,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              width: 1,
              color: Colors.grey.shade500,
            ),
          ),
          prefixIconColor: Colors.grey.shade300,
          labelStyle: TextStyle(
            color: Colors.grey.shade300,
          ),
          alignLabelWithHint: true,
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              width: 1,
              color: Colors.red.shade400,
            ),
          ),
          errorStyle: TextStyle(
            color: Colors.red.shade300,
          ),
        ),
      ),
      home: const LoginScreen(),
      routes: {
        AppRoutes.login: (ctx) => const LoginScreen(),
        AppRoutes.register: (ctx) => const RegisterScreen(),
      },
    );
  }
}
