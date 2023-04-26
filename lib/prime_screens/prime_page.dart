import 'package:advaithaunnathi/custom%20widgets/firestore_listview_builder.dart';
import 'package:advaithaunnathi/models/prime_member.dart';
import 'package:advaithaunnathi/services/firebase.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

import '../custom widgets/text_widget.dart';

class PrimePage extends StatelessWidget {
  const PrimePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(fireUser()?.phoneNumber?.replaceAll("+91", "").trim());
    return Scaffold(
      appBar: AppBar(title: const TextW('AU Prime')),
      body: FirestoreListViewBuilder(
          query: PrimeMember.col_ref.where(PrimeMember.phone_key,
              isEqualTo: fireUser()?.phoneNumber?.replaceAll("+91", "").trim()),
          builder: (context, snapshot) {
            var pm = PrimeMember.fromDS(snapshot);
            return GFListTile(
              shadow: const BoxShadow(color: Colors.transparent),
              title: TextW(pm.user_name ?? "username"),
            );
          }),
    );
  }
}

// 7032046133
// 7386391559
