import 'package:advaithaunnathi/custom%20widgets/bottom_bar_login.dart';
import 'package:advaithaunnathi/dart/const_global_objects.dart';
import 'package:advaithaunnathi/services/firebase.dart';
import 'package:advaithaunnathi/dart/repeatFunctions.dart';
import 'package:advaithaunnathi/model/cart_model.dart';
import 'package:advaithaunnathi/model/product_model.dart';
import 'package:advaithaunnathi/shopping/Product%20screen/product_view_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../custom widgets/auth_stream_builder.dart';
import '../../custom widgets/stream_single_query_builder.dart';

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
            return ListView.builder(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              // gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              //     childAspectRatio: 0.9, maxCrossAxisExtent: Get.width / 2),
              // const SliverGridDelegateWithFixedCrossAxisCount(
              //     crossAxisCount: 2),
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
                      border: Border.all(color: Colors.black12, width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              child: SizedBox(
                                height: 120,
                                child: CachedNetworkImage(
                                    imageUrl: pm.images?.first.url ?? "",
                                    fit: BoxFit.fill),
                              ),
                              onTap: () async {
                                await waitMilli(200);
                                Get.to(() => ProductViewScreen(pm));
                              },
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(pm.name),
                                  const SizedBox(height: 10),
                                  if (pm.listPrices != null)
                                    (pm.listPrices!.first.mrp ==
                                            pm.listPrices!.first.price)
                                        ? Text(
                                            "\u{20B9}${pm.listPrices?.first.mrp}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "\u{20B9}${pm.listPrices?.first.price}",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                  "\u{20B9}${pm.listPrices?.first.mrp}",
                                                  style: const TextStyle(
                                                      decoration: TextDecoration
                                                          .lineThrough),
                                                  textScaleFactor: 0.9),
                                              const SizedBox(width: 10),
                                              Text(
                                                  "${((1 - pm.listPrices!.first.price! / pm.listPrices!.first.mrp) * 100).toStringAsFixed(0)}% off",
                                                  textScaleFactor: 0.9,
                                                  style: TextStyle(
                                                    color: Colors
                                                        .deepOrange.shade600,
                                                  )),
                                            ],
                                          ),
                                  const SizedBox(height: 5),
                                  Align(
                                      alignment: Alignment.bottomRight,
                                      child: addToCart(pm)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ));
              },
            );
          }
          if (snapshot.hasData && snapshot.docs.isEmpty) {
            return const Text("Zero data");
          }
          if (snapshot.hasError) {
            return const Text("No data");
          }
          return const GFLoader();
        });
  }

  //
  Widget addToCart(ProductModel pm) {
    var cartW = GFButton(
      position: GFPosition.end,
      elevation: 0,
      color: Colors.black87,
      type: GFButtonType.outline,
      child: const Text("Add to cart"),
      onPressed: () async {
        await Future.delayed(const Duration(microseconds: 900));
        var cartM = CartModel(
                nos: 1,
                selectedPriceIndex: 0,
                productDR: pm.docRef!,
                lastTime: DateTime.now())
            .toMap();
        if (fireUser() != null) {
          await authUserCR
              .doc(fireUser()!.uid)
              .collection(cart)
              .doc(pm.docRef!.id)
              .set(cartM);
        } else {
          bottomBarLogin();
        }
      },
    );

    return AuthStreamBuilder(
        unAuthW: cartW,
        builder: (user) {
          return StreamSingleQueryBuilder(
            noResultsW: cartW,
            loadingW: cartW,
            errorW: cartW,
            query: cartMOS
                .cartCR(user)
                .where(cartMOS.productDR, isEqualTo: pm.docRef!.id),
            builder: (snapshot) {
              var cm = CartModel.fromMap(snapshot.data());
              cm.thisDR = snapshot.reference;
              return Column(
                children: [
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GFIconButton(
                          type: GFButtonType.outline,
                          size: GFSize.SMALL,
                          color: Colors.purple,
                          icon: const Icon(MdiIcons.minus),
                          onPressed: () async {
                            await Future.delayed(
                                const Duration(microseconds: 900));
                            if (pm.listPrices!.first.stockAvailable > 1) {
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
                              decoration:
                                  cm.nos > pm.listPrices!.first.stockAvailable
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
                          await Future.delayed(
                              const Duration(microseconds: 900));
                          if (cm.nos < pm.listPrices!.first.maxPerOrder &&
                              cm.nos < pm.listPrices!.first.stockAvailable) {
                            await cm.thisDR!.update({cartMOS.nos: cm.nos + 1});
                          }
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        });
  }
}
