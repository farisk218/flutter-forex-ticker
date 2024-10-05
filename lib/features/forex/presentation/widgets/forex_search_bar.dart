import 'package:flutter/material.dart';

class FSearchBar extends StatelessWidget {
  final Function(String) onChanged;
  final VoidCallback onClear;
  final TextEditingController controller;

  const FSearchBar({
    Key? key,
    required this.onChanged,
    required this.onClear,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search currency pair',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              controller.clear();
              onClear();
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
        ),
      ),
    );
  }
}
