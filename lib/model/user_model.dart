import 'package:advaithaunnathi/dart/const_global_objects.dart';
import 'package:advaithaunnathi/services/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../hive/hive_boxes.dart';

  class UserModel {
    String profileName;

    String userEmail;
    String? phoneNumber;

    String? profilePhotoUrl;

    String? fcmToken;
    DateTime? firstLoginTime;
    DocumentReference<Map<String, dynamic>>? docRef;

    UserModel({
      required this.profileName,
      required this.userEmail,
      required this.phoneNumber,
      required this.profilePhotoUrl,
      required this.fcmToken,
      required this.firstLoginTime,
      this.docRef,
    });

    Map<String, dynamic> toMap() {
      return {
        userMOs.profileName: profileName,
        userMOs.userEmail: userEmail,
        userMOs.phoneNumber: phoneNumber,
        userMOs.firstLoginTime:
            Timestamp.fromDate(firstLoginTime ?? DateTime.now()),
        unIndexed: {
          userMOs.profilePhotoUrl: profilePhotoUrl,
          boxStrings.fcmToken: fcmToken,
        }
      };
    }

    factory UserModel.fromMap(Map<String, dynamic> userMap) {
      return UserModel(
        profileName: userMap[userMOs.profileName] ?? "",
        userEmail: userMap[userMOs.userEmail] ?? "",
        phoneNumber: userMap[userMOs.phoneNumber],
        firstLoginTime: userMap[userMOs.firstLoginTime]?.toDate(),
        profilePhotoUrl: userMap[unIndexed] != null
            ? userMap[unIndexed][userMOs.profilePhotoUrl]
            : null,
        fcmToken: userMap[unIndexed] != null
            ? userMap[unIndexed][boxStrings.fcmToken]
            : null,
      );
    }
  }

  UserModelObjects userMOs = UserModelObjects();

  class UserModelObjects {

    final profileName = "profileName";

    final userEmail = "userEmail";
    final phoneNumber = "phoneNumber";

    final profilePhotoUrl = "profilePhotoUrl";



    final docs = "docs";
    final payment = "payment";
    final firstLoginTime = "firstLoginTime";

    //
    String dateTime(DateTime time) {
      String ampm = DateFormat("a").format(time).toLowerCase();
      String chatDayTime = DateFormat("dd MMM").format(time);
      //
      String today = DateFormat("dd MMM").format(DateTime.now());
      // String chatDay =
      //     DateFormat("dd MMM").format(crm.lastChatModel!.senderSentTime);

      if (today == chatDayTime) {
        chatDayTime = DateFormat("h:mm").format(time) + ampm;
      }
      return chatDayTime;
    }

    // Future<void> onPaymentFunctionCall(String userUID) async {
    //   HttpsCallable callable =
    //       FirebaseFunctions.instance.httpsCallable("on_payment");
    //   await callable.call(<String>[userUID]);
    // }


    // Future<void> addPosition(String refID) async {
    //   HttpsCallable addPos =
    //       FirebaseFunctions.instance.httpsCallable('addPosition');
    //   await addPos.call(<String, dynamic>{
    //     "uid": fireUser()?.uid,
    //     "refMemberId": refID,
    //   });
    // }

    Future<UserModel?> getUserModel() async {
      return await authUserCR.doc(fireUser()?.uid).get().then((ds) {
        if (ds.exists && ds.data() != null) {
          var um = UserModel.fromMap(ds.data()!);
          um.docRef = ds.reference;
          return um;
        }
        return null;
      });
    }

    DocumentReference<Map<String, dynamic>>? userDR() {
      if (fireUser() != null) {
        return authUserCR.doc(fireUser()!.uid);
      }
      return null;
    }

    Future<void> userInit() async {
      if (fireUser() != null) {
        await userDR()!.get().then((ds) async {
          if (!ds.exists || ds.data() == null) {
            userDR()!.set(
              UserModel(
                      profileName: fireUser()?.displayName ?? "",
                      userEmail: fireUser()?.email ?? "",
                      phoneNumber: null,
                      profilePhotoUrl: fireUser()?.photoURL,
                      firstLoginTime: DateTime.now(),
                      fcmToken: null)
                  .toMap(),
              SetOptions(merge: true),
            );
          }
        });
      }
    }
  }
