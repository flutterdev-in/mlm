import 'package:advaithaunnathi/custom%20widgets/bottom_bar_login.dart';
import 'package:advaithaunnathi/services/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:advaithaunnathi/dart/rx_variables.dart';
import 'package:advaithaunnathi/model/cart_model.dart';
import 'package:advaithaunnathi/model/product_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:advaithaunnathi/shopping/z_cart/before_billing_screen.dart';
import 'package:advaithaunnathi/user/a_login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'cart_screen.dart';

class CartItemsW extends StatelessWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> cartDocSnaps;
  CartItemsW(this.cartDocSnaps, {Key? key}) : super(key: key);
  final isOutOfStock = false.obs;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AddressW(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
              "Shopping cart (${cartDocSnaps.length} ${cartDocSnaps.length == 1 ? 'item' : 'items'})",
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: cartDocSnaps.length,
              itemBuilder: (context, index) {
                var cm = CartModel.fromMap(cartDocSnaps[index].data());
                cm.thisDR = cartDocSnaps[index].reference;
                return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: cm.productDoc.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.data() != null) {
                        var pm = ProductModel.fromMap(snapshot.data!.data()!);
                        pm.docRef = snapshot.data!.reference;
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: Card(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: CachedNetworkImage(
                                                imageUrl: pm.images!.first.url),
                                          )),
                                      const SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GFIconButton(
                                              shape: GFIconButtonShape.circle,
                                              type: GFButtonType.outline,
                                              size: GFSize.SMALL,
                                              color: Colors.purple,
                                              icon: const Icon(MdiIcons.minus),
                                              onPressed: () async {
                                                await Future.delayed(
                                                    const Duration(
                                                        microseconds: 900));
                                                if (cm.nos > 1) {
                                                  await cm.thisDR!.update({
                                                    cartMOS.nos: cm.nos - 1
                                                  });
                                                }
                                              }),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 0, 8, 0),
                                            child: Text(
                                              cm.nos.toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.purple,
                                                  decoration:
                                                      cm.nos > pm.listPrices!.first.stockAvailable
                                                          ? TextDecoration
                                                              .lineThrough
                                                          : null),
                                            ),
                                          ),
                                          GFIconButton(
                                            shape: GFIconButtonShape.circle,
                                            color: Colors.purple,
                                            type: GFButtonType.outline,
                                            size: GFSize.SMALL,
                                            icon: const Icon(MdiIcons.plus),
                                            onPressed: () async {
                                              await Future.delayed(
                                                  const Duration(
                                                      microseconds: 900));
                                              if (cm.nos < pm.listPrices!.first.maxPerOrder &&
                                                  cm.nos < pm.listPrices!.first.stockAvailable) {
                                                await cm.thisDR!.update(
                                                    {cartMOS.nos: cm.nos + 1});
                                              }
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 12, right: 17),
                                              child: Text(pm.name,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                            const SizedBox(height: 15),
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
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "\u{20B9}${pm.listPrices?.first.price}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                          "\u{20B9}${pm.listPrices?.first.mrp}",
                                          style: const TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough),
                                          textScaleFactor: 0.9),
                                      const SizedBox(width: 3),
                                      Text(
                                          "${((1 - pm.listPrices!.first.price! / pm.listPrices!.first.mrp) * 100).toStringAsFixed(0)}% off",
                                          textScaleFactor: 0.9,
                                          style: TextStyle(
                                            color: Colors.deepOrange.shade600,
                                          )),
                                    ],
                                  ),
                                            if (cm.nos > pm.listPrices!.first.stockAvailable)
                                              const Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 8, 0, 0),
                                                child: Text("Out of stock",
                                                    style: TextStyle(
                                                        color: Colors.red)),
                                              ),
                                          ],
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: GFIconButton(
                                              // color: GFColors.WHITE,
                                              size: GFSize.SMALL,
                                              color: Colors.transparent,
                                              // type: GFButtonType.transparent,
                                              icon: const Icon(MdiIcons.close,
                                                  size: 23,
                                                  color: Colors.black),
                                              onPressed: () async {
                                                await Future.delayed(
                                                    const Duration(
                                                        microseconds: 900));
                                                await cm.thisDR!.delete();
                                              }),
                                        ),
                                      ],
                                    ),
                                  )
                                ]),
                          )),
                        );
                      }
                      return const ListTile(
                        title: GFLoader(type: GFLoaderType.square),
                      );
                    });
              }),
        ),
        StreamBuilder<List<num>>(
            stream: getFinalPrices().asStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Card(
                  // color: Colors.purple,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "\u{20B9} ${snapshot.data![0].toStringAsFixed(0)}.0 ",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              if (snapshot.data![0] < snapshot.data![1])
                                Text(
                                    "${((1 - snapshot.data![0] / snapshot.data![1]) * 100).toStringAsFixed(0)}% off",
                                    style: const TextStyle(
                                      color: Colors.blue,
                                    ),
                                    textScaleFactor: 0.9),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Obx(() => Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (isOutOfStock.value)
                                  const Padding(
                                    padding: EdgeInsets.only(right: 20),
                                    child: Text("Some of items\nout of stock"),
                                  ),
                                GFButton(
                                    color: GFColors.DANGER,
                                    type: GFButtonType.solid,
                                    onPressed: () async {
                                      if (!isOutOfStock.value) {
                                        await Future.delayed(
                                            const Duration(milliseconds: 500));
                                        if (fireUser() == null) {
                                          bottomBarLogin();
                                        }

                                        // isLoading.value = true;
                                        // var am = await addressMOs
                                        //     .dummyAddressModel();
                                        // isLoading.value = false;
                                        // Get.to(() => AddressEditScreen(am));
                                        // Get.to(() => AfterProceedPayGate(
                                        //     cartDocSnaps: cartDocSnaps,
                                        //     totalPrice: snapshot.data![0],
                                        //     totalMrp: snapshot.data![1]));
                                      }
                                    },
                                    child: Obx(() => isLoading.value
                                        ? const GFLoader()
                                        : const Text(" Place Order "))),
                              ],
                            )),
                      ),
                    ],
                  ),
                );
              }
              return const GFLoader(type: GFLoaderType.circle);
            }),
      ],
    );
  }

  Future<List<num>> getFinalPrices() async {
    num finalPrice = 0;
    num totalMrp = 0;
    for (var i in cartDocSnaps) {
      var cm = CartModel.fromMap(i.data());
      await cm.productDoc.get().then((ds) async {
        if (ds.exists) {
          var pm = ProductModel.fromMap(ds.data()!);
          finalPrice += cm.nos * (pm.listPrices?.first.price ?? pm.listPrices?.first.mrp??0);
          totalMrp += cm.nos * pm.listPrices!.first.mrp;
          if (cm.nos > pm.listPrices!.first.stockAvailable) {
            isOutOfStock.value = true;
          }
        }
      });
    }
    return [finalPrice, totalMrp];
  }
}

class AfterProceedPayGate extends StatelessWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> cartDocSnaps;
  final num totalPrice;
  final num totalMrp;
  const AfterProceedPayGate({
    Key? key,
    required this.cartDocSnaps,
    required this.totalPrice,
    required this.totalMrp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      initialData: FirebaseAuth.instance.currentUser,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const GoogleLoginView();
        } else if (snapshot.hasData && snapshot.data != null) {
          return BeforeBillingScreen(
              cartDocSnaps: cartDocSnaps,
              totalPrice: totalPrice,
              totalMrp: totalMrp);
        }
        return const CircularProgressIndicator();

        // Render your application if authenticated
      },
    );
  }
}
