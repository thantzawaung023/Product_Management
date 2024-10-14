import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    TextEditingController? controller,
    required this.label,
    this.initialValue,
    this.onChanged,
    this.isRequired = false,
    this.validator,
    this.maxLength,
    this.isReadOnly = false,
    this.isEnabled = true,
    this.obscured = false,
  }) : _controller = controller;

  final TextEditingController? _controller;
  final String label;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final bool isRequired;
  final String? Function(String?)? validator;
  final int? maxLength;
  final bool isReadOnly;
  final bool isEnabled;
  final bool obscured;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: isReadOnly,
      initialValue: initialValue,
      maxLength: maxLength,
      autocorrect: true,
      controller: _controller,
      obscureText: obscured,
      decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: label,
          hintStyle: TextStyle(color: Colors.grey[600])),
      onChanged: onChanged,
      validator: validator ??
          (value) {
            if (isRequired && (value == null || value.isEmpty)) {
              return '$label is a required field.';
            }
            return null;
          },
    );
  }
}
