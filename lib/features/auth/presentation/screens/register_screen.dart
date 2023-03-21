import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:justsanppit/constants/app_routes.dart';
import 'package:justsanppit/features/auth/presentation/controllers/auth_controller.dart';

import '../../../../core/utils/form_field.dart';
import '../../../../core/utils/toast.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final registerKey = GlobalKey<FormState>();

  late String email;
  late String name;
  late String address;
  late String phone;
  late String password;
  late String confirmPassword;

  FocusNode nameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode passwordConfirmationFocusNode = FocusNode();
  FocusNode addressFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    nameFocusNode.dispose();
    phoneFocusNode.dispose();
    addressFocusNode.dispose();
    passwordConfirmationFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
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
                    child: Image.asset('assets/logo/logo.png'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.02),
                  child: Form(
                    key: registerKey,
                    child: Column(
                      children: [
                        // * Name Form Field
                        formField(
                          focusNode: nameFocusNode,
                          label: 'Enter Full Name',
                          iconData: Icons.person_2_outlined,
                          size: size,
                          textInputType: TextInputType.name,
                          handleSave: (value) {
                            name = value!;
                          },
                          handleEditing: () => FocusScope.of(context)
                              .requestFocus(emailFocusNode),
                          handleValidate: (value) {
                            if (value!.isEmpty) {
                              return 'Please provide full name';
                            } else {
                              return null;
                            }
                          },
                        ),

                        //* Email Address Form Field
                        formField(
                          focusNode: emailFocusNode,
                          label: 'Enter Email Address',
                          iconData: Icons.email_outlined,
                          size: size,
                          handleSave: (value) {
                            email = value!;
                          },
                          textInputType: TextInputType.emailAddress,
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
                          textInputType: TextInputType.visiblePassword,
                          isPassword: true,
                          handleSave: (value) {
                            password = value!;
                          },
                          handleEditing: () => FocusScope.of(context)
                              .requestFocus(passwordConfirmationFocusNode),
                          handleChange: (value) {
                            password = value;
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

                        // * Cinfrim Password Form Field
                        formField(
                          focusNode: passwordConfirmationFocusNode,
                          label: 'Confirm Your Password',
                          iconData: Icons.password_outlined,
                          size: size,
                          textInputType: TextInputType.visiblePassword,
                          isPassword: true,
                          handleSave: (value) {
                            confirmPassword = value!;
                          },
                          handleEditing: () => FocusScope.of(context)
                              .requestFocus(addressFocusNode),
                          handleValidate: (value) {
                            if (value!.isEmpty) {
                              return 'Please provide password';
                            } else if (value.length < 8) {
                              return 'Password must be greater than 8 character';
                            } else if (password != value) {
                              return "Password and confirm password doesn't match";
                            } else {
                              return null;
                            }
                          },
                        ),

                        // * address Form Field
                        formField(
                          focusNode: addressFocusNode,
                          label: 'Enter Address',
                          iconData: Icons.location_history_outlined,
                          size: size,
                          handleSave: (value) {
                            address = value!;
                          },
                          textInputType: TextInputType.streetAddress,
                          handleEditing: () => FocusScope.of(context)
                              .requestFocus(phoneFocusNode),
                          handleValidate: (value) {
                            if (value!.isEmpty) {
                              return 'Please provide address';
                            } else {
                              return null;
                            }
                          },
                        ),

                        // * phone Form Field
                        formField(
                          focusNode: phoneFocusNode,
                          label: 'Enter Phone Number',
                          iconData: Icons.phone_android_outlined,
                          size: size,
                          handleSave: (value) {
                            phone = value!;
                          },
                          textInputType: TextInputType.phone,
                          handleEditing: () => FocusScope.of(context)
                              .requestFocus(nameFocusNode),
                          handleValidate: (value) {
                            if (value!.isEmpty) {
                              return 'Please provide phone number';
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        // * Register Button
                        Consumer(
                          builder: (context, ref, child) {
                            return FilledButton.tonalIcon(
                              style: FilledButton.styleFrom(
                                fixedSize:
                                    Size(size.width * 0.7, size.height * 0.06),
                                foregroundColor: Colors.grey.shade900,
                              ),
                              onPressed: () {
                                if (!registerKey.currentState!.validate()) {
                                  return;
                                }
                                registerKey.currentState!.save();
                                Map<String, dynamic> data = {
                                  'name': name,
                                  'email': email,
                                  'phone': phone,
                                  'address': address,
                                  'password': password,
                                  'password_confirmation': confirmPassword,
                                };
                                ref
                                    .read(authControllerProvider.notifier)
                                    .register(data)
                                    .then((value) {
                                  if (value[0] == 'true') {
                                    toast(
                                        context: context,
                                        label: value[1],
                                        color: Colors.green);
                                    Navigator.of(context).pushReplacementNamed(
                                        AppRoutes.assetScreen);
                                  } else {
                                    toast(
                                        context: context,
                                        label: value[1],
                                        color: Colors.red);
                                  }
                                });
                              },
                              icon: const Icon(Icons.logout_outlined),
                              label: Text(
                                'Register',
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
                                .pushReplacementNamed(AppRoutes.login),
                            child: const Text(
                                'Already have an account ? Login now'),
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
