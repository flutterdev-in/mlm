import 'package:advaithaunnathi/model/prime_member_model.dart';
import 'package:advaithaunnathi/model/withdraw_model.dart';
import 'package:advaithaunnathi/prime_screens/wallet/a_referar_income_history.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:getwidget/getwidget.dart';

import '../../dart/const_global_objects.dart';
import '../../model/kyc_model.dart';

class DirectWalletWidget extends StatelessWidget {
  PrimeMemberModel pmm;
  DirectWalletWidget(this.pmm, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GFListTile(
          padding: const EdgeInsets.fromLTRB(0, 12, 3, 12),
          margin: const EdgeInsets.all(8),
          color: Colors.green.shade100,
          titleText: "Referal benefits",
          subTitle: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Credits = ${pmm.directIncome * 500}"),
                StreamBuilder<List<int>>(
                    stream: withdrawMOs.streamWithdrawalAmountList(pmm, false),
                    builder: (context, snapshot) {
                      int? amount;
                      if (snapshot.hasData) {
                        amount = withdrawMOs.listAmount(snapshot.data!);
                      }
                      return Text("Debits = ${amount ?? ''}");
                    }),
              ],
            ),
          ),
          onTap: () {
            Get.to(() => ReferalBenefitsScreen(pmm));
          },
        ),
        GFButton(
          color: Colors.green,
          onPressed: () {},
          child: const Text("Withdraw"),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 30, 5, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<bool?>(
                    future: kycMOs.isPrimeKycVerified(pmm.userName!),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var isKycVerified = snapshot.data;
                        if (isKycVerified != true) {
                          return const Text(
                              "$stopEmoji   Your KYC is not verified.\nPlease get it verified to withdraw");
                        } else {
                          return const SizedBox();
                        }
                      }
                      return const Text(
                          "$stopEmoji   Your KYC is not verified.\nPlease get it verified to withdraw");
                    }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  //
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
      Get.bottomSheet(Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: const [
              TextField(
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ));
    }
  }
}
