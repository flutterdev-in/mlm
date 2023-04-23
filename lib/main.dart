import 'package:advaithaunnathi/services/fcm.dart';
import 'package:advaithaunnathi/firebase_options.dart';
import 'package:advaithaunnathi/hive/hive_boxes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_strategy/url_strategy.dart';
import 'myapp.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


//
AndroidNotificationChannel androidNotificationChannel =
    const AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title

  description: 'This channel is used for important notifications.',
  importance: Importance.max,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setPathUrlStrategy();
  await openHiveBoxes();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

Future<void> fcmMain() async {
  await FCMfunctions.fcmSettings();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidNotificationChannel);
  FirebaseMessaging.onBackgroundMessage(FCMfunctions.backgroundMsgHandler);

  await fcm.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

Future<void> openHiveBoxes() async {
  await Hive.initFlutter();

  await Hive.openBox(boxNames.userBox);
  await Hive.openBox(boxNames.services);
}
