import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:getwidget/components/loader/gf_loader.dart';

class StreamListDocsBuilder extends StatelessWidget {
  final Query<Map<String, dynamic>> query;
  final Widget Function(List<QueryDocumentSnapshot<Map<String, dynamic>>> snaps)
      builder;
  final Widget? loadingW;
  final Widget? noResultsW;
  final Widget? errorW;
  final int pageSize;

  const StreamListDocsBuilder({
    Key? key,
    required this.query,
    required this.builder,
    this.loadingW,
    this.noResultsW,
    this.errorW,
    this.pageSize = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder<Map<String, dynamic>>(
        pageSize: pageSize,
        query: query,
        builder: (context, snapshot, _) {
          if (snapshot.hasData && snapshot.docs.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: noResultsW ?? const Text("No results"),
            );
          }
          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: errorW ?? const Text("Error while fetching data"),
            );
          }
          if (snapshot.hasData && snapshot.docs.isNotEmpty) {
            return builder(snapshot.docs);
          }
          return loadingW ?? const GFLoader();
        });
  }
}
