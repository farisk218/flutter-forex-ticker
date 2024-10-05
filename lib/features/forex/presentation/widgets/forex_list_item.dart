import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          fontSize: 16.sp,
        ),
      ),
      subtitle: Text(
        instrument.description,
        style: TextStyle(fontSize: 14.sp),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (pricePending)
            _buildPendingIndicator()
          else
            _buildPriceText(priceIncreased),
          if (!pricePending) _buildPriceChangeIcon(priceIncreased),
        ],
      ),
      onTap: () {
        // TODO: Navigate to detail view
      },
    );
  }

  Widget _buildPendingIndicator() {
    return SizedBox(
      width: 10.w,
      height: 10.h,
      child: SpinKitFoldingCube(
        color: Colors.white38,
        size: 10.0.sp,
      ),
    );
  }

  Widget _buildPriceText(bool priceIncreased) {
    return Text(
      instrument.price.toStringAsFixed(4),
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16.sp,
        color: priceIncreased ? Colors.green : Colors.red,
      ),
    );
  }

  Widget _buildPriceChangeIcon(bool priceIncreased) {
    return Icon(
      priceIncreased ? Icons.arrow_upward : Icons.arrow_downward,
      color: priceIncreased ? Colors.green : Colors.red,
      size: 16.sp,
    );
  }
}
