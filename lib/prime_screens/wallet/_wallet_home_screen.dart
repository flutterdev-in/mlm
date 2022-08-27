import 'package:advaithaunnathi/model/kyc_model.dart';
import 'package:advaithaunnathi/model/prime_member_model.dart';
import 'package:advaithaunnathi/custom%20widgets/stream_builder_widget.dart';
import 'package:advaithaunnathi/custom%20widgets/stream_single_query_builder.dart';
import 'package:advaithaunnathi/model/user_model.dart';
import 'package:advaithaunnathi/prime_screens/wallet/a_referar_income_history.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:getwidget/getwidget.dart';

import '../../matrix/matrix_income.dart';

class WalletHomeScreen extends StatelessWidget {
  PrimeMemberModel pmm;
  WalletHomeScreen(this.pmm, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wallet"),
      ),
      body: Column(
        children: [
          StreamDocBuilder(
            docRef: pmm.docRef!,
            builder: (docSnap) {
              pmm = PrimeMemberModel.fromMap(docSnap.data()!);
              pmm.docRef = docSnap.reference;
              return bodyW(pmm);
            },
          ),
        ],
      ),
    );
  }

  Widget bodyW(PrimeMemberModel pm) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Card(
            shadowColor: Colors.green.shade200,
            elevation: 2,
            child: Column(
              children: [
                GFListTile(
                  padding: const EdgeInsets.fromLTRB(0, 12, 3, 12),
                  margin: const EdgeInsets.all(8),
                  color: Colors.green.shade100,
                  title: const Text("Referal benefits"),
                  icon: Text("\u{20B9} ${pm.directIncome * 500}"),
                  onTap: () {
                    Get.to(() => ReferalBenefitsScreen(pmm));
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
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            shadowColor: Colors.green.shade200,
            elevation: 2,
            child: Column(
              children: [
                GFListTile(
                    padding: const EdgeInsets.fromLTRB(0, 12, 3, 12),
                    margin: const EdgeInsets.all(8),
                    color: Colors.blue.shade100,
                    title: const Text("Promotional benefits"),
                    icon: StreamSingleQueryBuilder(
                        query: primeMOs
                            .primeMembersCR()
                            .orderBy(userMOs.memberPosition, descending: true),
                        builder: (snapshot) {
                          var pmLast =
                              PrimeMemberModel.fromMap(snapshot.data());
                          return Text(
                              "${matrixIncome(pm.memberPosition ?? 0, pmLast.memberPosition ?? 0)} coins");
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

  void refWithdrawBS() async {
    if (pmm.directIncome == 0) {
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
    } else {
      await kycMOs.kycDR(pmm).get().then((ds) {
        if (ds.exists && ds.data() != null) {
          var km = KycModel.fromMap(ds.data()!);
          if (km.isKycVerified != true) {
            Get.bottomSheet(Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: const [
                    TextField(
                      keyboardType: TextInputType.number,
                    ),
                    Text(
                        "Your KYC is not verified.\nPlease get it verified to withdraw"),
                  ],
                ),
              ),
            ));
          } else {
            Get.bottomSheet(Container(
              height: 150,
              color: Colors.white,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                    "Your KYC is not verified.\nPlease get it verified to withdraw"),
              ),
            ));
          }
        }
      });
    }
  }

  Widget directWithdraw(PrimeMemberModel pm) {
    return Column(
      children: const [
        TextField(
          keyboardType: TextInputType.number,
        ),
        Text("Your KYC is not verified.\nPlease get it verified to withdraw"),
      ],
    );
  }
}
