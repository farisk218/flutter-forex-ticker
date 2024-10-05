import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_trading_app/core/constants/assets.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLogo(),
              SizedBox(height: 30.h),
              _buildTitle(),
              SizedBox(height: 20.h),
              _buildDescription(),
              SizedBox(height: 20.h),
              _buildButton(
                context: context,
                label: "Forex",
                icon: Icons.show_chart,
                onPressed: () => Navigator.pushNamed(context, '/forex'),
              ),
              SizedBox(height: 10.h),
              _buildButton(
                context: context,
                label: "Stocks",
                icon: Icons.attach_money,
                onPressed: () => _showFSnackbar(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Hero(
      tag: "logo",
      child: SvgPicture.asset(
        BRAND_LOGO_SVG,
        semanticsLabel: 'Exinity',
        width: 200.w,
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Real-time \nPrice Tracker',
      style: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription() {
    return Opacity(
      opacity: 0.5,
      child: Text(
        "Welcome to Exinity Real-time Price Tracker featuring a list of trading instruments with live price updates, ensuring you're always aware of market fluctuations.",
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }

  void _showFSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Feature in development'),
        duration: Duration(milliseconds: 200),
      ),
    );
  }
}
