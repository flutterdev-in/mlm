import 'package:advaithaunnathi/custom%20widgets/stream_single_query_builder.dart';
import 'package:advaithaunnathi/services/firebase.dart';
import 'package:advaithaunnathi/model/user_model.dart';
import 'package:advaithaunnathi/prime_screens/wallet/a_referar_income_history.dart';
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
      appBar: AppBar(
        title: const Text("Wallet"),
      ),
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            shadowColor: Colors.green.shade200,
            elevation: 2,
            child: Column(
              children: [
                GFListTile(
                  color: Colors.green.shade100,
                  title: const Text("Referal benefits"),
                  icon: Text("\u{20B9} ${um.directIncome * 500}"),
                  onTap: () {
                    Get.to(() => const ReferalBenefitsScreen());
                  },
                ),
                GFButton(
                  color: Colors.green,
                  onPressed: () {
                    refWithdrawBS();
                  },
                  child: const Text("Withdraw"),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            shadowColor: Colors.green.shade200,
            elevation: 2,
            child: Column(
              children: [
                GFListTile(
                    color: Colors.blue.shade100,
                    title: const Text("Promotional benefits"),
                    icon: StreamSingleQueryBuilder(
                        query: authUserCR.orderBy(userMOs.memberPosition,
                            descending: true),
                        docBuilder: (context, snapshot) {
                          var umLast = UserModel.fromMap(snapshot.data());
                          return Text(
                              "${matrixIncome(um.memberPosition ?? 0, umLast.memberPosition ?? 0)} coins");
                        })),
                GFButton(
                  onPressed: () {},
                  child: const Text("Withdraw"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

void refWithdrawBS() async {
  var um = await userMOs.getUserModel();
  if (um == null) {
    Get.snackbar(
        "Network error", "Error while fetching data, please try again");
  } else if (um.directIncome == 0) {
    Get.bottomSheet(
      Container(
          color: Colors.white,
          height: 150,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
                "Your referer balance is zero, please get referers and withdraw"),
          )),
    );
  }
}
