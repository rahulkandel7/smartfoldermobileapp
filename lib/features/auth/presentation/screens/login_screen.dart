import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:justsanppit/constants/app_routes.dart';
import 'package:justsanppit/core/utils/toast.dart';
import 'package:justsanppit/features/auth/presentation/controllers/auth_controller.dart';

import '../../../../core/utils/form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginKey = GlobalKey<FormState>();

  late String email;
  late String password;

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
            vertical: size.height * 0.02,
          ),
          child: Column(
            children: [
              Center(
                child: SizedBox(
                  height: size.height * 0.2,
                  width: size.width * 0.5,
                  child: const Placeholder(),
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
                        focusNode: emailFocusNode,
                        label: 'Enter Email Address',
                        iconData: Icons.email_outlined,
                        size: size,
                        textInputType: TextInputType.emailAddress,
                        handleSave: (value) {
                          email = value!;
                        },
                        handleEditing: () => FocusScope.of(context)
                            .requestFocus(passwordFocusNode),
                        handleValidate: (value) {
                          if (value!.isEmpty) {
                            return 'Please provide email address';
                          } else if (!value.contains('@') ||
                              !value.contains('.')) {
                            return 'Provide valid email address';
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
                        handleEditing: () =>
                            FocusScope.of(context).requestFocus(emailFocusNode),
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('Forget Password ?'),
                        ),
                      ),

                      // * Login Button
                      Consumer(
                        builder: (context, ref, child) {
                          return FilledButton.tonalIcon(
                            style: FilledButton.styleFrom(
                              fixedSize:
                                  Size(size.width * 0.7, size.height * 0.06),
                              foregroundColor: Colors.grey.shade900,
                            ),
                            onPressed: () {
                              if (!loginKey.currentState!.validate()) {
                                return;
                              }
                              loginKey.currentState!.save();
                              Map<String, dynamic> data = {
                                'email': email,
                                'password': password,
                              };
                              ref
                                  .read(authControllerProvider.notifier)
                                  .login(data)
                                  .then((value) {
                                if (value[0] == 'true') {
                                  toast(
                                      context: context,
                                      label: value[1],
                                      color: Colors.green);
                                } else {
                                  toast(
                                      context: context,
                                      label: value[1],
                                      color: Colors.red);
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
                          child:
                              const Text("Don't have an account ? Signup now"),
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
    );
  }
}
