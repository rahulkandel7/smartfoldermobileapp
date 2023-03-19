import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:justsanppit/constants/app_routes.dart';
import 'package:justsanppit/features/auth/presentation/controllers/auth_controller.dart';

import '../../../../core/utils/toast.dart';

class ForgetOtp extends StatefulWidget {
  static const String routeName = '/forget-otp';
  const ForgetOtp({super.key});

  @override
  State<ForgetOtp> createState() => _ForgetOtpState();
}

class _ForgetOtpState extends State<ForgetOtp> {
  final otpkey = GlobalKey<FormState>();
  late String code1;

  late String code2;

  late String code3;

  late String code4;

  late String code5;

  late String code6;

  final code1Node = FocusNode();
  final code2Node = FocusNode();
  final code3Node = FocusNode();
  final code4Node = FocusNode();
  final code5Node = FocusNode();
  final code6Node = FocusNode();

  @override
  void dispose() {
    code1Node.dispose();
    code2Node.dispose();
    code3Node.dispose();
    code4Node.dispose();
    code5Node.dispose();
    code6Node.dispose();
    super.dispose();
  }

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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                "Enter 6-Digits Code:",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: otpkey,
                child: Row(
                  children: [
                    //Code 1
                    Padding(
                      padding: const EdgeInsets.all(
                        4,
                      ),
                      child: SizedBox(
                        width: screenSize.width * 0.13,
                        height: screenSize.height * 0.13,
                        child: TextFormField(
                          focusNode: code1Node,
                          maxLength: 1,
                          decoration: const InputDecoration(
                            counterText: '',
                          ),
                          onSaved: (newValue) {
                            code1 = newValue!;
                          },
                          textAlign: TextAlign.center,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '';
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.number,
                          onEditingComplete: () {
                            FocusScope.of(context).requestFocus(code2Node);
                          },
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              FocusScope.of(context).requestFocus(code2Node);
                            }
                          },
                        ),
                      ),
                    ),
                    //Code 2
                    Padding(
                      padding: const EdgeInsets.all(
                        4,
                      ),
                      child: SizedBox(
                        width: screenSize.width * 0.13,
                        height: screenSize.height * 0.13,
                        child: TextFormField(
                          focusNode: code2Node,
                          maxLength: 1,
                          decoration: const InputDecoration(
                            counterText: '',
                          ),
                          textAlign: TextAlign.center,
                          onSaved: (newValue) {
                            code2 = newValue!;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '';
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.number,
                          onEditingComplete: () {
                            FocusScope.of(context).requestFocus(code3Node);
                          },
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              FocusScope.of(context).requestFocus(code3Node);
                            }
                          },
                        ),
                      ),
                    ),
                    //Code 3
                    Padding(
                      padding: const EdgeInsets.all(
                        4,
                      ),
                      child: SizedBox(
                        width: screenSize.width * 0.13,
                        height: screenSize.height * 0.13,
                        child: TextFormField(
                          focusNode: code3Node,
                          maxLength: 1,
                          decoration: const InputDecoration(
                            counterText: '',
                          ),
                          onSaved: (newValue) {
                            code3 = newValue!;
                          },
                          textAlign: TextAlign.center,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '';
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.number,
                          onEditingComplete: () {
                            FocusScope.of(context).requestFocus(code4Node);
                          },
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              FocusScope.of(context).requestFocus(code4Node);
                            }
                          },
                        ),
                      ),
                    ),
                    //Code 4
                    Padding(
                      padding: const EdgeInsets.all(
                        4,
                      ),
                      child: SizedBox(
                        width: screenSize.width * 0.13,
                        height: screenSize.height * 0.13,
                        child: TextFormField(
                          focusNode: code4Node,
                          maxLength: 1,
                          decoration: const InputDecoration(
                            counterText: '',
                          ),
                          onSaved: (newValue) {
                            code4 = newValue!;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '';
                            } else {
                              return null;
                            }
                          },
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          onEditingComplete: () {
                            FocusScope.of(context).requestFocus(code5Node);
                          },
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              FocusScope.of(context).requestFocus(code5Node);
                            }
                          },
                        ),
                      ),
                    ),
                    //Code 5
                    Padding(
                      padding: const EdgeInsets.all(
                        4,
                      ),
                      child: SizedBox(
                        width: screenSize.width * 0.13,
                        height: screenSize.height * 0.13,
                        child: TextFormField(
                          focusNode: code5Node,
                          maxLength: 1,
                          decoration: const InputDecoration(
                            counterText: '',
                          ),
                          onSaved: (newValue) {
                            code5 = newValue!;
                          },
                          textAlign: TextAlign.center,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '';
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.number,
                          onEditingComplete: () {
                            FocusScope.of(context).requestFocus(code6Node);
                          },
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              FocusScope.of(context).requestFocus(code6Node);
                            }
                          },
                        ),
                      ),
                    ),
                    //Code 6
                    Padding(
                      padding: const EdgeInsets.all(
                        4,
                      ),
                      child: SizedBox(
                        width: screenSize.width * 0.13,
                        height: screenSize.height * 0.13,
                        child: TextFormField(
                          focusNode: code6Node,
                          maxLength: 1,
                          decoration: const InputDecoration(
                            counterText: '',
                          ),
                          onSaved: (newValue) {
                            code6 = newValue!;
                          },
                          textAlign: TextAlign.center,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '';
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Consumer(
                builder: (context, ref, child) {
                  return Center(
                    child: SizedBox(
                      child: FilledButton.tonalIcon(
                        onPressed: () {
                          otpkey.currentState!.save();
                          if (!otpkey.currentState!.validate()) {
                            return;
                          }
                          String codes = '$code1$code2$code3$code4$code5$code6';
                          ref
                              .read(authControllerProvider.notifier)
                              .codeCheck(codes)
                              .then((value) {
                            if (value[0] == 'false') {
                              toast(
                                  context: context,
                                  label: value[1],
                                  color: Colors.red);
                            } else {
                              Navigator.of(context).pushNamed(
                                  AppRoutes.forgetChangePassword,
                                  arguments: codes);
                              toast(
                                  context: context,
                                  label: value[1],
                                  color: Colors.green);
                            }
                          });
                        },
                        icon: const Icon(Icons.next_plan_outlined),
                        label: const Text(
                          'Continue',
                        ),
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
                  Navigator.of(context).pushReplacementNamed(AppRoutes.login);
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
