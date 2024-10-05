import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
    final pricePending = instrument.price == 0.0;
    // TODO: This needs to be implemented after getLastPrice
    final priceIncreased = instrument.lastPrice == 0.0
        ? Random().nextBool()
        : instrument.price > instrument.lastPrice;

    return ListTile(
      title: Text(
        instrument.displaySymbol,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(instrument.description),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (pricePending)
            Container(
              width: 10,
              height: 10,
              child: SpinKitFoldingCube(
                color: Colors.white38,
                size: 10.0,
              ),
            )
          else
            Text(
              instrument.price.toStringAsFixed(4),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: !pricePending
                    ? (priceIncreased ? Colors.green : Colors.red)
                    : null,
              ),
            ),
          if (!pricePending)
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
