import 'package:advaithaunnathi/model/cart_model.dart';
import 'package:advaithaunnathi/model/product_model.dart';
import 'package:advaithaunnathi/shopping/z_cart/before_billing_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:advaithaunnathi/user/a_login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        child: Obx(() => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
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
            })),
      ),
    );
  }

  Widget itemsCartW(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    var isOutOfStock = false.obs;
    Future<num> getFinalPrice() async {
      num finalPrice = 0;
      for (var i in docs) {
        var cm = CartModel.fromMap(i.data());
        await cm.productDoc.get().then((ds) async {
          if (ds.exists) {
            var pm = ProductModel.fromMap(ds.data()!);
            finalPrice += cm.nos * (pm.price ?? pm.mrp);
            if (cm.nos > pm.stockAvailable) {
              isOutOfStock = true.obs;
            }
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
                                                imageUrl: pm.images!.first),
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
                                                      cm.nos > pm.stockAvailable
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
                                              if (cm.nos < pm.maxPerOrder &&
                                                  cm.nos < pm.stockAvailable) {
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
                                            (pm.price == null ||
                                                    pm.price == pm.mrp)
                                                ? Text(
                                                    "\u{20B9}${pm.mrp}",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "\u{20B9}${pm.price} ",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(width: 2),
                                                      Text("\u{20B9}${pm.mrp} ",
                                                          style: const TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough),
                                                          textScaleFactor: 0.9),
                                                      const SizedBox(width: 3),
                                                      Text(
                                                          "${((1 - pm.price! / pm.mrp) * 100).toStringAsFixed(0)}% off",
                                                          textScaleFactor: 0.9,
                                                          style: TextStyle(
                                                            color: Colors
                                                                .deepOrange
                                                                .shade600,
                                                          )),
                                                    ],
                                                  ),
                                            if (cm.nos > pm.stockAvailable)
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
        StreamBuilder<num>(
            stream: getFinalPrice().asStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(6, 6, 6, 5),
                  child: Card(
                    color: Colors.purple,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Total amount",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              Align(
                                alignment: Alignment.topRight,
                                child: Text(
                                    "\u{20B9} ${snapshot.data!.toStringAsFixed(0)}.0",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
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
                                      child: Text("Some of items\nout of stock",
                                          style: TextStyle(
                                            color: Colors.white,
                                          )),
                                    ),
                                  GFButton(
                                      color: Colors.white,
                                      type: GFButtonType.solid,
                                      onPressed: () async {
                                        if (!isOutOfStock.value) {
                                          // var am = await addressMOs
                                          //     .dummyAddressModel();
                                          // Get.to(() => AddressEditScreen(am));
                                          Get.to(() =>
                                              const AfterProceedPayGate());
                                        }
                                      },
                                      child: const Text("Proceed to Buy",
                                          style: TextStyle(
                                              color: Colors.purple,
                                              fontWeight: FontWeight.bold))),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const GFLoader(type: GFLoaderType.circle);
            }),
      ],
    );
  }
}

class AfterProceedPayGate extends StatelessWidget {
  const AfterProceedPayGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      initialData: FirebaseAuth.instance.currentUser,
      builder: (context, snapshot) {
        // User is not signed in
        if (!snapshot.hasData) {
          return
              // const SignInScreen(
              //   providerConfigs: [
              //     GoogleProviderConfiguration(
              //         clientId: "1:237115759240:android:57b787e3a03aca69fc9d3d"),
              //   ],
              // );
              const GoogleLoginView();
        } else if (snapshot.hasData && snapshot.data != null) {
          return const BeforeBillingScreen();
        }
        return const CircularProgressIndicator();

        // Render your application if authenticated
      },
    );
  }
}
