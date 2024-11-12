import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    TextEditingController? controller,
    required this.label,
    this.initialValue,
    this.onChanged,
    this.isRequired = false,
    this.validator,
    this.helperText = '',
    this.maxLength,
    this.isReadOnly = false,
    this.isEnabled = true,
    this.obscured = false,
    this.onTogglePassword,
    this.keyboardType = TextInputType.text,
  }) : _controller = controller;

  final TextEditingController? _controller;
  final String label;
  final String helperText;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final bool isRequired;
  final String? Function(String?)? validator;
  final int? maxLength;
  final bool isReadOnly;
  final bool isEnabled;
  final bool obscured;
  final TextInputType keyboardType;
  final ValueChanged<bool>? onTogglePassword;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: isReadOnly,
      initialValue: initialValue,
      maxLength: maxLength,
      autocorrect: true,
      controller: _controller,
      keyboardType: keyboardType,
      obscureText: obscured,
      decoration: InputDecoration(
        isDense: true,
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        fillColor: Theme.of(context).colorScheme.surface,
        filled: true,
        hintText: label,
        helperText: helperText,
        hintStyle: TextStyle(color: Colors.grey[600]),
        suffixIcon: (label.contains('Password') || label.contains('စကားဝှက်'))
            ? _buildPasswordToggleIcon(obscured, onTogglePassword)
            : null,
      ),
      onChanged: onChanged,
      validator: validator ??
          (value) {
            if (isRequired && (value == null || value.isEmpty)) {
              return '$label ${AppLocalizations.of(context)!.isRequired}';
            }
            return null;
          },
    );
  }
}

/// Builds the suffix icon for the password field
Widget? _buildPasswordToggleIcon(
    bool obscured, ValueChanged<bool>? onTogglePassword) {
  return IconButton(
    icon: Icon(
      obscured ? Icons.visibility_off : Icons.visibility,
      color: Colors.black,
    ),
    onPressed: () {
      onTogglePassword?.call(!obscured);
    },
  );
}
