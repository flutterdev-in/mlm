import 'package:advaithaunnathi/custom%20widgets/stream_builder_widget.dart';
import 'package:advaithaunnathi/services/firebase.dart';
import 'package:advaithaunnathi/prime_screens/direct%20income/direct_income_history.dart';
import 'package:flutter/material.dart';

import '../../model/user_model.dart';

class ReferalBenefitsScreen extends StatefulWidget {
  const ReferalBenefitsScreen({Key? key}) : super(key: key);

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
                SizedBox(height: 30, child: Center(child: Text("Debits"))),
              ],
              indicatorWeight: 2.5,
            ),
          )),
      body: TabBarView(
        controller: tabC,
        children: [
          StreamDocBuilder(
            docRef: authUserCR.doc(fireUser()!.uid),
            docBuilder: (context, snapshot) {
              var um = UserModel.fromMap(snapshot.data()!);
              return DirectIncomeHistory(um);
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("No debits recorded"),
          ),
        ],
      ),
    );
  }
}
