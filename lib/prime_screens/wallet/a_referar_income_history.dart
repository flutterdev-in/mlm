import 'package:advaithaunnathi/custom%20widgets/firestore_listview_builder.dart';
import 'package:advaithaunnathi/model/prime_member_model.dart';
import 'package:advaithaunnathi/custom%20widgets/stream_builder_widget.dart';
import 'package:advaithaunnathi/model/withdraw_model.dart';
import 'package:advaithaunnathi/prime_screens/direct%20income/direct_income_history.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';

class ReferalBenefitsScreen extends StatefulWidget {
  PrimeMemberModel pmm;
  ReferalBenefitsScreen(this.pmm, {Key? key}) : super(key: key);

  @override
  State<ReferalBenefitsScreen> createState() => _ReferalBenefitsScreenState();
}

class _ReferalBenefitsScreenState extends State<ReferalBenefitsScreen>
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
          title: const Text("Referal benefits"),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(32.0),
            child: TabBar(
              controller: tabC,
              indicatorColor: Colors.white70,
              tabs: const [
                SizedBox(height: 30, child: Center(child: Text("Credits"))),
                SizedBox(height: 30, child: Center(child: Text("Withdrawls")))
              ],
              indicatorWeight: 2.5,
            ),
          )),
      body: TabBarView(
        controller: tabC,
        children: [
          StreamDocBuilder(
            stream: widget.pmm.docRef!,
            builder: (snapshot) {
              widget.pmm = PrimeMemberModel.fromMap(snapshot.data()!);
              widget.pmm.docRef = snapshot.reference;
              return DirectIncomeHistory(widget.pmm);
            },
          ),
          FirestoreListViewBuilder(
            query: withdrawMOs.withdrawalsHistoryCR(widget.pmm),
            builder: (p0, qds) {
              var wm = WithdrawModel.fromMap(qds.data());
              return GFListTile(
                color: Colors.blue.shade100,
                shadow: const BoxShadow(),
                titleText:
                    DateFormat("dd MMM yyyy, h:mm a").format(wm.requestedTime),
                icon: Text("₹ ${wm.amount}"),
                subTitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    wm.isSettled == true
                        ? const Text('Settled',
                            style: TextStyle(color: Colors.green))
                        : const Text('Under Progress',
                            style: TextStyle(color: Colors.red)),
                    const SizedBox(height: 10),
                    if (wm.adminComments != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "** ${wm.adminComments!}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
