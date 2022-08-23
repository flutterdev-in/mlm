import 'package:advaithaunnathi/custom%20widgets/bottom_bar_login.dart';
import 'package:advaithaunnathi/dart/colors.dart';
import 'package:advaithaunnathi/services/firebase.dart';
import 'package:advaithaunnathi/dart/repeatFunctions.dart';
import 'package:advaithaunnathi/model/address_model.dart';
import 'package:advaithaunnathi/model/cart_model.dart';
import 'package:advaithaunnathi/shopping/addresses/address_edit_screen.dart';
import 'package:advaithaunnathi/shopping/z_cart/cart_items_w.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:get/get.dart';
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
        color: const Color.fromARGB(10, 0, 0, 0),
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
                return CartItemsW(snapshot.data!.docs);
              }
              return const GFLoader(type: GFLoaderType.circle);
            })),
      ),
    );
  }
}

class AddressW extends StatelessWidget {
  const AddressW({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => !userCartCR.value.path.contains(nonAuthUserCR.path)
        ? StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: addressMOs.addressCR
                .orderBy(addressMOs.updatedTime, descending: true)
                .limit(1)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return waitingW();
              }
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                var am = AddressModel.fromMap(snapshot.data!.docs.first.data());
                return validAaddressW(am);
              }
              return addAddressW();
            })
        : GFListTile(
            color: Colors.cyan,
            titleText: "Login to add delivery address",
            icon: const Icon(MdiIcons.gestureDoubleTap),
            onTap: () async {
              await Future.delayed(const Duration(milliseconds: 500));
              if (fireUser() == null) {
                bottomBarLogin();
              }
            },
          ));
  }

  Widget validAaddressW(AddressModel am) {
    return Stack(
      children: [
        GFListTile(
          color: Colors.white,
          avatar: const Icon(MdiIcons.homeImportOutline),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Deliver to",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline)),
            ],
          ),
          subTitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(am.name),
              Text(
                "${am.house}, ${am.colony}, ${am.pinCodeModel.city}....",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text("Pin code : ${am.pinCode}"),
              Text("Phone : ${am.phone}"),
            ],
          ),
        ),
        Positioned(
          top: 6,
          right: 15,
          child: TextButton(
            child: const Text(
              "Change",
              style: TextStyle(color: primaryColor),
            ),
            onPressed: () async {
              await Future.delayed(const Duration(milliseconds: 500));
              Get.bottomSheet(backgroundColor: Colors.white, listAddresses());
            },
          ),
        ),
      ],
    );
  }

  Widget listAddresses() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Text("Select address (or) "),
              ),
              TextButton(
                  onPressed: () async {
                    await waitMilli();
                    Get.back();
                    Get.to(() => const AddressEditScreen(null));
                  },
                  child: const Text("Add new")),
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(MdiIcons.close)),
            ],
          ),
          FirestoreListView<Map<String, dynamic>>(
              shrinkWrap: true,
              loadingBuilder: (context) {
                return const GFLoader();
              },
              query: addressMOs.addressCR
                  .orderBy(addressMOs.updatedTime, descending: true),
              itemBuilder: ((context, doc) {
                var am = AddressModel.fromMap(doc.data());
                am.docRef = doc.reference;
                return InkWell(
                  child: Card(
                    elevation: 4,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(am.name),
                              Text(
                                "${am.house}, ${am.colony}, ${am.pinCodeModel.city}....",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text("Pin code : ${am.pinCode}"),
                              Text("Phone : ${am.phone}"),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: TextButton(
                              onPressed: () async {
                                await waitMilli();
                                Get.to(() => AddressEditScreen(am));
                              },
                              child: const Text(
                                "Edit",
                                style: TextStyle(color: Colors.blue),
                              )),
                        )
                      ],
                    ),
                  ),
                  onTap: () async {
                    await am.docRef!.update({
                      addressMOs.updatedTime: Timestamp.fromDate(DateTime.now())
                    });
                    Get.back();
                  },
                );
              })),
        ],
      ),
    );
  }

  Widget latestAddressW() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: addressMOs.addressCR
            .orderBy(addressMOs.updatedTime, descending: true)
            .limit(1)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return waitingW();
          }
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            var am = AddressModel.fromMap(snapshot.data!.docs.first.data());
            return validAaddressW(am);
          }
          return addAddressW();
        });
  }

  Widget addAddressW() {
    return GFListTile(
      color: Colors.white,
      avatar: const Icon(MdiIcons.homePlus, color: Colors.blue),
      title: const Text("No address found to deliver"),
      subTitle: const Text("Click to Add delivery address"),
      onTap: () async {
        await Future.delayed(const Duration(milliseconds: 500));
        Get.to(() => const AddressEditScreen(null));
      },
    );
  }

  Widget waitingW() {
    return const GFListTile(
      title: GFLoader(type: GFLoaderType.circle),
    );
  }
}
