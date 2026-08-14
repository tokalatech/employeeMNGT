import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController? controller;
  final int maxLines;

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    maxLines: maxLines,
    decoration: InputDecoration(labelText: label),
  );
}
