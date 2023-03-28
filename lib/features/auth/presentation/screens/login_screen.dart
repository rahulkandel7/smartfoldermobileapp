import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:justsanppit/constants/app_routes.dart';

import '../../../../core/utils/form_field.dart';
import '../../../../core/utils/toast.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // * Defining Login Scaffold Key
  final GlobalKey<ScaffoldState> _loginScaffoldKey = GlobalKey<ScaffoldState>();
  final loginKey = GlobalKey<FormState>();

  late String username;
  late String password;

  // * For checking isLogginh
  bool isLogging = false;

  setLoggingTrue() {
    setState(() {
      isLogging = true;
    });
  }

  setLoggingFalse() {
    setState(() {
      isLogging = false;
    });
  }

  FocusNode userNameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    userNameFocusNode.dispose();
    passwordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _loginScaffoldKey,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
            vertical: size.height * 0.02,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: SizedBox(
                    height: size.height * 0.2,
                    width: size.width * 0.5,
                    child: Image.asset('assets/logo/logo.png'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.02),
                  child: Form(
                    key: loginKey,
                    child: Column(
                      children: [
                        //* Email Address Form Field
                        formField(
                          focusNode: userNameFocusNode,
                          label: 'Enter User Name ',
                          iconData: Icons.person_2_outlined,
                          size: size,
                          textInputType: TextInputType.text,
                          handleSave: (value) {
                            username = value!;
                          },
                          handleEditing: () => FocusScope.of(context)
                              .requestFocus(passwordFocusNode),
                          handleValidate: (value) {
                            if (value!.isEmpty) {
                              return 'Please provide username';
                            } else {
                              return null;
                            }
                          },
                        ),

                        // * Password Form Field
                        formField(
                          focusNode: passwordFocusNode,
                          label: 'Enter Password',
                          iconData: Icons.password_outlined,
                          size: size,
                          isPassword: true,
                          textInputType: TextInputType.text,
                          handleSave: (value) {
                            password = value!;
                          },
                          handleValidate: (value) {
                            if (value!.isEmpty) {
                              return 'Please provide password';
                            } else if (value.length < 8) {
                              return 'Password must be greater than 8 character';
                            } else {
                              return null;
                            }
                          },
                        ),

                        // * Forget Password Text Button
                        // Align(
                        //   alignment: Alignment.centerRight,
                        //   child: TextButton(
                        //     onPressed: () => Navigator.of(context)
                        //         .pushNamed(AppRoutes.forgetPasswordScreen),
                        //     child: const Text('Forget Password ?'),
                        //   ),
                        // ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),

                        // * Login Button
                        isLogging
                            ? const Center(
                                child: CircularProgressIndicator.adaptive(
                                  strokeWidth: 0.6,
                                ),
                              )
                            : Consumer(
                                builder: (context, ref, child) {
                                  return FilledButton.tonalIcon(
                                    style: FilledButton.styleFrom(
                                      fixedSize: Size(
                                          size.width * 0.7, size.height * 0.06),
                                      foregroundColor: Colors.grey.shade900,
                                    ),
                                    onPressed: () {
                                      setLoggingTrue();
                                      if (!loginKey.currentState!.validate()) {
                                        setLoggingFalse();
                                        return;
                                      }
                                      loginKey.currentState!.save();

                                      ref
                                          .read(authControllerProvider.notifier)
                                          .login(
                                              username: username,
                                              password: password)
                                          .then((value) {
                                        if (value[0] == 'true') {
                                          toast(
                                              context: _loginScaffoldKey
                                                  .currentContext!,
                                              label: value[1],
                                              color: Colors.green);
                                          setLoggingFalse();
                                          Navigator.of(_loginScaffoldKey
                                                  .currentContext!)
                                              .pushReplacementNamed(
                                                  AppRoutes.assetScreen);
                                        } else {
                                          toast(
                                              context: _loginScaffoldKey
                                                  .currentContext!,
                                              label: value[1],
                                              color: Colors.red);
                                          setLoggingFalse();
                                        }
                                      });
                                    },
                                    icon: const Icon(Icons.login_outlined),
                                    label: Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: size.width * 0.05,
                                      ),
                                    ),
                                  );
                                },
                              ),

                        //* Sign Up Button
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.01),
                          child: TextButton(
                            onPressed: () => Navigator.of(context)
                                .pushReplacementNamed(AppRoutes.register),
                            child: const Text(
                                "Don't have an account ? Signup now"),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
