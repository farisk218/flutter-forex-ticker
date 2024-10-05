import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 8.h),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search currency pair',
          hintStyle: TextStyle(fontSize: 14.sp),
          prefixIcon: Icon(Icons.search, size: 20.sp),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear, size: 20.sp),
            onPressed: _clearSearch,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.r),
            borderSide: BorderSide.none,
          ),
          filled: true,
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
        ),
        style: TextStyle(fontSize: 14.sp),
      ),
    );
  }

  void _clearSearch() {
    controller.clear();
    onClear();
  }
}
