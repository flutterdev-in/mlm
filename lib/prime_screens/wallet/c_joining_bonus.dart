import 'package:advaithaunnathi/model/prime_member_model.dart';
import 'package:advaithaunnathi/model/withdraw_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:getwidget/getwidget.dart';

import '../../dart/const_global_objects.dart';
import '../../matrix/net_matrix_income.dart';
import '../../model/kyc_model.dart';

class JoiningBonusWidget extends StatelessWidget {
  final PrimeMemberModel pmm;
  const JoiningBonusWidget(this.pmm, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GFListTile(
          padding: const EdgeInsets.fromLTRB(0, 12, 3, 12),
          margin: const EdgeInsets.all(8),
          color: Colors.green.shade100,
          titleText: "Joining bonus",
          subTitle: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Credits = 1000 coins"),
                Text("Debits = 0 coins"),
              ],
            ),

            // StreamSingleQueryBuilder(
            //     query: primeMOs
            //         .primeMembersCR()
            //         .orderBy(primeMOs.memberPosition, descending: true),
            //     builder: (snapshot) {
            //       var pmLast = PrimeMemberModel.fromMap(snapshot.data());
            //       return StreamBuilder<List<int>>(
            //           stream:
            //               withdrawMOs.streamWithdrawalAmountList(pmm, false),
            //           builder: (context, snapshot) {
            //             int? amount;
            //             if (snapshot.hasData) {
            //               amount = withdrawMOs.listAmount(snapshot.data!);
            //             }
            //             return Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 Text(
            //                     "Credits = ${matrixIncome(pmm.memberPosition ?? 0, pmLast.memberPosition ?? 0)}"),
            //                 Text("Debits = ${amount ?? ''}"),
            //               ],
            //             );
            //           });
            //     }),
          ),
        ),
        GFButton(
          onPressed: () async {},
          child: const Text("Redeem Coins"),
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: [
        //     GFButton(
        //       onPressed: () async {},
        //       child: const Text("Redeem Coins"),
        //     ),
        //     GFButton(
        //       onPressed: () async {},
        //       child: const Text("Withdraw"),
        //     ),
        //   ],
        // ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 30, 5, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                    "Joining coins can be Reedem either 10% per bill or 1000 which ever is lower in myshopau"),
                
              ],
            ),
          ),
        ),
      ],
    );
  }

  //
  Future<void> matrixWithdrawBS() async {
    var isKycVerified = await kycMOs.isPrimeKycVerified(pmm.userName!);
    var mi = await withdrawMOs.matrixIncomeF(pmm.memberPosition!);

    if (isKycVerified != true || needDirectRef(mi.toInt()) != 0) {
      Get.bottomSheet(Container(
        height: 250,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isKycVerified != true)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      "$stopEmoji   Your KYC is not verified.\nPlease get it verified to withdraw"),
                ),
              if (needDirectRef(mi.toInt()) != 0)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "$stopEmoji   You are in Level ${currentLevel(mi.toInt())}, you need to have ${needDirectRef(mi.toInt())} direct referrals to eligible for withdraw (current direct referrels = ${pmm.directIncome})",
                  ),
                ),
            ],
          ),
        ),
      ));
    }
  }
}
