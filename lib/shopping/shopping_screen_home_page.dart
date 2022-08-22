import 'package:advaithaunnathi/dart/firebase.dart';
import 'package:advaithaunnathi/shopping/Home%20screen%20w/a_offers_corosal.dart';
import 'package:advaithaunnathi/shopping/Home%20screen%20w/b_shopping_cat_w.dart';
import 'package:advaithaunnathi/shopping/Home%20screen%20w/c_products_grid_list.dart';
import 'package:advaithaunnathi/shopping/z_cart/cart_screen.dart';
import 'package:advaithaunnathi/user/user_account_screen.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../custom widgets/bottom_bar_login.dart';
import '../dart/colors.dart';
import '../dart/repeatFunctions.dart';
import '../fcm.dart';
import '../model/cart_model.dart';
import '../model/user_model.dart';

class ShoppingScreenHomePage extends StatefulWidget {
  const ShoppingScreenHomePage({Key? key}) : super(key: key);

  @override
  State<ShoppingScreenHomePage> createState() => _ShoppingScreenHomePageState();
}

class _ShoppingScreenHomePageState extends State<ShoppingScreenHomePage> {
  @override
  void initState() {
    FCMfunctions.setupInteractedMessage();
    FCMfunctions.onMessage();
    FCMfunctions.checkFCMtoken();
    umos.userInit();
    super.initState();
  }

  //
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("MyShop"),
              actions: [
                IconButton(
                  onPressed: () {
                    if (snapshot.hasData) {
                      Get.to(() => const UserAccountScreen());
                    } else {
                      bottomBarLogin();
                    }
                  },
                  icon: const Icon(MdiIcons.accountCircleOutline),
                ),
                IconButton(
                  onPressed: () async {
                    waitMilli(200);
                    Get.to(() => const CartScreen());
                  },
                  icon: cartBadge(),
                ),
              ],
            ),
            // drawer: (snapshot.hasData)
            //     ? Drawer(
            //         // backgroundColor: Colors.pink.shade100,
            //         width: Get.width - 50,
            //         child: drawerItems(),
            //       )
            //     : null,
            body: ListView(
              children: const [
                OffersCarousel(),
                ShoppingCatW(),
                SizedBox(height: 10),
                ProductsGridList(),
                SizedBox(height: 60),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("V_1.0.2\nDated 23 Aug 2022, 12:05am"),
                ),
              ],
            ),
          );
        });
  }

  Widget cartBadge() {
    var cartIcon = const Icon(MdiIcons.cart);

    return Obx(() => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: userCartCR.value.limit(6).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            if (snapshot.data!.docs.length > 5) {
              return Badge(
                  badgeColor: Colors.purple,
                  badgeContent: const Text(
                    "5+",
                    style: TextStyle(color: Colors.white),
                  ),
                  child: cartIcon);
            } else {
              return Badge(
                  badgeColor: Colors.purple,
                  badgeContent: Text(
                    snapshot.data!.docs.length.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  child: cartIcon);
            }
          }
          return cartIcon;
        }));
  }

  Widget drawerItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: primaryColor,
          height: 90,
          width: double.maxFinite,
          child: const Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "\nMENU",
                textScaleFactor: 1.2,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextButton(
                  onPressed: () {
                    Get.to(() => const UserAccountScreen());
                  },
                  child: Row(
                    children: const [
                      Icon(MdiIcons.accountCircleOutline),
                      SizedBox(width: 10),
                      Text("Profile"),
                    ],
                  )),
              TextButton(
                  onPressed: () {},
                  child: Row(
                    children: const [
                      Icon(MdiIcons.orderBoolAscending),
                      SizedBox(width: 10),
                      Text("Orders"),
                    ],
                  )),
              TextButton(
                  onPressed: () {},
                  child: Row(
                    children: const [
                      Icon(MdiIcons.accountGroup),
                      SizedBox(width: 10),
                      Text("Prime"),
                    ],
                  )),
              if (fireUser() != null)
                TextButton(
                    onPressed: () {},
                    child: Row(
                      children: const [
                        Icon(MdiIcons.logout),
                        SizedBox(width: 10),
                        Text("Logout"),
                      ],
                    )),
              if (fireUser() == null)
                TextButton(
                    onPressed: () {},
                    child: Row(
                      children: const [
                        Icon(MdiIcons.login),
                        SizedBox(width: 10),
                        Text("Login"),
                      ],
                    )),
            ],
          ),
        ),
      ],
    );
  }
}
