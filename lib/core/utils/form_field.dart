import 'package:flutter/material.dart';

Padding formField({
  String? initialValue,
  required String label,
  required IconData iconData,
  required Size size,
  bool isPassword = false,
  required Function(String?)? handleSave,
  FocusNode? focusNode,
  Function()? handleEditing,
  String? Function(String?)? handleValidate,
  required TextInputType textInputType,
  Function(String)? handleChange,
}) {
  return Padding(
    padding: EdgeInsets.only(top: size.height * 0.03),
    child: TextFormField(
      focusNode: focusNode,
      initialValue: initialValue,
      decoration: InputDecoration(
        label: Text(label),
        prefixIcon: Icon(
          iconData,
        ),
      ),
      style: const TextStyle(
        color: Colors.white,
      ),
      cursorColor: Colors.grey.shade500,
      obscureText: isPassword,
      onSaved: handleSave,
      onEditingComplete: handleEditing,
      validator: handleValidate,
      keyboardAppearance: Brightness.dark,
      keyboardType: textInputType,
      onChanged: handleChange,
    ),
  );
}
