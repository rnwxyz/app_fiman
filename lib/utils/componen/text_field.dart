import 'package:flutter/material.dart';

// Widget myTextField(
//     TextEditingController controller,
//     String label,
//     Function(String?) vlidator,
//     TextInputType keyboardType,
//     Function() onTap,
//     bool isReadOnly) {
//   return TextFormField(
//     controller: controller,
//     validator: (value) => vlidator(value),
//     decoration: InputDecoration(
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       labelText: label,
//     ),
//     keyboardType: keyboardType,
//     onTap: onTap,
//     readOnly: isReadOnly,
//   );
// }

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Function(String?) vlidator;
  final TextInputType keyboardType;
  final Function() onTap;
  final bool isReadOnly;

  const MyTextField(
      {super.key,
      required this.controller,
      required this.label,
      required this.vlidator,
      required this.keyboardType,
      required this.onTap,
      required this.isReadOnly});

  @override
  Widget build(BuildContext context) {
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
}
