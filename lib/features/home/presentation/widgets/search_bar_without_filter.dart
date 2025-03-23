import 'package:flutter/material.dart';

class SearchBarWithoutFilter extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final String? placeholderText;
  final VoidCallback onPressed;

  const SearchBarWithoutFilter({
    super.key,
    required this.controller,
    this.onChanged,
    this.placeholderText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: onPressed, 
        ),
        hintText: placeholderText ?? 'Search...', 
        hintStyle: TextStyle(color: Colors.grey[500]),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
      ),
    );
  }
}
