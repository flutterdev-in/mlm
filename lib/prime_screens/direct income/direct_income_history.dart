import 'package:advaithaunnathi/dart/firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';

import '../../model/user_model.dart';

class DirectIncomeHistory extends StatelessWidget {
  final UserModel um;
  const DirectIncomeHistory(this.um, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Wallet income")),
      body: FirestoreListView<Map<String, dynamic>>(
          query: authUserCR
              .where(umos.refMemberId, isEqualTo: um.memberID)
              .orderBy(umos.memberPosition, descending: false),
          itemBuilder: (context, snapshot) {
            var umMem = UserModel.fromMap(snapshot.data());
            return ListTile(
              title: Text(umMem.profileName),
              trailing: const Text("+500"),
            );
          }),
    );
  }
}
