import 'package:flutter/material.dart';

Widget myTextField(
    TextEditingController controller,
    String label,
    Function(String?) vlidator,
    TextInputType keyboardType,
    Function() onTap,
    bool isReadOnly) {
  return TextFormField(
    controller: controller,
    validator: (value) => vlidator(value),
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      labelText: label,
    ),
    keyboardType: keyboardType,
    onTap: onTap,
    readOnly: isReadOnly,
  );
}
