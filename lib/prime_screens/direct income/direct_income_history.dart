import 'package:advaithaunnathi/custom%20widgets/firestore_listview_builder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

import '../../model/prime_member_model.dart';

class DirectIncomeHistory extends StatelessWidget {
  final PrimeMemberModel pmm;
  final bool wantAppBar;
  const DirectIncomeHistory(this.pmm, {Key? key, this.wantAppBar = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: wantAppBar ? AppBar(title: const Text("Direct referals")) : null,
      body: FirestoreListViewBuilder(
        query: primeMOs
            .primeMembersCR()
            .where(primeMOs.refMemberId, isEqualTo: pmm.memberID)
            .orderBy(primeMOs.memberPosition, descending: false),
        builder: (context, snapshot) {
          var refPMM = PrimeMemberModel.fromMap(snapshot.data());
          return GFListTile(
            avatar: GFAvatar(
                backgroundImage: refPMM.profilePhotoUrl != null
                    ? CachedNetworkImageProvider(refPMM.profilePhotoUrl!)
                    : null),
            title: Text(refPMM.name ?? ""),
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
