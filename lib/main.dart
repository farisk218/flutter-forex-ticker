import 'package:flutter/material.dart';

import 'app.dart';
import 'injection_container.dart' as AppDependencies;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDependencies.init();
  runApp(MyApp());
}
