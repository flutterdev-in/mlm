import 'package:advaithaunnathi/model/cart_model.dart';
import 'package:advaithaunnathi/model/product_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        color: Colors.black12,
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: userCartCR.value.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text("Network error"));
              }
              if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No items in cart"));
              }
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                return itemsCartW(snapshot.data!.docs);
              }
              return const GFLoader(type: GFLoaderType.circle);
            }),
      ),
    );
  }

  Widget itemsCartW(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    Future<num> getFinalPrice() async {
      num finalPrice = 0;
      for (var i in docs) {
        var cm = CartModel.fromMap(i.data());
        await cm.productDoc.get().then((ds) async {
          if (ds.exists) {
            var pm = ProductModel.fromMap(ds.data()!);
            finalPrice += cm.nos * (pm.price ?? pm.mrp);
          }
        });
      }
      return finalPrice;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
              "Shopping cart (${docs.length} ${docs.length == 1 ? 'item' : 'items'})",
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                var cm = CartModel.fromMap(docs[index].data());
                cm.thisDR = docs[index].reference;
                return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: cm.productDoc.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.data() != null) {
                        var pm = ProductModel.fromMap(snapshot.data!.data()!);
                        pm.docRef = snapshot.data!.reference;
                        return GFListTile(
                          titleText: pm.name,
                          avatar: GFAvatar(
                            backgroundImage: pm.images != null
                                ? CachedNetworkImageProvider(pm.images!.first)
                                : null,
                          ),
                          icon: GFIconButton(
                              icon: const Icon(MdiIcons.close),
                              onPressed: () async {
                                await cm.thisDR!.delete();
                              }),
                        );
                      }
                      return const ListTile(
                        title: GFLoader(type: GFLoaderType.square),
                      );
                    });
              }),
        ),
        StreamBuilder<num>(
            stream: getFinalPrice().asStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.toStringAsFixed(0));
              }

              return const GFLoader(type: GFLoaderType.circle);
            }),
      ],
    );
  }
}
