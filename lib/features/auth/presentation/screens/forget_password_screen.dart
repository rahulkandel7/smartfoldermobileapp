import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:justsanppit/constants/app_routes.dart';
import 'package:justsanppit/features/auth/presentation/controllers/auth_controller.dart';

import '../../../../core/utils/toast.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final forgetKey = GlobalKey<FormState>();

  late String email;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
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
                  'Logo App',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              //Text For Login Screen
              Text(
                "Forgot your password? No problem. Just let us know your email address and we will email you a password reset link that will allow you to choose a new one.",
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Form(
                key: forgetKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: screenSize.height * 0.03,
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: Icon(
                            Icons.email_outlined,
                          ),
                        ),
                        onSaved: (newValue) {
                          email = newValue!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Provide Your Email Address';
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        return FilledButton(
                          onPressed: () {
                            forgetKey.currentState!.save();
                            if (!forgetKey.currentState!.validate()) {
                              return;
                            }
                            ref
                                .read(authControllerProvider.notifier)
                                .sendPasswordResetLink(email)
                                .then((value) {
                              if (value[0] == 'false') {
                                toast(
                                  context: context,
                                  label: value[1],
                                  color: Colors.red,
                                );
                              } else {
                                Navigator.of(context).pushNamed(AppRoutes.otp);
                                toast(
                                  context: context,
                                  label: value[1],
                                  color: Colors.green,
                                );
                              }
                            });
                          },
                          child: const Text(
                            'Send Password Reset Link',
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
