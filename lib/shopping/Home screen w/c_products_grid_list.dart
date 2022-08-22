import 'package:advaithaunnathi/dart/const_global_objects.dart';
import 'package:advaithaunnathi/dart/firebase.dart';
import 'package:advaithaunnathi/dart/repeatFunctions.dart';
import 'package:advaithaunnathi/hive/hive_boxes.dart';
import 'package:advaithaunnathi/model/cart_model.dart';
import 'package:advaithaunnathi/model/product_model.dart';
import 'package:advaithaunnathi/shopping/Product%20screen/product_view_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:get/get.dart';
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
                          InkWell(
                            child: SizedBox(
                              height: 120,
                              child: CachedNetworkImage(
                                  imageUrl: pm.images?.first ?? ""),
                            ),
                            onTap: () async {
                              await waitMilli(200);
                              Get.to(() => ProductViewScreen(pm));
                            },
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                    const SizedBox(width: 3),
                                    Text(
                                        "${((1 - pm.price! / pm.mrp) * 100).toStringAsFixed(0)}% off",
                                        textScaleFactor: 0.9,
                                        style: TextStyle(
                                          color: Colors.deepOrange.shade600,
                                        )),
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
          return const GFLoader();
        });
  }

  //
  Widget addToCart(ProductModel pm) {
    return Obx(() => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: userCartCR.value
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
            return Column(
              children: [
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GFIconButton(
                        type: GFButtonType.outline,
                        size: GFSize.SMALL,
                        color: Colors.purple,
                        icon: const Icon(MdiIcons.minus),
                        onPressed: () async {
                          await Future.delayed(
                              const Duration(microseconds: 900));
                          if (pm.stockAvailable > 1) {
                            if (cm.nos == 1) {
                              await cm.thisDR!.delete();
                            } else {
                              await cm.thisDR!
                                  .update({cartMOS.nos: cm.nos - 1});
                            }
                          }
                        }),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Text(
                        cm.nos.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                            decoration: cm.nos > pm.stockAvailable
                                ? TextDecoration.lineThrough
                                : null),
                      ),
                    ),
                    GFIconButton(
                      color: Colors.purple,
                      type: GFButtonType.outline,
                      size: GFSize.SMALL,
                      icon: const Icon(MdiIcons.plus),
                      onPressed: () async {
                        await Future.delayed(const Duration(microseconds: 900));
                        if (cm.nos < pm.maxPerOrder &&
                            cm.nos < pm.stockAvailable) {
                          await cm.thisDR!.update({cartMOS.nos: cm.nos + 1});
                        }
                      },
                    ),
                  ],
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
                  var cartM = CartModel(
                          nos: 1,
                          productDoc: pm.docRef!,
                          lastTime: DateTime.now())
                      .toMap();
                  if (fireUser != null || userBoxUID != null) {
                    await userCartCR.value.doc(pm.docRef!.id).set(cartM);
                  } else if (userBoxUID == null) {
                    await nonAuthUserCR.add({}).then((dr) async {
                      await userBox.put(boxStrings.userUID, dr.id);
                      userCartCR.value =
                          nonAuthUserCR.doc(dr.id).collection(cart);
                      await dr.collection(cart).doc(pm.docRef!.id).set(cartM);
                    });
                  }
                },
                child: const Text("Add to cart")),
          );
        }));
  }
}
