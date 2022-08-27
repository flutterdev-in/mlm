import 'package:advaithaunnathi/model/prime_member_model.dart';
import 'package:advaithaunnathi/prime_screens/wallet/a_direct_wallet_widget.dart';
import 'package:advaithaunnathi/prime_screens/wallet/b_matrix_wallet_widget.dart';
import 'package:flutter/material.dart';

class WalletsScreen extends StatefulWidget {
  final PrimeMemberModel pmm;
  const WalletsScreen(this.pmm, {Key? key}) : super(key: key);

  @override
  State<WalletsScreen> createState() => _WalletsScreenState();
}

class _WalletsScreenState extends State<WalletsScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabC;
  @override
  void initState() {
    super.initState();
    tabC = TabController(initialIndex: 0, length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Wallet"),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(36.0),
            child: TabBar(
              controller: tabC,
              indicatorColor: Colors.white70,
              tabs: const [
                SizedBox(height: 30, child: Center(child: Text("Promotional"))),
                SizedBox(height: 30, child: Center(child: Text("Referral"))),
              ],
              indicatorWeight: 2.5,
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(2.0),
        child: TabBarView(
          controller: tabC,
          children: [
            MatrixWalletWidget(widget.pmm),
            DirectWalletWidget(widget.pmm),
          ],
        ),
      ),
    );
  }
}




// class WalletHomeScreen extends StatelessWidget {
//   PrimeMemberModel pmm;
//   WalletHomeScreen(this.pmm, {Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Wallet"),
//       ),
//       body: Column(
//         children: [
//           StreamDocBuilder(
//             docRef: pmm.docRef!,
//             builder: (docSnap) {
//               pmm = PrimeMemberModel.fromMap(docSnap.data()!);
//               pmm.docRef = docSnap.reference;
//               return bodyW(pmm);
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget bodyW(PrimeMemberModel pm) {
//     return Column(
//       children: [
//         const SizedBox(height: 20),
//         Padding(
//           padding: const EdgeInsets.all(4.0),
//           child: Card(
//             shadowColor: Colors.green.shade200,
//             elevation: 2,
//             child: DirectWalletWidget(pmm),
//           ),
//         ),
//         const SizedBox(height: 20),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Card(
//             shadowColor: Colors.green.shade200,
//             elevation: 2,
//             child: MatrixWalletWidget(pmm),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget directWithdraw(PrimeMemberModel pm) {
//     var errorAmount = "".obs;
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Obx(() => TextField(
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(
//                   labelText: "Withdrawal amount",
//                   errorText:
//                       errorAmount.value.isEmpty ? errorAmount.value : null,
//                 ),
//                 onChanged: (value) {
//                   if (value.isNum) {
//                     int amount = num.tryParse(value)!.toInt();
//                     afterDebounce(after: () async {});
//                   } else {
//                     errorAmount.value = "Enter valid amount";
//                   }
//                 },
//               )),
//         ),
//         const Text(
//             "Your KYC is not verified.\nPlease get it verified to withdraw"),
//       ],
//     );
//   }

//   void redeemCoins() {
//     Get.bottomSheet(Container(
//       color: Colors.white,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: const [TextField()],
//         ),
//       ),
//     ));
//   }
// }
