import 'package:advaithaunnathi/dart/firebase.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

import 'dart/const_global_objects.dart';
import 'hive/hive_boxes.dart';

FirebaseMessaging fcm = FirebaseMessaging.instance;

//

class FCMfunctions {
  //
  static Future<void> backgroundMsgHandler(RemoteMessage msg) async {
    await Firebase.initializeApp();
  }

  //
  static Future<void> fcmSettings() async {
    NotificationSettings settings = await fcm.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {}
  }

  //
  static Future<void> checkFCMtoken() async {
    if (fireUser() != null) {
      var tokenB = servicesBox.get(boxStrings.fcmToken);
      if (tokenB == null || tokenB != String) {
        var fcmToken = await fcm.getToken();
        await authUserCR.doc(fireUser()?.uid).update({
          "$unIndexed.${boxStrings.fcmToken}": fcmToken,
        });
        await servicesBox.put(boxStrings.fcmToken, fcmToken);
      }
    }
  }

  //

  static void onMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage msg) async {
      var msgData = msg.data;
      String? isRecieverOnChat = msgData["isRecieverOnChat"];

      if (isRecieverOnChat != "t") {
        var notification = msg.notification;
        var android = msg.notification?.android;
        if (notification != null && android != null) {
          Get.snackbar(
              notification.title ?? "", notification.body ?? "New message",
              duration: const Duration(seconds: 5),
              isDismissible: true,
              icon: notification.android!.smallIcon != null
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                      child: GFAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                            notification.android!.smallIcon!),
                      ),
                    )
                  : null,
              dismissDirection: DismissDirection.horizontal,
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.white, onTap: (snackbar) async {
            // var crm = await crs
            //     .chatRoomModelFromChatPersonUID(msgData["chatPersonUID"]);
            // Get.closeCurrentSnackbar();
            // Get.to(() => ChatRoomScreen(crm));
          });
        }
      }
    });
  }

  static Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    void _handleMessage(RemoteMessage message) async {
      var chatPersonUID = message.data['chatPersonUID'];
      if (chatPersonUID != null) {}
    }

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }
}
