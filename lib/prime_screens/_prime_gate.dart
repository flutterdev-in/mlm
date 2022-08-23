import 'package:advaithaunnathi/model/user_model.dart';
import 'package:advaithaunnathi/prime_screens/prime_home_screen.dart';
import 'package:advaithaunnathi/prime_screens/registration_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

import '../hive/hive_boxes.dart';
import '../services/firebase.dart';

class PrimeGate extends StatelessWidget {
  final bool isRefferar;
  const PrimeGate(this.isRefferar, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: authUserCR.doc(fireUser()?.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          var um = UserModel.fromMap(snapshot.data!.data()!);
          if (um.memberPosition != null) {
            return const PrimeHomeScreen();
          } else {
            servicesBox.put(uMOs.refMemberId, Get.parameters[uMOs.refMemberId]);
            return const PrimeRegistrationScreen();
          }
        }
        return const Scaffold(
            body: GFLoader(
          type: GFLoaderType.circle,
        ));

        // Render your application if authenticated
      },
    );
  }
}
