import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_trading_app/core/constants/assets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: "logo",
              child: SvgPicture.asset(
                BRAND_LOGO_SVG,
                semanticsLabel: 'Exinity',
                width: 200,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Real-time \nPrice Tracker',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Opacity(
              opacity: 0.5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: const Text(
                  "Welcome to Exinity Real-time Price Tracker featuring a list of trading instruments with live price updates, ensuring you're always aware of market fluctuations.",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SizedBox(
                width: double.infinity, // Full width
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/forex');
                  },
                  label: const Text("Forex"),
                  icon: const Icon(Icons.show_chart),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Feature in development'),
                        duration: Duration(milliseconds: 200),
                      ),
                    );
                  },
                  label: const Text("Stocks"),
                  icon: const Icon(Icons.attach_money),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
