import 'package:advaithaunnathi/Prime%20models/prime_member_model.dart';
import 'package:advaithaunnathi/model/user_model.dart';
import 'package:advaithaunnathi/services/firebase.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';

import '../Prime models/razor_model.dart';

class ConvertPrimeMembers extends StatelessWidget {
  const ConvertPrimeMembers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Convert"),
      ),
      body: Center(
          child: GFButton(
        child: const Text("Convert"),
        onPressed: () async {
          await authUserCR
              .where(userMOs.memberPosition, isNotEqualTo: null)
              .orderBy(userMOs.memberPosition, descending: false)
              .get()
              .then((qs) async {
            if (qs.docs.isNotEmpty) {
              for (var userDoc in qs.docs) {
                var um = UserModel.fromMap(userDoc.data());

                if (um.memberPosition != null) {
                  await userDoc.reference
                      .collection("docs")
                      .doc("payment")
                      .get()
                      .then((ds) async {
                    if (ds.exists && ds.data() != null) {
                      var rm = RegistrationModel.fromMap(ds.data()!);
                      if (rm.isPaid == true) {
                        String ln = um.profileName.split(" ").last;
                        String fn = um.profileName.replaceAll(ln, "").trim();
                        String usn = um.userEmail.replaceAll("@gmail.com", "");
                        var pmm = PrimeMemberModel(
                          memberPosition: um.memberPosition,
                          firstName: fn,
                          lastName: ln,
                          memberID: um.memberID,
                          email: um.userEmail,
                          phoneNumber: um.phoneNumber,
                          refMemberId: um.refMemberId,
                          paymentTime: DateTime.now(),
                          directIncome: um.directIncome,
                          orderID: rm.orderID,
                          isPaid: rm.isPaid,
                          interestedIn: rm.interestedIn,
                          userName: usn,
                          userPassword: um.phoneNumber,
                          profilePhotoUrl: um.profilePhotoUrl,
                          fcmToken: um.fcmToken,
                        );
                        await primeMOs
                            .primeMembersCR()
                            .doc(usn)
                            .set(pmm.toMap());
                      }
                    }
                  });
                }
              }
            }
          });
        },
      )),
    );
  }
}
