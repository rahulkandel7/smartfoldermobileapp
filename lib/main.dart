import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:justsanppit/constants/app_routes.dart';
import 'package:justsanppit/features/assets/presentation/screens/asset_screen.dart';
import 'package:justsanppit/features/auth/presentation/screens/forget_change_password.dart';
import 'package:justsanppit/features/auth/presentation/screens/forget_otp.dart';
import 'package:justsanppit/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:justsanppit/features/auth/presentation/screens/login_screen.dart';
import 'package:justsanppit/features/auth/presentation/screens/register_screen.dart';
import 'package:justsanppit/features/items/presentation/screens/image_view.dart';
import 'package:justsanppit/features/items/presentation/screens/item_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const ProviderScope(child: MainApp()));
  });
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
        textTheme: TextTheme(
          bodyLarge: TextStyle(
            color: Colors.grey.shade300,
          ),
        ),
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
      debugShowCheckedModeBanner: false,
      routes: {
        AppRoutes.login: (ctx) => const LoginScreen(),
        AppRoutes.register: (ctx) => const RegisterScreen(),
        AppRoutes.forgetChangePassword: (ctx) => const ForgetChangePassword(),
        AppRoutes.forgetPasswordScreen: (ctx) => const ForgetPasswordScreen(),
        AppRoutes.otp: (ctx) => const ForgetOtp(),
        AppRoutes.assetScreen: (ctx) => AssetScreen(),
        AppRoutes.itemScreen: (ctx) => ItemScreen(),
        AppRoutes.imageView: (ctx) => const ImageView(),
      },
    );
  }
}
