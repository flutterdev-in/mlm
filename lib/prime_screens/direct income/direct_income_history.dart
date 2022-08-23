import 'package:advaithaunnathi/custom%20widgets/firestore_listview_builder.dart';
import 'package:advaithaunnathi/services/firebase.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

import '../../model/user_model.dart';

class DirectIncomeHistory extends StatelessWidget {
  final UserModel um;
  final bool wantAppBar;
  const DirectIncomeHistory(this.um, {Key? key, this.wantAppBar = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: wantAppBar ? AppBar(title: const Text("Direct referals")) : null,
      body: FirestoreListViewBuilder(
        query: authUserCR
            .where(uMOs.refMemberId, isEqualTo: um.memberID)
            .orderBy(uMOs.memberPosition, descending: false),
        builder: (context, snapshot) {
          var umMem = UserModel.fromMap(snapshot.data());
          return GFListTile(
            avatar: GFAvatar(
                backgroundImage:
                    CachedNetworkImageProvider(umMem.profilePhotoUrl ?? "")),
            title: Text(umMem.profileName),
            icon: const Text("+500"),
          );
        },
        noResultsW: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("No direct referals you have"),
        ),
      ),
    );
  }
}
