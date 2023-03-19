import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:justsanppit/constants/app_routes.dart';
import 'package:justsanppit/features/auth/presentation/controllers/auth_controller.dart';

import '../../../../core/utils/toast.dart';

class ForgetChangePassword extends StatefulWidget {
  const ForgetChangePassword({super.key});

  @override
  State<ForgetChangePassword> createState() => _ForgetChangePasswordState();
}

class _ForgetChangePasswordState extends State<ForgetChangePassword> {
  final forgetChangePasswordKey = GlobalKey<FormState>();

  late String password;
  late String confirmPassword;

  final passwordNode = FocusNode();
  final confirmPasswordNode = FocusNode();

  @override
  void dispose() {
    passwordNode.dispose();
    confirmPasswordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    String codes = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenSize.height * 0.02,
            horizontal: screenSize.width * 0.04,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'App Logo',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              //Text For Chnage password
              Text(
                "Enter New Password and Confirm Password",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: forgetChangePasswordKey,
                child: Column(
                  children: [
                    //Field for password
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextFormField(
                        focusNode: passwordNode,
                        decoration: const InputDecoration(
                          label: Text('Enter New Password'),
                        ),
                        obscureText: true,
                        onSaved: (newValue) {
                          password = newValue!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Provide New Password';
                          } else if (value.length < 8) {
                            return 'Password must be 8 Character long';
                          } else {
                            return null;
                          }
                        },
                        onEditingComplete: () {
                          FocusScope.of(context)
                              .requestFocus(confirmPasswordNode);
                        },
                      ),
                    ),
                    //Field For new Password
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: TextFormField(
                        focusNode: confirmPasswordNode,
                        decoration: const InputDecoration(
                          label: Text('Confirm Your New Password'),
                        ),
                        obscureText: true,
                        onSaved: (newValue) {
                          confirmPassword = newValue!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Provide Confirm Password';
                          } else if (value != password) {
                            return 'Password and Confirm Password doesnot match';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    // Button For Confirm Password
                    Consumer(
                      builder: (context, ref, child) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Center(
                            child: FilledButton.tonalIcon(
                              onPressed: () {
                                forgetChangePasswordKey.currentState!.save();
                                if (!forgetChangePasswordKey.currentState!
                                    .validate()) {
                                  return;
                                }
                                ref
                                    .read(authControllerProvider.notifier)
                                    .forgetChnagePassword(
                                        password: password,
                                        confirmPassword: confirmPassword,
                                        code: codes)
                                    .then((value) {
                                  if (value[0] == 'false') {
                                    toast(
                                        context: context,
                                        label: value[1],
                                        color: Colors.red);
                                  } else {
                                    Navigator.of(context)
                                        .pushReplacementNamed(AppRoutes.login);
                                    toast(
                                        context: context,
                                        label: value[1],
                                        color: Colors.green);
                                  }
                                });
                              },
                              icon: const Icon(Icons.check),
                              label: const Text('Confirm'),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FilledButton.tonal(
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(AppRoutes.login);
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
