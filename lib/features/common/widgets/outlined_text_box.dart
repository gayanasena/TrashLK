import 'package:flutter/material.dart';
import 'package:wasteapp/core/resources/colors.dart';

class OutlinedTextBox extends StatefulWidget {
  final Color color;
  final String labelText;
  final bool isPassword;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const OutlinedTextBox({
    super.key,
    this.color = primaryColor,
    required this.labelText,
    this.isPassword = false,
    required this.controller,
    this.validator,
  });

  @override
  State<OutlinedTextBox> createState() => _OutlinedTextBoxState();
}

class _OutlinedTextBoxState extends State<OutlinedTextBox> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: const TextStyle(color: Colors.black),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: widget.color, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: widget.color, width: 1.5),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
        suffixIcon:
            widget.isPassword
                ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
                : null,
      ),
    );
  }
}
