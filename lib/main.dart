import 'package:advaithaunnathi/firebase_options.dart';
import 'package:advaithaunnathi/hive/hive_boxes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_strategy/url_strategy.dart';

import 'myapp.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );
  setPathUrlStrategy();
  await openHiveBoxes();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}


Future<void> openHiveBoxes() async {
  await Hive.initFlutter();
  await Hive.openBox(boxes.userBox);
}
