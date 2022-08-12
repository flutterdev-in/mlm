import 'package:advaithaunnathi/model/cart_model.dart';
import 'package:advaithaunnathi/model/product_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:getwidget/getwidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProductsGridList extends StatelessWidget {
  const ProductsGridList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder<Map<String, dynamic>>(
        pageSize: 6,
        query: productMOS.productsCR
            .orderBy(productMOS.uploadTime, descending: true),
        builder: (context, snapshot, _) {
          if (snapshot.hasData && snapshot.docs.isNotEmpty) {
            return GridView.builder(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.68),
              itemCount: snapshot.docs.length,
              itemBuilder: (context, index) {
                if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                  // Tell FirestoreQueryBuilder to try to obtain more items.
                  // It is safe to call this function from within the build method.
                  snapshot.fetchMore();
                }
                var pm = ProductModel.fromMap(snapshot.docs[index].data());
                pm.docRef = snapshot.docs[index].reference;
                return DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black12,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        
                        children: [
                          SizedBox(
                            height: 120,
                            child: CachedNetworkImage(
                                imageUrl: pm.images?.first ?? ""),
                          ),
                          const SizedBox(height: 8),
                          Text(pm.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textScaleFactor: 0.95),
                          const SizedBox(height: 3),
                          (pm.price == null || pm.price == pm.mrp)
                              ? Text(
                                  "\u{20B9}${pm.mrp}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )
                              : Row(
                                  children: [
                                    Text(
                                      "\u{20B9}${pm.price}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 2),
                                    Text("\u{20B9}${pm.mrp}",
                                        style: const TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough),
                                        textScaleFactor: 0.9),
                                  ],
                                ),
                          const SizedBox(height: 5),
                          Align(
                              alignment: Alignment.bottomCenter,
                              child: addToCart(pm)),
                        ],
                      ),
                    ));
              },
            );
          }
          return const CircularProgressIndicator();
        });
  }

  Widget addToCart(ProductModel pm) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: cartMOS.authUserCartCR
            .where(cartMOS.productDoc, isEqualTo: pm.docRef!.id)
            .limit(1)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const GFLoader(type: GFLoaderType.square);
          }
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            var cm = CartModel.fromMap(snapshot.data!.docs.first.data());
            cm.thisDR = snapshot.data!.docs.first.reference;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GFIconButton(
                    type: GFButtonType.outline,
                    size: GFSize.SMALL,
                    color: Colors.purple,
                    icon: const Icon(MdiIcons.minus),
                    onPressed: () async {
                      await Future.delayed(const Duration(microseconds: 900));
                      if (cm.nos == 1) {
                      await  cm.thisDR!.delete();
                      } else {
                      await  cm.thisDR!.update({cartMOS.nos: cm.nos - 1});
                      }
                    }),
                GFIconButton(
                    size: GFSize.SMALL,
                    color: Colors.purple,
                    icon: Text(
                      cm.nos.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    onPressed: ()  {}),
                GFIconButton(
                  color: Colors.purple,
                  type: GFButtonType.outline,
                  size: GFSize.SMALL,
                  icon: const Icon(MdiIcons.plus),
                  onPressed: () async {
                    await Future.delayed(const Duration(microseconds: 900));
                   await cm.thisDR!.update({cartMOS.nos: cm.nos + 1});
                  },
                ),
              ],
            );
          }
          return Align(
            child: GFButton(
                position: GFPosition.end,
                elevation: 0,
                color: Colors.black87,
                type: GFButtonType.outline,
                onPressed: () async {
                  await Future.delayed(const Duration(microseconds: 900));
                  await cartMOS.authUserCartCR.doc(pm.docRef!.id).set(CartModel(
                          nos: 1,
                          productDoc: pm.docRef!,
                          lastTime: DateTime.now())
                      .toMap());
                },
                child: const Text("Add to cart")),
          );
        });
  }
}
