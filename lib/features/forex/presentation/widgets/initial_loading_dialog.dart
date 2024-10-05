import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InitialLoadDialog extends StatelessWidget {
  const InitialLoadDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Loading Price Data', style: TextStyle(fontSize: 18.sp)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'We are fetching the latest price data for the forex instruments.',
            style: TextStyle(fontSize: 14.sp),
          ),
          SizedBox(height: 10.h),
          Text(
            'Due to API limitations:',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5.h),
          Text(
            '• Initial prices are not available immediately.',
            style: TextStyle(fontSize: 14.sp),
          ),
          Text(
            '• You may see loading indicators for some items until their prices are updated.',
            style: TextStyle(fontSize: 14.sp),
          ),
          Text(
            '• Price updates are limited to visible items in the list.',
            style: TextStyle(fontSize: 14.sp),
          ),
          SizedBox(height: 10.h),
          Text(
            'Scroll through the list to load prices for more items.',
            style: TextStyle(fontSize: 14.sp, fontStyle: FontStyle.italic),
          ),
          SizedBox(height: 10.h),
          Text(
            'Please be patient as real-time updates start coming in.',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text('OK', style: TextStyle(fontSize: 16.sp)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}