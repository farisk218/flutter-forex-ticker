import 'package:flutter/material.dart';
import 'package:flutter_trading_app/features/forex/domain/entities/forex_instrument.dart';

class ForexListItem extends StatelessWidget {
  final ForexInstrument instrument;
  final ForexInstrument? previousInstrument;

  const ForexListItem({
    Key? key,
    required this.instrument,
    this.previousInstrument,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final priceChanged = previousInstrument != null &&
        instrument.price != previousInstrument!.price;
    final priceIncreased =
        priceChanged && instrument.price > previousInstrument!.price;

    return ListTile(
      title: Text(instrument.displaySymbol),
      subtitle: Text(instrument.description),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            instrument.price.toStringAsFixed(4),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: priceChanged
                  ? (priceIncreased ? Colors.green : Colors.red)
                  : null,
            ),
          ),
          if (priceChanged)
            Icon(
              priceIncreased ? Icons.arrow_upward : Icons.arrow_downward,
              color: priceIncreased ? Colors.green : Colors.red,
              size: 16,
            ),
        ],
      ),
      onTap: () {
        // TODO: Navigate to detail view
      },
    );
  }
}
