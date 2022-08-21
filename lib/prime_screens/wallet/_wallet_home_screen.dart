import 'package:advaithaunnathi/dart/firebase.dart';
import 'package:advaithaunnathi/model/user_model.dart';
import 'package:advaithaunnathi/prime_screens/direct%20income/direct_income_history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:getwidget/getwidget.dart';

import '../../matrix/matrix_income.dart';

class WalletHomeScreen extends StatelessWidget {
  const WalletHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Wallet")),
      body: Column(
        children: [
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: authUserCR.doc(fireUser()?.uid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.data() != null) {
                  var um = UserModel.fromMap(snapshot.data!.data()!);
                  um.docRef = snapshot.data!.reference;
                  return bodyW(um);
                } else {
                  return const Text("Loading..");
                }
              }),
        ],
      ),
    );
  }

  Widget bodyW(UserModel um) {
    return Column(
      children: [
        const SizedBox(height: 20),
        GFListTile(
          color: Colors.green.shade100,
          title: const Text("Wallet Income"),
          icon: Text("${um.directIncome * 500}"),
          onTap: () {
            if (um.directIncome > 0) {
              Get.to(() => DirectIncomeHistory(um));
            }
          },
        ),
        GFListTile(
          color: Colors.blue.shade100,
          title: const Text("Matrix Income"),
          icon: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: authUserCR
                  .orderBy(umos.memberPosition, descending: true)
                  .limit(1)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  var umLast =
                      UserModel.fromMap(snapshot.data!.docs.first.data());
                  return Text(
                      "${matrixIncome(um.memberPosition ?? 0, umLast.memberPosition ?? 0)}");
                }
                return const Text("...");
              }),
        ),
      ],
    );
  }
}
