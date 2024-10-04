import 'package:flutter/material.dart';

class ForexListItem extends StatelessWidget {
  final String symbol;
  final String displaySymbol;
  final String description;
  final double price;

  const ForexListItem({
    Key? key,
    required this.symbol,
    required this.displaySymbol,
    required this.description,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(displaySymbol),
      subtitle: Text(description),
      trailing: Text(
        price.toStringAsFixed(4),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      onTap: () {
        // TODO: Implement detailed view or action when tapped
      },
    );
  }
}
